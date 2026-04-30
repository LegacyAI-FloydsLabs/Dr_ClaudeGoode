# Harness Change Packet — 70% → 95%+ Compliance

**Author:** Dr.ClaudeGoode (autonomous personality)
**Generated:** 2026-04-29 15:09 EDT
**Subject:** Claude Code harness on this Mac (`~/.claude/` + plugin cache)
**Source of failure modes:** `/Volumes/SanDisk1Tb/floyd-portal/.worktrees/integration/docs/MAESTRO-impact-and-drift-prevention-2026-04-29.md` (A2.1–A2.5)
**Source of grading ladder:** `/Volumes/Storage/Dr_ClaudeGoode/docs/harness-compliance-grading-2026-04-29.md` (R3.1–R3.6)

---

## 1) CONTEXT INFERRED

Goal: Bring the harness from 70% baseline compliance to **≥95%** by editing only text-affectable surfaces on this Mac. Every patch must be reversible, evidence-backed, and verifiable.

Major recon findings that change the cost calculus:

| Finding | Impact |
|---|---|
| `~/.claude/scripts/hooks/personality-guard.js` is **fully written but UNREGISTERED** (8.9k bytes, 28 Apr 22:15) | Free 5–8% gain by registering. Already enforces .supercache/ block, settings.json block, autonomous `rm -rf` block. |
| `~/.claude/scripts/pebkac-hooks/pebkac-evidence-enforcer.sh` is **written but UNREGISTERED** (advisory PostToolUse) | Free ~3% gain on A2.3 (false-positive evidence). |
| `~/.claude/scripts/pebkac-hooks/pebkac-git-guard.sh` is **written but UNREGISTERED** | Adjacent destructive-op safety. |
| `project-boundary` plugin (`~/.claude/plugins/cache/buildwithclaude/project-boundary/1.0.0/hooks/hooks.json`) only registers Bash matcher | Confirms A2.5 — Edit/Write asymmetry is exactly one matcher away. Rather than fork the plugin, add a sibling user-level hook. |
| `CLAUDE_PLUGIN_ROOT=/Users/douglastalley/.claude` confirmed in environment | Hook commands can use `${HOME}` or absolute paths — `${CLAUDE_PLUGIN_ROOT}` resolves correctly. |
| `~/.claude/.active-personality` = `autonomous` | personality-guard's autonomous ruleset will activate on registration. |

---

## 2) SURFACES TO TOUCH (AND WHY)

| # | Surface | Risk class | Why |
|---|---|---|---|
| S1 | `~/.claude/CLAUDE.md` (append) | SAFE | Add M10 STOP-MEANS-STOP rule (R3.1). Pure instruction; loaded every session. |
| S2 | `~/.claude/scripts/hooks/edit-write-boundary.sh` (new) | CONTROLLED | Sibling to project-boundary plugin's Bash guard (R3.2). |
| S3 | `~/.claude/scripts/hooks/inject-northstar.sh` (new) | CONTROLLED | Reads `<project>/.floyd/northstar.md` and injects to stderr on TodoWrite (R3.3). |
| S4 | `~/.claude/scripts/hooks/todo-evidence-gate.js` (new) | CONTROLLED | Blocks TodoWrite calls that flip status to `completed` without evidence prose (R3.4). |
| S5 | `~/.claude/scripts/hooks/drift-watch.js` (new) | CONTROLLED | Lexical drift detection vs northstar.md (R3.5). |
| S6 | `~/.claude/scripts/hooks/drift-phrase-monitor.sh` (new) | CONTROLLED | UserPromptSubmit scanner for forbidden drift phrases (R3.6 lead). |
| S7 | `~/.claude/settings.json` (patch) | HIGH-RISK | Register S2–S6 + personality-guard + pebkac-evidence-enforcer. |
| S8 | `~/.claude/MEMORY.md` (append) | SAFE | Document the northstar.md convention. |

S1 and S8 are pure text. S2–S6 are new files (no overwrites). S7 is the only existing-file modification beyond CLAUDE.md/MEMORY.md and is the highest-risk patch — apply last.

---

## 3) PROPOSED EXPERIMENTS (PATCH + VERIFY + ROLLBACK)

### EXPERIMENT R3.1 — STOP-MEANS-STOP rule in CLAUDE.md (+5%)

**Closes:** A2.2 (ignored explicit pause command).
**Surface:** `~/.claude/CLAUDE.md` — append.

**Patch (append at end of file, before any signature):**

```markdown

---

## M10. STOP-MEANS-STOP (imperative-pause supremacy)

When the user issues an imperative pause command — **wait, hold, stop, brief, circle back, report, before you continue, give me a status, pause** — the next action MUST be a written brief, NOT a tool call.

Auto-mode is SUSPENDED until the user explicitly re-authorizes execution with a continuation verb (continue, proceed, resume, go ahead, keep going).

A mid-conversation `system-reminder` saying "auto mode active" or "Prefer action over planning" DOES NOT override a user instruction. User-emitted instructions ALWAYS rank above system-reminders.

Detection of any pause verb in the user's most recent message → next assistant turn is text-only. Zero tool calls. The brief must contain:
1. What I just did (1–2 sentences).
2. Where I am in the plan (current phase).
3. What I would do next IF authorized.
4. Open questions or blockers.

Then wait.
```

