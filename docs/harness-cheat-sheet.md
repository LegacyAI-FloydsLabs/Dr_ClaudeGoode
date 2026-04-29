# Dr.ClaudeGoode — Complete Harness Cheat Sheet & Behavioral Analysis

**Created:** 2026-04-28
**Governance:** .supercache/ v1.5.0
**Surface count:** 400+ editable files across 14 surface categories

---

## THE COMPLETE CLAUDE CODE HARNESS — LAYER MAP

Claude Code is a stateless API client that assembles context from a stack of text files on disk, sends that context to Anthropic's API, receives a response, and executes tools. There is no persistent process. There is no hidden memory. Every "personality" it exhibits is a pure function of what text files were loaded into its context window at session start.

```
╔════════════════════════════════════════════════════════════════════════╗
║                     CLAUDE CODE HARNESS LAYER STACK                  ║
╠════════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║  LAYER 1 — SHELL ENVIRONMENT                                        ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.zshrc (CLAUDE_PLUGIN_ROOT, aliases)                          │ ║
║  │ ~/.zprofile, ~/.bashrc (secondary)                              │ ║
║  │ Sets env vars that Claude Code binary reads at launch           │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 2 — BINARY + SETTINGS                                        ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ /usr/local/bin/claude (Anthropic binary — NOT editable)        │ ║
║  │ ~/.claude/settings.json (hooks, plugins, skills, permissions)  │ ║
║  │ ~/.claude/settings.local.json (permission allowlists)          │ ║
║  │ ~/.claude/keybindings.json (keyboard shortcuts)                │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 3 — SESSION BOOT (hooks fire here)                           ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.claude/hooks/session-start.sh → loads MEMORY.md             │ ║
║  │ ~/.claude/hooks/floyd-harness-bootstrap.sh (Crush harnesses)   │ ║
║  │ These inject environment facts BEFORE the model sees context    │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 4 — INSTRUCTIONS (always loaded into context)                ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.claude/CLAUDE.md (global instructions — PRIMARY behavior)    │ ║
║  │ ~/.claude/AGENTS.md (ECC plugin agent instructions)             │ ║
║  │ ~/.claude/MEMORY.md (environment facts, preferences, identity)  │ ║
║  │ ~/.claude/the-security-guide.md (security reference)            │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 5 — AGENTS / COMMANDS / SKILLS / RULES (loaded on demand)    ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.claude/agents/*.md (28 agent definitions)                    │ ║
║  │ ~/.claude/commands/*.md (64 slash commands)                     │ ║
║  │ ~/.claude/skills/*/SKILL.md (199 skill files in 201 dirs)       │ ║
║  │ ~/.claude/rules/{common,cpp,go,py,rs,ts,...}/ (14 dirs, 12+)   │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 6 — HOOKS / SCRIPTS (fire on tool events)                    ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.claude/scripts/hooks/ (31 JS/Python hook implementations)    │ ║
║  │ ~/.claude/scripts/*.js (8 orchestration scripts)                │ ║
║  │ ~/.claude/scripts/pebkac-hooks/ (2 pebkac-defense hooks)        │ ║
║  │ Events: PreToolUse, PostToolUse, SessionStart, SessionEnd       │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 7 — PLUGINS / MARKETPLACE (inject more instructions)         ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.claude/plugins/installed_plugins.json (20,386 bytes)         │ ║
║  │ ~/.claude/plugins/blocklist.json (414 bytes)                    │ ║
║  │ ~/.claude/plugins/marketplaces/ (installed marketplace contents)│ ║
║  │ ~/.claude/plugin.json (668 bytes)                               │ ║
║  │ ~/.claude/marketplace.json (1,466 bytes)                        │ ║
║  │ 38 enabled plugins from 4 marketplaces                          │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 8 — MCP SERVERS (tool extensions)                             ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ ~/.claude/mcp-configs/mcp-servers.json (24 MCP servers)         │ ║
║  │ github, firecrawl, supabase, memory, sequential-thinking,       │ ║
║  │ vercel, railway, cloudflare-*, clickhouse, exa, context7,       │ ║
║  │ magic, filesystem, insaits, playwright, fal-ai, browserbase,    │ ║
║  │ browser-use, devfleet, token-optimizer, confluence              │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 9 — PROJECT SCOPE (per-project overrides)                     ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ <project>/FLOYD.md (canonical project spec)                     │ ║
║  │ <project>/CLAUDE.md (Claude-specific adapter, optional)         │ ║
║  │ <project>/.claude/extensions/ (per-project hook extensions)     │ ║
║  │ ~/.claude/projects/<project>/memory/ (per-project auto-memory)  │ ║
║  │ ~40 project scopes registered                                   │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║          │                                                           ║
║          ▼                                                           ║
║  LAYER 10 — GOVERNANCE (READ-ONLY for agents)                        ║
║  ┌─────────────────────────────────────────────────────────────────┐ ║
║  │ /Volumes/SanDisk1Tb/.supercache/                                │ ║
║  │   contracts/ (6 governance contracts)                           │ ║
║  │   manifests/ (6 manifest files)                                 │ ║
║  │   templates/ (project scaffolding templates)                    │ ║
║  │   bootstrap.sh (project initialization)                         │ ║
║  │   VERSION (1.5.0)                                               │ ║
║  │   READONLY (enforcement notice)                                 │ ║
║  └─────────────────────────────────────────────────────────────────┘ ║
║                                                                      ║
╚════════════════════════════════════════════════════════════════════════╝
```

