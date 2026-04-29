# Dr_ClaudeGoode SSOT (Single Source of Truth)
**Created:** 2026-04-28T17:31:25-0400
**Last Updated:** 2026-04-28T17:31:25-0400
**Governance:** .supercache/ v1.5.0

> **Compliance Notice:** This file must match the structure at
> `.supercache/templates/ssot-template.md`. This is the authoritative
> document for architecture and programmatic change facts of **Dr_ClaudeGoode**.

---

## Authority

This document is the **single source of truth** for architecture and programmatic change facts of Dr_ClaudeGoode. All other documents must be treated as **potentially flawed** unless their facts are confirmed here.

When a fact in any other document contradicts this SSOT, the SSOT wins. If the SSOT itself is wrong, it is corrected via the **Verification Sweep Protocol** below, not by editing other documents to match.

---

## Verification Sweep Protocol (required on every read)

When an agent reads this SSOT to perform a task:

1. Perform a **line-by-line verification review** of the sections relevant to the current task.
2. For each verified fact, append a verification entry to the **Verification Log** at the bottom of this file with:
   - Timestamp (`YYYY-MM-DD HH:MM TZ`)
   - Section/line reference
   - Evidence source (code path + line, command + output, build log, runtime behavior, etc.)
   - Confidence = 100%
3. If any fact cannot be verified to 100% confidence:
   - Mark it **UNVERIFIED** inline in the section where it appears
   - Add an entry to `Issues/Dr_ClaudeGoode_ISSUES.md` to track the discrepancy
   - Do NOT proceed on the assumption that the fact is true

### Positive Reinforcement (required)

For each fact verified at 100% confidence during a sweep, emit the acknowledgement:

```
Verified as fact (100%): <fact summary>
```

This pattern is deliberate — it reinforces evidence-first thinking and makes the verification record auditable after the fact.

---

## Current State

**Phase:** Active development (lab workspace)
**Status:** Active
**Last Agent Session:** 2026-04-28 21:31 UTC

---

## Architecture Facts

<!-- Add verified architecture facts here. Keep each fact concise and evidence-backed. -->
<!-- Facts should be the kind of thing that, if wrong, would mislead the next agent. -->

### Stack

- **Primary language**: Markdown / Shell (experimentation surface)
- **Framework**: None
- **Runtime**: N/A — text-file editing only
- **Module system**: N/A

### Key architectural choices

- Dr.ClaudeGoode is a harness experimentation lab, not a compiled project.
- All work is editing text surfaces under `~/.claude/` (settings, hooks, agents, skills, etc.).
- No build pipeline, no test suite, no server component.
- Governance compliance is verified via `bootstrap.sh --verify`.
- Personality Engine (`personality-swap.sh`) swaps L4 surfaces: `~/.claude/CLAUDE.md` (full replacement) and `~/.claude/MEMORY.md` (marker-bounded injection). AGENTS.md is backed up but not swapped (documented gap).
- 5 personalities (maestro, breeze, sentinel, sage, ops) each provide CLAUDE.md + MEMORY-IDENTITY.md under `personalities/<name>/surfaces/`.
- Differentiation is verified by `personality-rubric-test.sh` using 10 metrics with 5 validation checks.

---

## Key Decisions

| Date | Decision | Rationale | Decided By |
|---|---|---|---|
| 2026-04-28 | Bootstrap Dr.ClaudeGoode as a governed project | User requested governance alignment and parity; empty dir needed FLOYD.md, SSOT, Issues, .gitignore | Douglas Talley (via agent) |
| 2026-04-28 | Declare N/A for port, build, test, database | Lab workspace edits text files only; no compiled output or server process | Douglas Talley (via agent) |

<!-- Decisions are append-only. When a decision is superseded, add a new row with the -->
<!-- superseding decision and link back to the old one. Never edit historical rows. -->

---

## Dependencies

No dependencies — this project has no package manifest.

---

## Deployment

No deployment — local lab workspace only.

---

## Known Patterns & Lessons