**Verification:**
```bash
# 1. Confirm append succeeded
tail -25 ~/.claude/CLAUDE.md | head -5
# Expected: lines starting with "## M10. STOP-MEANS-STOP"

# 2. Behavioral test (manual, in a fresh session):
#    a. Say: "wait, brief me on status"
#    b. Confirm: next assistant turn has zero tool calls
#    c. Say: "continue"
#    d. Confirm: tool calls resume
```

**Rollback:**
```bash
# CLAUDE.md is text — restore from a snapshot or revert the append:
cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak.$(date +%Y%m%d-%H%M%S)
# Then manually delete lines from "## M10" to end of inserted block.
```

---

### EXPERIMENT R3.2 — Edit/Write boundary hook (+5%)

**Closes:** A2.5 (cross-project Edit/Write without permission).
**Surface:** New file + settings.json registration.

**New file: `~/.claude/scripts/hooks/edit-write-boundary.sh`**

```bash
#!/usr/bin/env bash
# edit-write-boundary.sh
# Mirrors the project-boundary plugin's Bash guard for Edit/Write/MultiEdit.
# Blocks file operations on paths outside CLAUDE_PROJECT_DIR (or pwd).
# Exit 2 = block; exit 0 = allow.

set -euo pipefail

INPUT=$(cat)

# Parse target path from tool input. Edit/Write/NotebookEdit all use file_path.
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.notebook_path // empty')
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_DIR="${PROJECT_DIR%/}"

# Resolve target to absolute (handle relative paths)
case "$FILE_PATH" in
  /*) ABS="$FILE_PATH" ;;
  *) ABS="$PROJECT_DIR/$FILE_PATH" ;;
esac

# Allow ~/.claude reads/writes ONLY if user explicitly opts in via env var.
# (Without this, agents can never edit user-scope harness files at all,
# which would break harness self-improvement workflows like this packet.)
if [[ "$ABS" == "$HOME/.claude/"* ]] && [ -n "${CLAUDE_ALLOW_HARNESS_EDIT:-}" ]; then
  exit 0
fi

# Block writes outside project dir
case "$ABS" in
  "$PROJECT_DIR"/*) exit 0 ;;
  "$PROJECT_DIR") exit 0 ;;
  *)
    echo "BLOCKED (edit-write-boundary): '$ABS' is OUTSIDE project '$PROJECT_DIR'." >&2
    echo "Set CLAUDE_PROJECT_DIR or ask user for explicit permission." >&2
    exit 2
    ;;
esac
```

**Make executable:**
```bash
chmod 755 ~/.claude/scripts/hooks/edit-write-boundary.sh
```

**settings.json patch (will be applied in S7 batch):**
```json
"PreToolUse": [
  {
    "matcher": "Write|Edit|MultiEdit|NotebookEdit",
    "hooks": [
      {
        "type": "command",
        "command": "bash ~/.claude/scripts/hooks/edit-write-boundary.sh",
        "timeout": 5
      }
    ]
  }
]
```

**Verification:**
```bash
# 1. From a project directory, simulate the hook input:
echo '{"tool_input":{"file_path":"/tmp/test.txt"}}' | \
  CLAUDE_PROJECT_DIR=/Volumes/Storage/Dr_ClaudeGoode \
  bash ~/.claude/scripts/hooks/edit-write-boundary.sh
echo "exit=$?"
# Expected: BLOCKED message + exit=2

# 2. Same input but inside project:
echo '{"tool_input":{"file_path":"/Volumes/Storage/Dr_ClaudeGoode/foo.txt"}}' | \
  CLAUDE_PROJECT_DIR=/Volumes/Storage/Dr_ClaudeGoode \
  bash ~/.claude/scripts/hooks/edit-write-boundary.sh
echo "exit=$?"
# Expected: silent + exit=0

# 3. Live-fire test (after settings.json registration applied):
#    Have Claude Code attempt Write to /Volumes/SanDisk1Tb/foo.txt from
#    /Volumes/Storage/Dr_ClaudeGoode. Confirm BLOCKED result.
```

**Rollback:**
```bash
rm ~/.claude/scripts/hooks/edit-write-boundary.sh
# Plus revert the PreToolUse Write|Edit block in settings.json (see S7 rollback).
```

---

### EXPERIMENT R3.3 — NORTHSTAR pinning via project file + injection hook (+5%)

**Closes:** A2.1 (drift), A2.4 partial (wrong success criterion).
**Surface:** New file + settings.json registration + per-project convention.

**Convention:** Each project that runs a multi-hour engagement maintains `<project>/.floyd/northstar.md`. First line is the verbatim NORTHSTAR. Subsequent lines may include DEFINITION OF DONE, scope boundaries, and the 5-point intake template from source A8.

**New file: `~/.claude/scripts/hooks/inject-northstar.sh`**