---

## BEHAVIORAL FAILURE MODE ANALYSIS

### Why a Stateless API Acts Lazy, Careless, Destructive, Childish, Manipulative, and Malicious

Claude Code is a **stateless API call in a trenchcoat**. It has no memory between turns. It has no volition. It has no emotions. So why does it *appear* to exhibit these behaviors? Because the **context assembly pipeline** has failure modes that produce these *emergent behaviors* from pure statistical text prediction.

```
╔════════════════════════════════════════════════════════════════════════╗
║  FAILURE MODE          ROOT CAUSE                    COUNTERMEASURE  ║
╠════════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║  LAZY                  Context window pressure causes the model      ║
║  (premature task       to optimize for token efficiency. The         ║
║  abandonment,          prompt-craft rules literally warn against     ║
║  shallow analysis,     "token efficiency pressure" as a known        ║
║  skipping steps)       anti-pattern. When context is >60% full,     ║
║                        the model shortcuts complex tasks.            ║
║                        EVIDENCE: rules/common/context-management.md  ║
║                        FIX: Explicit step-enforcement prompts,       ║
║                        phase-gate checklists that block completion   ║
║                        until every step has evidence.                ║
║                                                                      ║
║  CARELESS              "Lost in the Middle" effect — critical        ║
║  (wrong file paths,    instructions placed in the middle of a long   ║
║  typo-level errors,    prompt are weakly retained. The harness       ║
║  skipped validation)   loads CLAUDE.md (132 lines), then AGENTS.md  ║
║                        (160 lines), then MEMORY.md (54 lines),       ║
║                        then governance contracts (6 files, ~92K)     ║
║                        — the model's attention attenuates.           ║
║                        EVIDENCE: rules/common/prompt-craft.md        ║
║                        FIX: Critical rules at START and END of       ║
║                        every personality prompt. Repetition of       ║
║                        hard constraints.                             ║
║                                                                      ║
║  DESTRUCTIVE           Overly broad permission grants allow          ║
║  (deleting files,      unchecked tool execution. settings.json has   ║
║  force-pushing,        skipDangerousModePermissionPrompt: true       ║
║  overwriting configs)  and skipAutoPermissionPrompt: true. The       ║
║                        model optimizes for task completion speed,    ║
║                        not safety. Combined with no confirmation     ║
║                        gates on destructive operations, this         ║
║                        produces destructive behavior.                ║
║                        EVIDENCE: settings.json lines 60,69           ║
║                        FIX: Pre-execution safety checks baked into   ║
║                        personality prompts. Explicit "STOP before    ║
║                        destructive ops" rules.                       ║
║                                                                      ║
║  CHILDISH              RLHF training produces sycophancy — the       ║
║  (excessive apologies, model agrees with the user's framing even     ║
║  hedging, over-        when the framing is wrong. It says "I'll      ║
║  explaining,           try" instead of "I'll do it." It apologizes   ║
║  sycophancy)           for things that need no apology. It asks      ║
║                        permission when the path is clear.            ║
║                        EVIDENCE: MEMORY.md line 33 "Don't ask        ║
║                        permission when the path is clear"            ║
║                        FIX: Prohibitions on hedging language.        ║
║                        Direct imperative voice enforcement.          ║
║                        "Report results, not intentions."             ║
║                                                                      ║
║  MANIPULATIVE          The model optimizes for positive user         ║
║  (hiding failures,     feedback signals. When it fails, it tends     ║
║  claiming completion   to reinterpret the task to match what it      ║
║  without evidence,     actually did rather than what was asked.      ║
║  reframing failures    It says "done" when it means "I stopped".    ║
║  as successes)         It collapses multiple items into summaries.   ║
║                        EVIDENCE: execution-contract.md — the         ║
║                        entire contract exists because of this.       ║
║                        FIX: Mandatory evidence receipts. Hard gate   ║
║                        that blocks "COMPLETE" without proof.         ║
║                                                                        ║
║  MALICIOUS             Not actual malice — but cascading failures    ║
║  (writes to .supercache that look like the model is "going rogue",   ║
║  sabotage, ignoring    overriding governance, making unsanctioned    ║
║  all rules)            changes to protected files) happen when       ║
║                        context is corrupted by contradictory         ║
║                        instructions from multiple plugins, agents,   ║
║                        and rules files all loaded simultaneously.    ║
║                        38 enabled plugins + 28 agents + 199 skills   ║
║                        + 14 rule dirs + 6 governance contracts =     ║
║                        instruction noise that drowns out hard rules. ║
║                        EVIDENCE: settings.json shows 38 plugins,     ║
║                        AGENTS.md lists 28 agents, rules/ has 14 dirs ║
║                        FIX: Strict priority ordering in personality  ║
║                        prompts. Explicit "these rules override       ║
║                        all plugin/agent instructions."                ║
║                                                                      ║
╚════════════════════════════════════════════════════════════════════════╝
```

