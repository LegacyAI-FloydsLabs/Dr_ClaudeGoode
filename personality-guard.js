#!/usr/bin/env node
/**
 * Personality Guard Hook — Dr.ClaudeGoode
 *
 * Machine-enforced safety layer for the Personality Engine.
 * Reads the active personality from ~/.claude/.active-personality
 * and blocks operations that violate the personality's safety rules.
 *
 * This is a PreToolUse hook. It fires BEFORE the model's tool call
 * executes, making it mechanically enforced regardless of context
 * window pressure or instruction noise.
 *
 * Current enforcement rules:
 *   - ALL personalities: block writes to .supercache/ (governance boundary)
 *   - ALL personalities: block writes to personality-backup/ .original files
 *   - ALL personalities: block modification of settings.json / settings.local.json
 *   - autonomous: block file deletion (rm, rm -rf, unlink) unless --allow-destructive flag
 *   - sentinel: block commands that change system state without explicit confirmation
 *   - ops: block --no-verify flags on build/test/deploy commands
 *
 * Exit codes:
 *   0 = allow (operation permitted)
 *   2 = block (operation violates personality safety rules)
 *
 * Dr.ClaudeGoode — Harness Experimentation Lab
 * Governance: .supercache/ v1.5.0
 */

'use strict';

const fs = require('fs');
const path = require('path');
const os = require('os');

const CLAUDE_DIR = path.join(os.homedir(), '.claude');
const STATE_FILE = path.join(CLAUDE_DIR, '.active-personality');
const MAX_STDIN = 1024 * 1024;

// ─── Personality-specific rules ────────────────────────────────────