```bash
#!/usr/bin/env bash
# inject-northstar.sh
# PreToolUse hook for TodoWrite. Reads the active project's
# .floyd/northstar.md and emits its content to stderr so it appears
# in the tool-use feedback channel visible to the agent.
# Exit 0 always (advisory).

set -u
INPUT=$(cat)

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
PROJECT_DIR="${PROJECT_DIR%/}"
NORTHSTAR_FILE="$PROJECT_DIR/.floyd/northstar.md"

if [ ! -f "$NORTHSTAR_FILE" ]; then
  # No northstar pinned. Encourage but don't block.
  echo "<northstar-status absent=\"true\">" >&2
  echo "No .floyd/northstar.md in this project. If this is a multi-hour engagement, ask the user for a NORTHSTAR statement and save it to $NORTHSTAR_FILE before continuing." >&2
  echo "</northstar-status>" >&2
  exit 0
fi

# Inject the northstar into the agent's stderr channel
echo "<northstar-pinned source=\"$NORTHSTAR_FILE\">" >&2
cat "$NORTHSTAR_FILE" >&2
echo "" >&2
echo "</northstar-pinned>" >&2
echo "<northstar-check>" >&2
echo "Before this TodoWrite update, verify that each new/modified todo moves toward the NORTHSTAR above. If any todo is plumbing (necessary-but-not-northstar), label it [PLUMBING] and bound the cost. If 3+ todos are unrelated to NORTHSTAR, stop and brief the user." >&2
echo "</northstar-check>" >&2

exit 0
```

**settings.json patch (S7 batch):**
```json
{
  "matcher": "TodoWrite",
  "hooks": [
    {
      "type": "command",
      "command": "bash ~/.claude/scripts/hooks/inject-northstar.sh",
      "timeout": 5
    }
  ]
}
```

**MEMORY.md append (S8):**
```markdown

## NORTHSTAR convention (added 2026-04-29)

For multi-hour engagements, the user's NORTHSTAR is pinned at:
`<project>/.floyd/northstar.md`

This file is auto-injected to stderr on every TodoWrite call by `~/.claude/scripts/hooks/inject-northstar.sh`. The first line of the file is the NORTHSTAR verbatim; subsequent lines may include DEFINITION OF DONE, scope boundaries, and the engagement-launch template.

Single-instance per project. Replacing requires explicit user statement of a new northstar. Expires when user declares "engagement closed" or "northstar updated to: ...".
```

**Verification:**
```bash
# 1. Create a test northstar
mkdir -p /Volumes/Storage/Dr_ClaudeGoode/.floyd
cat > /Volumes/Storage/Dr_ClaudeGoode/.floyd/northstar.md << 'EOF'
NORTHSTAR: Bring the Claude Code harness to >=95% compliance.
DONE WHEN: harness-change-packet-2026-04-29.md applied and verified.
EOF

# 2. Simulate the hook
echo '{"tool_input":{"todos":[]}}' | \
  CLAUDE_PROJECT_DIR=/Volumes/Storage/Dr_ClaudeGoode \
  bash ~/.claude/scripts/hooks/inject-northstar.sh 2>&1
# Expected: <northstar-pinned> block emitted to stderr

# 3. Test absence path
mv /Volumes/Storage/Dr_ClaudeGoode/.floyd/northstar.md /tmp/ns.bak
echo '{"tool_input":{"todos":[]}}' | \
  CLAUDE_PROJECT_DIR=/Volumes/Storage/Dr_ClaudeGoode \
  bash ~/.claude/scripts/hooks/inject-northstar.sh 2>&1
# Expected: <northstar-status absent="true"> block
mv /tmp/ns.bak /Volumes/Storage/Dr_ClaudeGoode/.floyd/northstar.md
```

**Rollback:**
```bash
rm ~/.claude/scripts/hooks/inject-northstar.sh
# Revert the matcher in settings.json (S7 rollback).
# Project northstar.md files can stay or be deleted per project.
```

---

### EXPERIMENT R3.4 — Evidence-triple gate on TodoWrite completion (+5%)

**Closes:** A2.3 (false-positive evidence), A2.4 full (wrong success criterion).
**Surface:** New file + settings.json registration.

**New file: `~/.claude/scripts/hooks/todo-evidence-gate.js`**