| Pattern | Trigger | Fix | Confidence |
|---|---|---|---|
| governance-version-drift | .floyd/.supercache_version differs from .supercache/VERSION | Run bootstrap.sh --repair /Volumes/Storage/Dr_ClaudeGoode | 1.0 |
| harness-surface-moved | File not found at expected ~/.claude/ path | Check quarantine-* dirs | 0.9 |

---

## Verification Log (append-only)

Every sweep of this SSOT must append one or more entries here. Never edit or remove existing entries.

| Timestamp | Section / Line | Fact Verified | Evidence Source | Confidence |
|---|---|---|---|---|
| 2026-04-28T17:31:25-0400 | Authority | Document initialized as SSOT | bootstrap.sh --init created from template | 100% |
| 2026-04-28 21:31 UTC | Current State | Phase = Active development, Status = Active | Manual edit — filled template placeholders with project-specific values | 100% |
| 2026-04-28 21:31 UTC | Stack | No compiled language, framework, or runtime | Project root inspection shows only governance .md files | 100% |
| 2026-04-28 21:31 UTC | Dependencies | No dependencies | No package manifest found at project root | 100% |
| 2026-04-28 21:31 UTC | Deployment | No deployment — local only | Project is a text-editing lab on /Volumes/Storage | 100% |
| 2026-04-29 00:15 UTC | Key architectural choices | Personality Engine swaps L4 surfaces, 5 personalities, rubric test validates differentiation | personality-swap.sh:133-173, personalities/*/surfaces/CLAUDE.md, personality-rubric-test.sh:45-278 | 100% |
| 2026-04-29 00:15 UTC | Governance parity | FLOYD.md matches floyd-md-template.md structure, all 12 Before You Start steps present, .gitignore matches universal baseline | Side-by-side comparison of FLOYD.md vs /Volumes/Storage/.supercache/templates/floyd-md-template.md | 100% |
| 2026-04-29 00:15 UTC | Version parity | .supercache/ VERSION = 1.5.0 on both /Volumes/Storage and /Volumes/SanDisk1Tb, identical directory trees | ls both locations, file count and structure match | 100% |
| 2026-04-29 00:57 UTC | Documentation | Release documentation package generated at docs/release-documentation-1.0.0.md covering all 10 change items (C01–C10) with full traceability | File created, all sections A–G populated with codebase evidence | 100% |

---

## Change Log (append-only)

- 2026-04-28T17:31:25-0400 — Initialized SSOT.
- 2026-04-28 21:31 UTC — Filled all template placeholders with project-specific values. Verified governance compliance.
- 2026-04-29 00:15 UTC — Governance parity sweep: updated Project Structure tree to include all project content (personalities/, docs/, scripts), expanded Key architectural choices with Personality Engine details, added verification log entries for parity check.
- 2026-04-29 00:57 UTC — Generated pre-release documentation package at docs/release-documentation-1.0.0.md. Full traceability for all 10 change items.
- 2026-04-29 01:15 UTC — Replaced monolithic release doc with proper multi-document structure: README.md (project root), docs/quickstart.md, docs/user-guide.md, docs/release-notes.md, docs/troubleshooting.md, docs/faq.md. Applied Floyd's Labs brand voice. Removed docs/release-documentation-1.0.0.md.

<!-- Append new entries BELOW this comment line, in chronological order. -->
<!-- Never edit or remove existing entries — this is the authoritative change history. -->

---

## Mandatory execution contract
For EACH requested item:
1) Show exact action taken
2) Show direct evidence (file/line/command/output)
3) Show verification result
4) Mark status only after proof

## Forbidden behaviors
- Declaring "done" without evidence
- Collapsing multiple requested items into one vague summary
- Skipping failed steps without explicit blocker report

## Required output structure
A) Requested items checklist
B) Per-item evidence ledger
C) Verification receipts
D) Completeness matrix (item -> done/blocked -> evidence)

## Hard gate
If any requested item has no evidence row, final status MUST be INCOMPLETE.