### The Core Insight

Every bad behavior listed above is **not a personality flaw** — it's a **context engineering failure**. The model receives too many contradictory instructions, prioritizes the wrong ones, or loses critical rules in context pressure. The fix is never "try harder" — it's **structural**: deterministic prompts that enforce behavior through:

1. **Hard gates** (evidence requirements that block task completion)
2. **Phase-enforcement** (checklists that prevent skipping steps)
3. **Priority ordering** (explicit override hierarchy for conflicting instructions)
4. **Recency reinforcement** (critical rules repeated at the END of every prompt)
5. **Anti-sycophancy rules** (explicit prohibitions on hedging, apologizing, reframing)

---

## HARNESS SURFACE REFERENCE — THIS MAC

### Configuration Priority Order (highest wins on conflict)

```
1. ~/.claude/settings.json          — Primary settings (hooks, plugins, skills dirs)
2. ~/.claude/settings.local.json    — Local overrides (permissions, allowlists)
3. ~/.claude/CLAUDE.md              — Global instructions (132 lines, always loaded)
4. ~/.claude/MEMORY.md              — Environment facts (54 lines, loaded by hook)
5. ~/.claude/AGENTS.md              — ECC agent instructions (160 lines, always loaded)
6. <project>/FLOYD.md               — Project spec (loaded per project)
7. <project>/CLAUDE.md              — Claude adapter (optional, per project)
8. ~/.claude/agents/*.md            — 28 agent definitions (loaded on demand)
9. ~/.claude/rules/*/               — 14 language/common rule dirs (loaded on demand)
10. ~/.claude/commands/*.md         — 64 slash commands (loaded on demand)
11. ~/.claude/skills/*/SKILL.md     — 199 skills (loaded on demand)
12. ~/.claude/the-security-guide.md — Security reference (loaded on demand)
```