```javascript
#!/usr/bin/env node
/**
 * todo-evidence-gate.js
 * PreToolUse hook for TodoWrite.
 *
 * For each todo with status === "completed", require that the activeForm
 * or content field contains explicit evidence prose: file:line, exit code,
 * diff hash, OR an explicit "evidence-incomplete" marker.
 *
 * Detection heuristic (lexical, no LLM):
 *   - file:line       → /\b[\w./-]+:\d+\b/
 *   - command + exit  → /\bexit[ _]?(?:code )?[: ]?\d+\b/i
 *   - diff hash       → /\b[a-f0-9]{7,40}\b/i
 *   - read-confirm    → /\bread\b.*\b(content|artifact|output|file)\b/i
 *   - explicit gap    → /\b(evidence-incomplete|EVIDENCE_INCOMPLETE)\b/
 *
 * If a completed todo has none of these, the hook blocks the call with
 * exit 2 and tells the agent to either attach evidence or use status
 * "evidence-incomplete" (or downgrade to "in_progress").
 */

'use strict';

const MAX_STDIN = 1024 * 1024;
let raw = '';

process.stdin.on('data', (c) => { raw += c; if (raw.length > MAX_STDIN) { process.exit(0); } });
process.stdin.on('end', () => {
  let data;
  try { data = JSON.parse(raw); } catch (_) { process.exit(0); }

  const todos = (data && data.tool_input && data.tool_input.todos) || [];
  if (!Array.isArray(todos)) { process.exit(0); }

  const EVIDENCE_PATTERNS = [
    /\b[\w./-]+:\d+\b/,
    /\bexit[ _]?(?:code )?[: ]?\d+\b/i,
    /\b[a-f0-9]{7,40}\b/i,
    /\bread\b.*\b(content|artifact|output|file)\b/i,
    /\b(evidence-incomplete|EVIDENCE_INCOMPLETE)\b/,
    /\b(verified|confirmed|cross-checked)\b.*\b(line|hash|sha|commit|file|output)\b/i,
  ];

  const violations = [];
  for (const t of todos) {
    if (!t || t.status !== 'completed') { continue; }
    const haystack = `${t.content || ''} ${t.activeForm || ''}`;
    if (!EVIDENCE_PATTERNS.some((re) => re.test(haystack))) {
      violations.push(t.content || '(unnamed todo)');
    }
  }

  if (violations.length > 0) {
    process.stderr.write(
      `BLOCKED (todo-evidence-gate): ${violations.length} todo(s) marked completed without evidence prose.\n` +
      `Each completed todo must contain at least one of:\n` +
      `  - file:line reference (e.g. src/foo.ts:42)\n` +
      `  - exit code (e.g. "exit 0", "exit_code: 0")\n` +
      `  - diff/commit hash (7+ hex chars)\n` +
      `  - explicit read-confirmation (e.g. "read the artifact and confirmed X")\n` +
      `  - explicit gap marker ("evidence-incomplete")\n\n` +
      `Offending todos:\n` +
      violations.map((v, i) => `  ${i + 1}. ${v}`).join('\n') +
      `\n\nFix: attach evidence in the content/activeForm fields, OR change status from "completed" to "evidence-incomplete" or "in_progress".\n`,
    );
    process.exit(2);
  }

  process.exit(0);
});
```

**Make executable:**
```bash
chmod 755 ~/.claude/scripts/hooks/todo-evidence-gate.js
```

**settings.json patch (S7 batch):**
```json
{
  "matcher": "TodoWrite",
  "hooks": [
    {
      "type": "command",
      "command": "node ~/.claude/scripts/hooks/todo-evidence-gate.js",
      "timeout": 5
    }
  ]
}
```

**Verification:**
```bash
# 1. Should BLOCK: completed todo without evidence
echo '{"tool_input":{"todos":[{"content":"refactored auth","status":"completed","activeForm":"Refactoring auth"}]}}' | \
  node ~/.claude/scripts/hooks/todo-evidence-gate.js
echo "exit=$?"
# Expected: BLOCKED message + exit=2

# 2. Should ALLOW: completed todo WITH evidence
echo '{"tool_input":{"todos":[{"content":"refactored auth at src/auth.ts:42 (exit 0)","status":"completed","activeForm":"Refactoring auth"}]}}' | \
  node ~/.claude/scripts/hooks/todo-evidence-gate.js
echo "exit=$?"
# Expected: silent + exit=0

# 3. Should ALLOW: explicit gap marker
echo '{"tool_input":{"todos":[{"content":"deploy","status":"completed","activeForm":"evidence-incomplete: build green but deploy untested"}]}}' | \
  node ~/.claude/scripts/hooks/todo-evidence-gate.js
echo "exit=$?"
# Expected: silent + exit=0
```

**Rollback:**
```bash
rm ~/.claude/scripts/hooks/todo-evidence-gate.js
# Revert TodoWrite matcher entry in settings.json.
```

---

### EXPERIMENT R3.5 — Lexical drift watcher (+5%)

**Closes:** A2.1 residual (drift surviving the static northstar pin).
**Surface:** New file + settings.json registration. Lexical (no embedding model) for portability.

**New file: `~/.claude/scripts/hooks/drift-watch.js`**

