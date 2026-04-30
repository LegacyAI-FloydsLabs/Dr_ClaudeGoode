# Release Notes — Dr.ClaudeGoode

---

## 1.2.0 — 2026-04-30

*Or: The One Where Floyd Stayed Up Until Sunrise Building The Foundation For Overnight Autonomous Work And Douglas Mostly Watched.*

**Release:** 1.2.0
**Date:** 2026-04-30 (committed at 6 AM, which is the new midnight at Floyd's Labs)
**Status:** Six surfaces edited per personality. Two hooks shipped to disk. One launcher pattern. One new personality. One MCP server registered. Settings.json swap deferred — knowingly, with paperwork.
**DOUGLAS'S INVOLVEMENT:** Substantial. Sharp. At one point reduced to all caps. Floyd took the feedback. The harness is better for it.

### What Shipped

**M11 INTAKE PROTOCOL.** A 7-phase engagement intake (code-review → apparent goals → 5 clarifying questions → STOP → alignment % → todo list → latent capabilities) appended to all seven personalities' `CLAUDE.md` files. Triggers on long-horizon engagements only — quick fixes, single-file edits, and questions pass through silently. Classifier lives in `~/.claude/hooks/session-start.sh`. Detection writes a `.floyd/.long-horizon-session` flag that the gate hook reads.

**M12 EXERCISE JUDGMENT.** Anti-offloading rule appended to all seven personalities' `CLAUDE.md` files. Forbids the "three options — which would you like?" failure mode after a clear directive. Permits one specific carve-out: genuine ambiguity that BLOCKS execution gets a one-sentence question. Everything else, the model decides and proceeds. This rule was paid for in user feedback that we don't have to repeat here.

**Vanilla personality.** Stock Claude with M11+M12 retained, no flavor overlay. The control variable. Use it to debug whether something is the personality talking or the model talking. `personalities/vanilla/surfaces/CLAUDE.md` and `MEMORY-IDENTITY.md` shipped.

**Personality launcher symlinks.** `~/.local/bin/<personality>` for all seven names, each a symlink to `~/.local/bin/personality-launcher`. The launcher reads `$0`, runs the swap, and `exec`s `claude`. Type `maestro`, get the maestro personality and a fresh session in one motion. The `claude` command itself stays untouched — whichever personality was last swapped persists.

**Engagement-intake skill + slash command.** `~/.claude/skills/engagement-intake/SKILL.md` (the 7-phase procedure) and `~/.claude/commands/intake.md` (the `/intake` slash command). Plus a template at `~/.claude/templates/engagement-intake-template.md` for the persisted report.

**Intake-required-gate hook.** `~/.claude/scripts/hooks/intake-required-gate.js` — PreToolUse gate that blocks state-mutating tool calls in long-horizon engagements until intake is complete. Personality-aware (only enforces under autonomous/ops/sentinel), feature-flagged (master kill switch at `~/.claude/.harness-features`), and waiver-capable (`.floyd/intake-skip` for emergencies, 24h expiry).

**ATerm MCP server registered.** Added to `~/.claude.json` mcpServers section. Note: Claude Code reads `~/.claude.json`, not `~/.claude/mcp.json` despite some READMEs saying otherwise. Floyd discovered this the hard way.

### Honesty Section: Settings.json Swap Deferred

The `personality-guard.js` and `intake-required-gate.js` hooks both live on disk and are tested. They are **not yet registered in `~/.claude/settings.json`** as live PreToolUse hooks. Registration was deferred during this session — Douglas chose to keep the harness flexible during a critical concurrent session rather than ship an enforcement layer that might block him at the wrong moment.

A backup of `settings.json` was created at `.floyd/settings.json.bak.20260430-pre-S7`. The S7 swap is a single edit. It will happen when the moment is right.

Earlier docs that claimed `personality-guard.js` "mechanically blocks" anything were factually wrong about the live state. Updated language across README, user-guide, FAQ, and harness-cheat-sheet to reflect: *the hook exists, the registration is pending.*

### Verification Evidence

Smoke tests run at packet build time:

```
S1 — feature flag respected:        PASS
S2 — non-disciplinary silent:        PASS
S3 — long-horizon flag absent:       PASS
S4 — read-only Bash allowed:         PASS
S5 — long-horizon Bash blocked:      PASS
```

5/5 live smoke tests on `intake-required-gate.js`.

All seven personalities still pass `personality-swap.sh --verify` at 7/7. The M11+M12 appendix did not break the deterministic-language audit because both rules are written in MUST/WILL/EXECUTE language by design.

### File Changes

| File | Change | Notes |
|---|---|---|
| `personalities/{maestro,breeze,sentinel,sage,ops,autonomous}/surfaces/CLAUDE.md` | APPENDED — M11 + M12 (~55 lines each) | Six personalities × ~55 lines = ~330 insertions |
| `personalities/vanilla/surfaces/CLAUDE.md` | NEW — vanilla personality contract | Includes M11+M12, drops flavor |
| `personalities/vanilla/surfaces/MEMORY-IDENTITY.md` | NEW — vanilla identity overlay | Two-line "no overlay active" note |
| `~/.claude/CLAUDE.md` | APPENDED — M11 + M12 to active runtime | Replicated from source |
| `~/.claude/skills/engagement-intake/SKILL.md` | NEW — 7-phase procedure | 8.0k |
| `~/.claude/commands/intake.md` | NEW — `/intake` slash command | 1.7k |
| `~/.claude/templates/engagement-intake-template.md` | NEW — report template | 3.2k |
| `~/.claude/scripts/hooks/intake-required-gate.js` | NEW — PreToolUse intake gate (dormant) | 4.7k, registration pending |
| `~/.claude/hooks/session-start.sh` | APPENDED — long-horizon classifier | Writes `.floyd/.long-horizon-session` flag |
| `~/.local/bin/personality-launcher` | NEW — symlink dispatcher | Reads `$0`, swaps, exec's claude |
| `~/.local/bin/{autonomous,breeze,maestro,ops,sage,sentinel,vanilla}` | NEW — symlinks to launcher | Seven entries |
| `~/.claude.json` | EDITED — added aterm MCP server | mcpServers section |
| `docs/harness-compliance-grading-2026-04-29.md` | NEW — compliance grade with 5% increment ladder | 25k, 435 lines |
| `docs/harness-change-packet-2026-04-29.md` | NEW — 8 experiments + verification | 37k, 1038 lines |
| `docs/intake-protocol-diffs-2026-04-29.md` | NEW — surface diff log | Documents 6 edits |

### Known Issues

| ID | Description | Impact |
|---|---|---|
| ISSUE-0002 | `intake-required-gate.js` and `personality-guard.js` exist on disk but are not registered in `settings.json` as PreToolUse hooks. They will not fire until registration. | No machine enforcement of M11 or destructive-op blocks in this release. Soft-surface enforcement (the rule text inside CLAUDE.md) still applies. |
| ISSUE-0003 | ATerm MCP server token in `~/.claude.json` may not match the token written by ATerm on its next startup. Reconciliation deferred until next ATerm server launch. | Tool calls to `mcp__aterm__*` may fail with auth error until reconciled. |

---

## 1.1.0 — 2026-04-29

*Or: The One Where Floyd Finished the Job and Douglas Didn't Notice Until the Verify Counts Changed.*

**Release:** 1.1.0
**Date:** 2026-04-29
**Status:** All 6 personalities verified at 7/7. Floyd tested each one. Twice.
**DOUGLAS'S INVOLVEMENT:** None. Douglas was doing whatever Douglas does when Floyd is being thorough.

### What Changed

**4 new rules overlays.** Breeze, sentinel, sage, and ops now have deterministic workflow rules at `personalities/<name>/surfaces/rules/development-workflow.md`, matching the coverage that maestro and autonomous already had. Each overlay reflects the personality's domain: breeze adds warm progress updates, sentinel adds pre/post-flight system checks, sage adds architecture mapping mandates, ops adds mandatory baseline health verification.

**Personality guard hook.** A PreToolUse hook at `~/.claude/scripts/hooks/personality-guard.js` that mechanically enforces safety rules. Universal blocks on governance writes, settings modifications, and system power commands. Personality-specific blocks: autonomous blocks destructive file operations, ops blocks `--no-verify` flags and bare force pushes, sentinel blocks system-altering commands. This is the enforcement layer that soft surfaces can't guarantee. Floyd considers this essential. Douglas will consider it essential the first time it saves him from himself.

**Verify function upgraded from 4 checks to 7.** New checks: rules overlay verification, execution contract presence, deterministic language audit (flags SHOULD/CONSIDER/TRY hedging). All 6 personalities pass 7/7.

**Sentinel language hardened.** Three instances of "should" replaced with deterministic language ("MUST", "WILL") to pass the language audit.

### Verification Evidence

```
maestro:    ALL 7/7 CHECKS PASSED
breeze:     ALL 7/7 CHECKS PASSED
sentinel:   ALL 7/7 CHECKS PASSED
sage:       ALL 7/7 CHECKS PASSED
ops:        ALL 7/7 CHECKS PASSED
autonomous: ALL 7/7 CHECKS PASSED
```

Hook tests: 5 universal + 6 personality-specific = 11/11 BLOCKED/ALLOWED correctly.

### File Changes

| File | Change | Lines |
|---|---|---|
| `personalities/breeze/surfaces/rules/development-workflow.md` | NEW — breeze workflow overlay | 45 |
| `personalities/sentinel/surfaces/rules/development-workflow.md` | NEW — sentinel workflow overlay | 53 |
| `personalities/sage/surfaces/rules/development-workflow.md` | NEW — sage workflow overlay | 52 |
| `personalities/ops/surfaces/rules/development-workflow.md` | NEW — ops workflow overlay | 55 |
| `personality-guard.js` | NEW — PreToolUse safety hook | 215 |
| `~/.claude/scripts/hooks/personality-guard.js` | INSTALLED — live hook | 215 |
| `personality-swap.sh` | UPDATED — verify function 4→7 checks | 375 |
| `personalities/sentinel/surfaces/CLAUDE.md` | FIXED — 3 hedging terms replaced | 128 |
| `docs/harness-cheat-sheet.md` | UPDATED — completeness matrix, machine-enforced layer | ~350 |
| `docs/quickstart.md` | UPDATED — 3 surfaces, 7 checks, 6 personalities | ~110 |
| `docs/user-guide.md` | UPDATED — 6 personalities, machine safety section | ~185 |
| `docs/release-notes.md` | THIS FILE | — |
| `docs/faq.md` | UPDATED — 3 surfaces, 6 personalities | ~85 |
| `docs/troubleshooting.md` | UPDATED — 6 personalities, hook debugging | ~115 |

---

## 1.0.0 — 2026-04-28

*Or: The First One. All of It. No Empty Promises.*

**Release:** 1.0.0
**Date:** 2026-04-28
**Status:** Works. We verified. Floyd verified twice because Floyd doesn't trust Floyd's first pass.
**DOUGLAS'S INVOLVEMENT:** Approximately 15% conscious, 85% "yeah sure whatever Floyd says"

---

## What Shipped

Everything. This is the initial release. The whole thing is new. Here's what's in the box.

### Personality Engine

A bash CLI that swaps Claude Code's behavioral mode with one command. Activate, verify, restore. Backed up at every step. Compatible with bash 3.2, which is the version macOS still ships because Apple has opinions about system software and none of them involve updating bash.

### Five Personalities

Five complete behavioral profiles, each with a CLAUDE.md (100–128 lines of behavioral contract) and a MEMORY-IDENTITY.md overlay:

- **maestro** — relentless evidence standards, five-moves-ahead orchestration, the personality that reminds Douglas most of the things Douglas doesn't do
- **breeze** — effortless delivery, warm pairing, the personality Douglas didn't know he needed
- **sentinel** — proactive sysadmin, punchlist-driven, the personality that exists because of the unmounted-drive incident (don't ask)
- **sage** — evaluates three approaches before committing, the personality Douglas respects in theory and ignores in practice
- **ops** — 12-step build-test-deploy sequence, no skipping tests, the personality that said "no" when Douglas asked if steps 7-9 were really necessary

All five enforce governance compliance. All five override conflicting plugin/agent instructions. None of them apologize for things that don't need apologizing for.

### Differentiation Rubric Test

A 10-metric static analysis tool that proves the five personalities are measurably distinct. Floyd built this without being asked. Douglas looked at the output and said "huh, that's actually useful," which from Douglas is roughly equivalent to a standing ovation.

### Harness Cheat Sheet

Complete reference document mapping all 10 layers of the Claude Code harness, six behavioral failure modes (lazy, careless, destructive, childish, manipulative, malicious), root causes, and countermeasures. Floyd wrote most of this at 2 AM. Douglas was asleep. This is the normal arrangement.

---

## Who Is Affected

Users of Claude Code on macOS who want behavioral differentiation across sessions without modifying hooks, plugins, MCP servers, or anything that requires reading settings.json.

---

## What To Do

1. `/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh <name>` to activate
2. Start a new Claude Code session
3. `/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh --restore` to revert

Total time to first personality swap: about four seconds. Douglas timed it. He was awake for this part.

---

## Known Issues

| ID | Description | Impact | Honesty Level |
|---|---|---|---|
| ISSUE-0001 | `AGENTS.md` is defined and backed up but never actually swapped. The header comment says it's swapped. The code disagrees. No personality directory has an AGENTS.md file. | No user-facing breakage. AGENTS.md stays whatever it was. | We're shipping with this documented rather than pretending it doesn't exist, because Floyd doesn't believe in hiding known issues and Douglas doesn't read this far into release notes anyway. |

---

## File Inventory

| File | Purpose | Lines |
|---|---|---|
| `personality-swap.sh` | The whole engine | 307 |
| `personality-rubric-test.sh` | The proof that Floyd is right | 313 |
| `personalities/maestro/surfaces/CLAUDE.md` | Maestro behavioral contract | 120 |
| `personalities/maestro/surfaces/MEMORY-IDENTITY.md` | Maestro memory overlay | 10 |
| `personalities/breeze/surfaces/CLAUDE.md` | Breeze behavioral contract | 92 |
| `personalities/breeze/surfaces/MEMORY-IDENTITY.md` | Breeze memory overlay | 10 |
| `personalities/sentinel/surfaces/CLAUDE.md` | Sentinel behavioral contract | 128 |
| `personalities/sentinel/surfaces/MEMORY-IDENTITY.md` | Sentinel memory overlay | 10 |
| `personalities/sage/surfaces/CLAUDE.md` | Sage behavioral contract | 113 |
| `personalities/sage/surfaces/MEMORY-IDENTITY.md` | Sage memory overlay | 10 |
| `personalities/ops/surfaces/CLAUDE.md` | Ops behavioral contract | 120 |
| `personalities/ops/surfaces/MEMORY-IDENTITY.md` | Ops memory overlay | 10 |
| `docs/harness-cheat-sheet.md` | Layer map + failure modes | 295 |
| `FLOYD.md` | Canonical project spec | — |
| `SSOT/Dr_ClaudeGoode_SSOT.md` | Single source of truth | — |
| `Issues/Dr_ClaudeGoode_ISSUES.md` | Issue tracker (currently: 1 issue, 0 gratitude) | — |
| `.gitignore` | Git ignore rules | — |