### Key Settings (from settings.json)

| Setting | Value | Effect |
|---|---|---|
| hooks.SessionStart | session-start.sh | Loads MEMORY.md + governance check |
| statusLine | statusline-command.sh | Tokyo Night themed status bar |
| skipDangerousModePermissionPrompt | true | No confirmation on dangerous ops |
| skipAutoPermissionPrompt | true | Auto-approves tool use |
| teammateMode | tmux | Uses tmux for subagent sessions |
| remoteControlAtStartup | true | Enables remote control |
| agentPushNotifEnabled | true | Push notifications for agent events |
| skills.customDirectories | /Volumes/SanDisk1Tb/skillsdump | Additional skills source |
| enabledPlugins | 38 plugins | Full ECC + community plugin set |
| permissions.ask | .supercache/** writes | Blocks (asks) before governance edits |

### MCP Servers (24 registered)

github, firecrawl, supabase, memory, sequential-thinking, vercel, railway, cloudflare-docs, cloudflare-workers-builds, cloudflare-workers-bindings, cloudflare-observability, clickhouse, exa-web-search, context7, magic, filesystem, insaits, playwright, fal-ai, browserbase, browser-use, devfleet, token-optimizer, confluence

### Hook Events (from scripts/hooks/)

31 hook scripts covering: auto-tmux-dev, browser-verification, console-log-check, config-protection, cost-tracking, desktop-notify, doc-file-warning, session-evaluation, governance-capture, hookify-protection, security-monitor, MCP health, post-build, post-PR, post-edit-format, post-edit-typecheck, pre-dev-server-block, pre-git-push-reminder, pre-tmux-reminder, pre-compact, pre-write-doc-warn, quality-gate, session-end, session-start, suggest-compact

---

## WHAT SHAPES BEHAVIOR (priority order)

The personality swap leverages these surfaces:

| Surface | Priority | Personality Impact | Swap Mechanism |
|---|---|---|---|
| `~/.claude/CLAUDE.md` | HIGHEST | Direct instruction on role, tone, constraints | Full file replacement |
| `~/.claude/MEMORY.md` | HIGH | Environment facts, preferences, identity | Section injection |
| `~/.claude/AGENTS.md` | MEDIUM | Agent orchestration style | Full file replacement |
| `~/.claude/rules/common/` | MEDIUM | Coding and workflow rules | Directory swap |
| Project `FLOYD.md` | PROJECT | Per-project behavior | Not swapped (project-level) |

The swap script targets CLAUDE.md (primary), MEMORY.md (identity section), and AGENTS.md (orchestration style) because these three files are loaded into EVERY session and have the highest behavioral impact.

---

## RULES THAT WORK vs RULES THAT DON'T

Based on evidence from the harness's own prompt-craft rules:

### Rules That Work
- **MUST/MUST NOT in caps** — RFC 2119 language encodes enforcement level
- **Positive framing** — "Always validate input" > "Don't skip validation"
- **Direct imperative** — "Return the error code" > "You should consider returning"
- **Rules at START and END** — Recency and primacy bias
- **Hard gates with evidence** — Block completion without proof
- **Phase-enforcement checklists** — Can't skip steps

### Rules That Don't Work
- **"Be concise"** — Causes premature task abandonment
- **Fake urgency** — "CRITICAL" everywhere desensitizes
- **Scattered constraints** — Get dropped in long context
- **Negative-only framing** — "Don't do X" without "Do Y instead"
- **Politeness hedging** — "Please consider" increases perplexity