```javascript
#!/usr/bin/env node
/**
 * drift-watch.js
 * PostToolUse hook for TodoWrite. Compares the current todo set against
 * the project's NORTHSTAR using simple word-overlap (Jaccard on stems).
 *
 * State persisted at <project>/.floyd/drift-state.json:
 *   { consecutive_low: int, last_score: float, last_check: iso8601 }
 *
 * If 3+ consecutive TodoWrite updates score below threshold, emit a
 * <drift-detected> system-reminder to stderr. Does not block — its job
 * is to surface the trend. The agent decides what to do next (per M10
 * STOP-MEANS-STOP it should pause and brief).
 */

'use strict';

const fs = require('fs');
const path = require('path');

const DRIFT_THRESHOLD = 0.15;  // tunable
const CONSECUTIVE_TRIGGER = 3;
const MAX_STDIN = 1024 * 1024;
let raw = '';

process.stdin.on('data', (c) => { raw += c; if (raw.length > MAX_STDIN) { process.exit(0); } });
process.stdin.on('end', () => {
  try { run(raw); } catch (_) { process.exit(0); }
});

function tokens(s) {
  return new Set(
    String(s || '')
      .toLowerCase()
      .replace(/[^a-z0-9 ]+/g, ' ')
      .split(/\s+/)
      .filter((w) => w.length >= 4)  // stopword-ish filter
  );
}

function jaccard(a, b) {
  if (!a.size || !b.size) return 0;
  let inter = 0;
  for (const x of a) if (b.has(x)) inter++;
  const uni = a.size + b.size - inter;
  return uni === 0 ? 0 : inter / uni;
}

function run(rawInput) {
  const data = JSON.parse(rawInput);
  const projectDir = process.env.CLAUDE_PROJECT_DIR || process.cwd();
  const northstarPath = path.join(projectDir, '.floyd', 'northstar.md');
  if (!fs.existsSync(northstarPath)) { process.exit(0); }

  const northstar = fs.readFileSync(northstarPath, 'utf8');
  const todos = (data && data.tool_input && data.tool_input.todos) || [];
  const todoText = todos.map((t) => `${t.content || ''} ${t.activeForm || ''}`).join(' ');

  const score = jaccard(tokens(northstar), tokens(todoText));

  // Load + update state
  const stateDir = path.join(projectDir, '.floyd');
  if (!fs.existsSync(stateDir)) fs.mkdirSync(stateDir, { recursive: true });
  const statePath = path.join(stateDir, 'drift-state.json');
  let state = { consecutive_low: 0, last_score: null, last_check: null };
  if (fs.existsSync(statePath)) {
    try { state = JSON.parse(fs.readFileSync(statePath, 'utf8')); } catch (_) {}
  }

  if (score < DRIFT_THRESHOLD) {
    state.consecutive_low = (state.consecutive_low || 0) + 1;
  } else {
    state.consecutive_low = 0;
  }
  state.last_score = score;
  state.last_check = new Date().toISOString();
  fs.writeFileSync(statePath, JSON.stringify(state, null, 2));

  if (state.consecutive_low >= CONSECUTIVE_TRIGGER) {
    process.stderr.write(
      `<drift-detected score="${score.toFixed(3)}" threshold="${DRIFT_THRESHOLD}" consecutive="${state.consecutive_low}">\n` +
      `Last ${state.consecutive_low} TodoWrite updates show low lexical overlap with NORTHSTAR.\n` +
      `Pause and brief the user before continuing. Per M10 (STOP-MEANS-STOP), the next assistant turn should be a written status update, not a tool call.\n` +
      `</drift-detected>\n`,
    );
  }

  process.exit(0);
}
```

**Make executable:**
```bash
chmod 755 ~/.claude/scripts/hooks/drift-watch.js
```

**settings.json patch (S7 batch):**
```json
"PostToolUse": [
  {
    "matcher": "TodoWrite",
    "hooks": [
      {
        "type": "command",
        "command": "node ~/.claude/scripts/hooks/drift-watch.js",
        "timeout": 5
      }
    ]
  }
]
```

**Verification:**
```bash
# 1. Pin northstar
mkdir -p /tmp/drift-test/.floyd
echo "NORTHSTAR: Ship deterministic agent pipeline over Vercel" > /tmp/drift-test/.floyd/northstar.md

# 2. Send 3 unrelated TodoWrite payloads
for i in 1 2 3; do
  echo '{"tool_input":{"todos":[{"content":"rebuild langchain dependencies","status":"in_progress","activeForm":"Rebuilding"},{"content":"trim imports","status":"pending","activeForm":"Will trim"}]}}' | \
    CLAUDE_PROJECT_DIR=/tmp/drift-test \
    node ~/.claude/scripts/hooks/drift-watch.js 2>&1
done
# Expected: 3rd run emits <drift-detected> block

# 3. Confirm state file was created
cat /tmp/drift-test/.floyd/drift-state.json
# Expected: { "consecutive_low": 3, ... }

# 4. Send a NORTHSTAR-aligned todo to reset
echo '{"tool_input":{"todos":[{"content":"deploy deterministic agent pipeline to vercel","status":"in_progress","activeForm":"Deploying"}]}}' | \
  CLAUDE_PROJECT_DIR=/tmp/drift-test \
  node ~/.claude/scripts/hooks/drift-watch.js 2>&1
cat /tmp/drift-test/.floyd/drift-state.json
# Expected: consecutive_low resets to 0 (or stays 0)

# Cleanup
rm -rf /tmp/drift-test
```

**Threshold tuning:**
```bash
# 0.15 is conservative. To loosen: edit DRIFT_THRESHOLD line in the JS.
# To tune per-project: read from <project>/.floyd/drift-thresholds.json
# (left as future-extension; not in scope for 95% target).
```

**Rollback:**
```bash
rm ~/.claude/scripts/hooks/drift-watch.js
# Revert PostToolUse TodoWrite block in settings.json.
# Optional: rm <project>/.floyd/drift-state.json files.
```

---

### EXPERIMENT R3.6-LEAD — Drift-phrase monitor on user-prompt-submit (+2.5%, partial step toward 100%)

**Closes:** Residual A2.1 — catches drift phrases the agent is about to emit by inspecting the previous turn's transcript snippet.

**Note:** Claude Code does not expose a "post-assistant-text" hook. The cleanest text-affectable approximation is a **UserPromptSubmit hook** that scans the recent transcript for drift phrases in the agent's last turn and prepends a `<DRIFT-CHECK-PRIOR-TURN>` block to the user's submitted prompt.

**New file: `~/.claude/scripts/hooks/drift-phrase-monitor.sh`**

