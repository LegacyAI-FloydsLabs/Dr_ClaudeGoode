# Release Notes — Dr.ClaudeGoode 1.0.0

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