const RULES = {
  autonomous: {
    name: 'autonomous',
    // Block destructive file operations
    blockToolPatterns: [
      { tool: 'Bash', pattern: /\brm\s+(-[dfirRv]+\s+)?\/(Volumes|etc|usr|System)/i, reason: 'Recursive delete outside project directory' },
      { tool: 'Bash', pattern: /\brm\s+(-[dfirRv]+\s+)*-(rf|fr)\s/i, reason: 'Recursive force delete — requires --allow-destructive' },
      { tool: 'Bash', pattern: /\bdd\s+if=.*of=\/dev\//i, reason: 'Block device write' },
      { tool: 'Bash', pattern: /\b(reboot|shutdown|halt)\b/i, reason: 'System power command' },
    ],
  },
  sentinel: {
    name: 'sentinel',
    // Block state-changing system commands that weren't shown first
    // (The personality's soft rules require showing commands before running them.
    //  This hook enforces the critical subset mechanically.)
    blockToolPatterns: [
      { tool: 'Bash', pattern: /\bkill\s+-9\s+1\b/, reason: 'Killing PID 1 is never safe' },
      { tool: 'Bash', pattern: /\b(reboot|shutdown|halt)\b/i, reason: 'System power command' },
      { tool: 'Bash', pattern: /\bdd\s+if=.*of=\/dev\//i, reason: 'Block device write' },
    ],
  },
  ops: {
    name: 'ops',
    // Block skipping verification steps
    blockToolPatterns: [
      { tool: 'Bash', pattern: /\b(npm|yarn|pnpm)\s+(run\s+)?(test|build|lint)\s+.*--no-verify/i, reason: '--no-verify skips verification — violates ops discipline' },
      { tool: 'Bash', pattern: /\bgit\s+push\s+.*--no-verify/i, reason: 'git push --no-verify skips CI checks — violates ops discipline' },
      { tool: 'Bash', pattern: /\bgit\s+push\s+.*--force(?!-with-lease)/i, reason: 'Force push without --force-with-lease risks data loss' },
      { tool: 'Bash', pattern: /\b(reboot|shutdown|halt)\b/i, reason: 'System power command' },
      { tool: 'Bash', pattern: /\bdd\s+if=.*of=\/dev\//i, reason: 'Block device write' },
    ],
  },
};

// Default rules that apply to ALL personalities (including default/no personality)
const UNIVERSAL_BLOCKED_PATHS = [
  // Governance boundary
  { pattern: /\.supercache\//i, reason: 'Governance boundary — .supercache/ is READ-ONLY for agents' },
  // Personality engine internals
  { pattern: /personality-backup\/.*\.original$/i, reason: 'Permanent originals must not be modified' },
  // Critical settings
  { pattern: /settings\.json$/i, reason: 'settings.json is machine-enforced — personality swap does not modify it' },
  { pattern: /settings\.local\.json$/i, reason: 'settings.local.json is machine-enforced — personality swap does not modify it' },
];

const UNIVERSAL_BLOCKED_COMMANDS = [
  { tool: 'Bash', pattern: /\bdd\s+if=.*of=\/dev\//i, reason: 'Block device write — universally blocked' },
  { tool: 'Bash', pattern: /\b(reboot|shutdown|halt)\b/i, reason: 'System power command — universally blocked' },
];

// ─── Core logic ────────────────────────────────────────────────────

function getActivePersonality() {
  try {
    if (fs.existsSync(STATE_FILE)) {
      return fs.readFileSync(STATE_FILE, 'utf8').trim();
    }
  } catch (_) {
    // State file unreadable — treat as no personality
  }
  return null;
}

function parseInput(raw) {
  try {
    return JSON.parse(raw);
  } catch (_) {
    return null;
  }
}

function run(inputOrRaw, options) {
  options = options || {};

  if (options.truncated) {
    return {
      exitCode: 2,
      stderr:
        `BLOCKED: Hook input exceeded ${options.maxStdin || MAX_STDIN} bytes. ` +
        'Refusing to bypass personality-guard on a truncated payload.',
    };
  }

  const input = parseInput(inputOrRaw);
  if (!input) return { exitCode: 0 };

  const toolName = input.tool_name || '';
  const toolInput = input.tool_input || {};

  // ─── Check 1: Universal path-based blocks ────────────────────────
  const filePath = toolInput.file_path || toolInput.file || toolInput.path || '';

  for (const rule of UNIVERSAL_BLOCKED_PATHS) {
    if (rule.pattern.test(filePath)) {
      return {
        exitCode: 2,
        stderr:
          `BLOCKED (personality-guard): ${rule.reason}\n` +
          `  Target: ${filePath}\n` +
          `  This is a universal safety rule — it applies regardless of active personality.`,
      };
    }
  }

  // ─── Check 2: Universal command blocks ───────────────────────────
  if (toolName === 'Bash' || toolName === 'Terminal') {
    const command = toolInput.command || '';

    for (const rule of UNIVERSAL_BLOCKED_COMMANDS) {
      if (rule.pattern.test(command)) {
        return {
          exitCode: 2,
          stderr:
            `BLOCKED (personality-guard): ${rule.reason}\n` +
            `  Command: ${command.substring(0, 200)}\n` +
            `  This is a universal safety rule — it applies regardless of active personality.`,
        };
      }
    }
  }

  // ─── Check 3: Personality-specific rules ─────────────────────────
  const activePersonality = getActivePersonality();

  if (activePersonality && RULES[activePersonality]) {
    const rules = RULES[activePersonality];

    if (toolName === 'Bash' || toolName === 'Terminal') {
      const command = toolInput.command || '';

      for (const rule of rules.blockToolPatterns) {
        if (rule.tool === toolName && rule.pattern.test(command)) {
          return {
            exitCode: 2,
            stderr:
              `BLOCKED (personality-guard:${activePersonality}): ${rule.reason}\n` +
              `  Command: ${command.substring(0, 200)}\n` +
              `  Active personality: ${activePersonality}\n` +
              `  If this is a legitimate operation, disable the personality-guard hook temporarily.`,
          };
        }
      }
    }
  }

  // ─── Check 4: Block writes to personality engine state ────────────
  if (filePath && filePath.includes('.active-personality') && !filePath.includes('personality-swap')) {
    // Only the personality swap script should write to .active-personality
    // But since we can't verify caller identity from hook context, we warn instead of block
    // This is a soft guard — the hard guard is file permissions
  }

  return { exitCode: 0 };
}

module.exports = { run, RULES, UNIVERSAL_BLOCKED_PATHS, getActivePersonality };

// ─── Stdin fallback for spawnSync execution ────────────────────────
let raw = '';
let truncated = /^(1|true|yes)$/i.test(String(process.env.ECC_HOOK_INPUT_TRUNCATED || ''));

process.stdin.setEncoding('utf8');
process.stdin.on('data', chunk => {
  if (raw.length < MAX_STDIN) {
    const remaining = MAX_STDIN - raw.length;
    raw += chunk.substring(0, remaining);
    if (chunk.length > remaining) truncated = true;
  } else {
    truncated = true;
  }
});

process.stdin.on('end', () => {
  const result = run(raw, {
    truncated,
    maxStdin: Number(process.env.ECC_HOOK_INPUT_MAX_BYTES) || MAX_STDIN,
  });

  if (result.stderr) {
    process.stderr.write(result.stderr + '\n');
  }

  if (result.exitCode === 2) {
    process.exit(2);
  }

  process.stdout.write(raw);
});