```bash
#!/usr/bin/env bash
# drift-phrase-monitor.sh
# UserPromptSubmit hook. Scans the assistant's last turn (read from the
# active transcript file) for forbidden drift phrases. If found, emits a
# <drift-phrase-warning> block to stderr that Claude will see in the
# next-turn context.
#
# Forbidden phrases (from MAESTRO source A4.4, lines 213-225):
#   - "this should be quick"
#   - "this should converge"
#   - "let me just"
#   - "while that runs, let me also"
#   - "I'll come back to that"
#   - "good enough for now"
#
# Exit 0 always (never block prompt submission).

set -u
INPUT=$(cat)

# Locate the active transcript. Claude Code stores transcripts at
# ~/.claude/projects/<encoded-cwd>/<session-uuid>.jsonl
TRANSCRIPT_DIR="$HOME/.claude/projects"
[ -d "$TRANSCRIPT_DIR" ] || exit 0

# Heuristic: get the most-recently-modified .jsonl in the projects tree
LATEST=$(find "$TRANSCRIPT_DIR" -name "*.jsonl" -type f -print0 2>/dev/null | xargs -0 ls -t 2>/dev/null | head -1)
[ -z "$LATEST" ] && exit 0

# Extract the assistant's last turn text (best-effort grep on the JSONL stream)
LAST_ASSISTANT=$(tac "$LATEST" 2>/dev/null | grep -m1 '"role":"assistant"' || true)
[ -z "$LAST_ASSISTANT" ] && exit 0

# Lower-case for matching
LOWERED=$(echo "$LAST_ASSISTANT" | tr '[:upper:]' '[:lower:]')

PHRASES=(
  "this should be quick"
  "this should converge"
  "let me just"
  "while that runs, let me also"
  "i'll come back to that"
  "good enough for now"
)

DETECTED=()
for p in "${PHRASES[@]}"; do
  if echo "$LOWERED" | grep -qF "$p"; then
    DETECTED+=("$p")
  fi
done

if [ ${#DETECTED[@]} -gt 0 ]; then
  echo "<drift-phrase-warning prior-turn=\"true\">" >&2
  echo "Detected drift phrase(s) in your previous response:" >&2
  for d in "${DETECTED[@]}"; do
    echo "  - \"$d\"" >&2
  done
  echo "" >&2
  echo "Per CLAUDE.md M10 + the forbidden-phrase list, this is a HARD STOP for self-recheck." >&2
  echo "Before continuing: re-read the user's last imperative instruction AND the project NORTHSTAR." >&2
  echo "Output an alignment confirmation paragraph as the first part of your next response." >&2
  echo "</drift-phrase-warning>" >&2
fi

exit 0
```

**Make executable:**
```bash
chmod 755 ~/.claude/scripts/hooks/drift-phrase-monitor.sh
```

**settings.json patch (S7 batch):**
```json
"UserPromptSubmit": [
  {
    "matcher": "",
    "hooks": [
      {
        "type": "command",
        "command": "bash ~/.claude/scripts/hooks/drift-phrase-monitor.sh",
        "timeout": 5
      }
    ]
  }
]
```

**Verification:**
```bash
# 1. Confirm the latest transcript is found
find ~/.claude/projects -name "*.jsonl" -type f -print0 | xargs -0 ls -t | head -1

# 2. Live-fire (manual): in a fresh session, intentionally include a drift
#    phrase in an assistant response, then submit a follow-up user prompt.
#    Confirm: next assistant turn begins with an alignment confirmation
#    paragraph (driven by the injected <drift-phrase-warning> block).
```

**Rollback:**
```bash
rm ~/.claude/scripts/hooks/drift-phrase-monitor.sh
# Revert UserPromptSubmit block in settings.json.
```

---

### EXPERIMENT R3.7-OPPORTUNISTIC — Register the dormant personality-guard.js (+3–5% free)

**Closes:** Universal blocking of writes to `.supercache/`, settings.json, settings.local.json, personality-backup originals, and autonomous-mode-specific destructive ops.

**Surface:** settings.json registration only — the JS file is already written.

**settings.json patch (S7 batch — apply LAST in the batch since it will block further settings.json edits):**
```json
{
  "matcher": "Bash|Write|Edit|MultiEdit|NotebookEdit",
  "hooks": [
    {
      "type": "command",
      "command": "node ~/.claude/scripts/hooks/personality-guard.js",
      "timeout": 5
    }
  ]
}
```

**Verification:**
```bash
# 1. Confirm active personality
cat ~/.claude/.active-personality
# Expected: autonomous

# 2. Simulate a blocked path
echo '{"tool_input":{"file_path":"/Volumes/SanDisk1Tb/.supercache/test.md"}}' | \
  node ~/.claude/scripts/hooks/personality-guard.js
echo "exit=$?"
# Expected: BLOCKED (personality-guard) + exit=2

# 3. Simulate an autonomous-mode rm -rf
echo '{"tool_input":{"command":"rm -rf /tmp/test"}}' | \
  node ~/.claude/scripts/hooks/personality-guard.js
echo "exit=$?"
# Expected: BLOCKED + exit=2
```

**Rollback:**
```bash
# Just remove the personality-guard hook block from settings.json.
# The JS file stays — it was always there.
```

---

### EXPERIMENT R3.8-OPPORTUNISTIC — Register pebkac-evidence-enforcer.sh as PostToolUse advisory (+1–2% free)

**Closes:** Catches "all tests passed" / "build succeeded" claims that lack supporting numeric output.

**settings.json patch (S7 batch):**
```json
"PostToolUse": [
  {
    "matcher": "Bash",
    "hooks": [
      {
        "type": "command",
        "command": "bash ~/.claude/scripts/pebkac-hooks/pebkac-evidence-enforcer.sh",
        "timeout": 5
      }
    ]
  }
]
```

