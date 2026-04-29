# Release Notes — Dr.ClaudeGoode

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