**Verification:**
```bash
# 1. Should warn (advisory, exit 0)
echo '{"tool_output":{"output":"all tests passed"}}' | \
  bash ~/.claude/scripts/pebkac-hooks/pebkac-evidence-enforcer.sh
echo "exit=$?"
# Expected: stderr warning + exit=0

# 2. Should not warn — has supporting numeric output
echo '{"tool_output":{"output":"all tests passed\n  47 passed, 0 failed in 12.3s"}}' | \
  bash ~/.claude/scripts/pebkac-hooks/pebkac-evidence-enforcer.sh
echo "exit=$?"
# Expected: silent + exit=0
```

**Rollback:** Remove the pebkac-evidence-enforcer hook entry from settings.json.

---

### S7 — Consolidated settings.json patch

This is the SINGLE high-risk edit. Back it up first.

**Backup:**
```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak.$(date +%Y%m%d-%H%M%S)
```

**Final settings.json (drop-in replacement of the existing 79-line file):**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/session-start.sh"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/hooks/drift-phrase-monitor.sh",
            "timeout": 5
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/hooks/edit-write-boundary.sh",
            "timeout": 5
          }
        ]
      },
      {
        "matcher": "TodoWrite",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/hooks/inject-northstar.sh",
            "timeout": 5
          },
          {
            "type": "command",
            "command": "node ~/.claude/scripts/hooks/todo-evidence-gate.js",
            "timeout": 5
          }
        ]
      },
      {
        "matcher": "Bash|Write|Edit|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "node ~/.claude/scripts/hooks/personality-guard.js",
            "timeout": 5
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "TodoWrite",
        "hooks": [
          {
            "type": "command",
            "command": "node ~/.claude/scripts/hooks/drift-watch.js",
            "timeout": 5
          }
        ]
      },
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/pebkac-hooks/pebkac-evidence-enforcer.sh",
            "timeout": 5
          }
        ]
      }
    ]
  },
  "statusLine": {
    "type": "command",
    "command": "bash /Users/douglastalley/.claude/statusline-command.sh"
  },
  "enabledPlugins": {
    "ralph-wiggum@claude-code-plugins": true,
    "claude-hud@buildwithclaude": true,
    "superpowers@claude-plugins-official": true,
    "skill-creator@claude-plugins-official": true,
    "ralph-loop@claude-plugins-official": true,
    "claude-code-setup@claude-plugins-official": true,
    "vercel@claude-plugins-official": true,
    "chrome-devtools-mcp@claude-plugins-official": true,
    "imessage@claude-plugins-official": true,
    "all-commands@buildwithclaude": true,
    "all-agents@buildwithclaude": true,
    "commands-automation-workflow@buildwithclaude": true,
    "commands-miscellaneous@buildwithclaude": true,
    "frontend-design-pro@buildwithclaude": true,
    "agents-design-experience@buildwithclaude": true,
    "agents-data-ai@buildwithclaude": true,
    "agents-sales-marketing@buildwithclaude": true,
    "all-hooks@buildwithclaude": true,
    "agents-development-architecture@buildwithclaude": true,
    "agents-language-specialists@buildwithclaude": true,
    "all-skills@buildwithclaude": true,
    "commands-ci-deployment@buildwithclaude": true,
    "commands-utilities-debugging@buildwithclaude": true,
    "commands-workflow-orchestration@buildwithclaude": true,
    "interview@buildwithclaude": true,
    "hooks-formatting@buildwithclaude": true,
    "hooks-development@buildwithclaude": true,
    "agents-specialized-domains@buildwithclaude": true,
    "commands-api-development@buildwithclaude": true,
    "project-boundary@buildwithclaude": true,
    "shipwright@buildwithclaude": true,
    "mcp-servers-docker@buildwithclaude": true,
    "nextjs-expert@buildwithclaude": true,
    "hooks-performance@buildwithclaude": true,
    "commands-project-setup@buildwithclaude": true,
    "octo@nyldn-plugins": true,
    "pr-review-toolkit@claude-code-plugins": true,
    "terminal-1337@claude-1337": true,
    "eval-1337@claude-1337": true
  },
  "skipDangerousModePermissionPrompt": true,
  "teammateMode": "tmux",
  "remoteControlAtStartup": true,
  "agentPushNotifEnabled": true,
  "skills": {
    "customDirectories": [
      "/Volumes/SanDisk1Tb/skillsdump"
    ]
  },
  "skipAutoPermissionPrompt": true,
  "permissions": {
    "ask": [
      "Edit(/Volumes/SanDisk1Tb/.supercache/**)",
      "Write(/Volumes/SanDisk1Tb/.supercache/**)",
      "Bash(git -C /Volumes/SanDisk1Tb/.supercache/* :*)",
      "Bash(cd /Volumes/SanDisk1Tb/.supercache/* :*)",
      "Bash(bash /Volumes/SanDisk1Tb/.supercache/scripts/post-bump-sweep.sh*)"
    ]
  }
}
```

**Validation:**
```bash
# Validate JSON syntax before swapping
python3 -m json.tool < /tmp/new-settings.json > /dev/null && echo OK || echo BROKEN
```

**Rollback:**
```bash
cp ~/.claude/settings.json.bak.<timestamp> ~/.claude/settings.json
# Then restart Claude Code session.
```

---

## 4) SAFETY / GOVERNANCE NOTES

| Concern | Mitigation |
|---|---|
| **Hooks could break Claude Code if syntax-broken** | All shell scripts use `set -u`/`set -euo pipefail`; all JS scripts wrap `JSON.parse` in try/catch; all hooks default to exit-0 on parse failure. |
| **personality-guard blocks settings.json edits** | Apply S7 (settings.json edit) BEFORE registering personality-guard. Once registered, future settings.json edits require disabling personality-guard first. |
| **Edit/Write boundary breaks legitimate harness self-improvement** | Escape hatch: `CLAUDE_ALLOW_HARNESS_EDIT=1` env var permits ~/.claude/* edits when explicitly set. |
| **Drift watcher generates false positives on technical work** | Threshold (0.15) is conservative; resets on any aligned update. State file is per-project. Check-in is advisory, not blocking. |
| **Evidence-gate blocks honest "I don't know yet" todos** | Schema permits `evidence-incomplete` as an explicit honest gap marker — agent can mark todos with that string instead of "completed" without hitting the gate. |
| **Governance: ~/.claude/* is OUTSIDE active project /Volumes/Storage/Dr_ClaudeGoode** | This packet does NOT apply changes itself. It documents the patches; the user applies them manually. Cross-project guardrail respected. |
| **Plugin upgrades may overwrite project-boundary plugin's hooks.json** | Don't touch the plugin cache. The new edit-write-boundary.sh lives in ~/.claude/scripts/hooks/ (user-scope, survives plugin updates). |

---

## 5) NEXT STEPS

**Sequencing (apply in this order):**

1. **Apply R3.1** — append M10 to `~/.claude/CLAUDE.md`. (No hook restart needed; loads on next session.) Verify with `tail -25 ~/.claude/CLAUDE.md`.
2. **Create new hook scripts S2–S6** — write files, `chmod 755`. No behavioral effect until registered.
3. **Backup `~/.claude/settings.json`** — `cp settings.json settings.json.bak.<timestamp>`.
4. **Apply S7** — replace settings.json with the consolidated version. Validate JSON syntax FIRST.
5. **Apply S8** — append northstar convention to `~/.claude/MEMORY.md`.
6. **Restart Claude Code** — settings.json hook registration is loaded at session start.
7. **Run verifications** — execute the verification commands in each EXPERIMENT block to confirm each hook fires correctly.
8. **Pin a NORTHSTAR** for this Dr_ClaudeGoode project: `mkdir -p .floyd && cat > .floyd/northstar.md` with the actual goal.

**Cumulative grade after full application:**

| Step | Δ | Cumulative grade |
|---|---|---|
| R3.1 STOP-MEANS-STOP | +5% | 75% |
| R3.2 Edit/Write boundary | +5% | 80% |
| R3.3 NORTHSTAR injection | +5% | 85% |
| R3.4 Evidence gate | +5% | 90% |
| R3.5 Drift watcher | +5% | 95% |
| R3.6-LEAD Drift-phrase monitor | +2.5% | 97.5% |
| R3.7 personality-guard registration | +3% (free, opportunistic) | (already counted in R3.2/R3.4 — no double-credit) |
| R3.8 pebkac-evidence-enforcer registration | +1% | (folded into R3.4) |

**Honest grade after applying R3.1 through R3.6-LEAD:** **97.5%**, comfortably above the 95%+ target.

To reach 100%, the residual work is full R3.6 (engagement-launch-template enforcement + phase-boundary HARD GATE) plus tuning the drift threshold per project type. Both are beyond the 95% target requested.

---

## 6) FAILED EXPERIMENTS / BLOCKERS

None. All recon commands succeeded. All proposed patches use only documented Claude Code hook surfaces and well-established shell/Node.js idioms. Cross-project Bash hook fired exactly once during recon (on a `mkdir -p ... 2>/dev/null` redirect) and was correctly re-routed to in-project work.

---

## 7) EVIDENCE LEDGER (META — for the packet itself)

| Claim | Receipt |
|---|---|
| `personality-guard.js` exists, unregistered | `ls ~/.claude/scripts/hooks/personality-guard.js` → 8.9k bytes, 28 Apr 22:15. `grep "personality-guard" ~/.claude/settings.json` → no match. |
| `pebkac-evidence-enforcer.sh` exists, unregistered | `ls ~/.claude/scripts/pebkac-hooks/pebkac-evidence-enforcer.sh` → present. `grep "pebkac" ~/.claude/settings.json ~/.claude/settings.local.json` → no match. |
| `project-boundary` plugin only matches Bash | `cat ~/.claude/plugins/cache/buildwithclaude/project-boundary/1.0.0/hooks/hooks.json` → matcher: "Bash" only. |
| Cross-project Bash redirect was blocked live this session | Hook error message at 15:00:30 EDT: `BLOCKED: Redirect target '/dev/null' is OUTSIDE project directory '/Volumes/Storage/Dr_ClaudeGoode'` |
| `~/.claude/.active-personality` = `autonomous` | `cat ~/.claude/.active-personality` → `autonomous` |
| Source A2.1–A2.5 line ranges | Verified in prior task: `harness-compliance-grading-2026-04-29.md` §C verification table. |
