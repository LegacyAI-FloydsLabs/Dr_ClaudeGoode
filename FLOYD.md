# Dr.ClaudeGoode — FLOYD.md
**Version:** 1.5.0
**Initialized:** 2026-04-28
**Governance:** .supercache/ v1.5.0
**Port:** N/A — no server component (harness experimentation lab)
**Drive:** /Volumes/Storage
**Path:** /Volumes/Storage/Dr_ClaudeGoode

> **Compliance Notice:** This file must match the template at
> `.supercache/templates/floyd-md-template.md`. If you are an agent reading
> this file and it is missing sections from the template, edit this file to
> add them. Preserve all project-specific content below. The template is the
> spec. This file is the implementation. Make them match.

---

## Agent Contract

You are working on **Dr_ClaudeGoode**, a Legacy AI project.

**This file (`FLOYD.md`) is the canonical project spec.** It is authoritative for project identity, stack, ports, build commands, environment variables, and project-specific rules. All agents — Floyd, Claude, or any model routed through the OhMyFloyd harness — read this file first.

**Some projects also have a `CLAUDE.md` adapter** alongside this file. That adapter is optional and applies only when Claude is the active agent. It does not duplicate anything here; it layers Claude-specific behavior and role guidance on top. If `CLAUDE.md` conflicts with `FLOYD.md` on project facts, `FLOYD.md` wins. See `.supercache/templates/claude-md-template.md` for the adapter spec.

### Before You Start
1. Read this file completely. Do not skim. Every section constrains your behavior.
2. **If you are Claude Code**: also read `CLAUDE.md` if it exists at the project root. It contains your role, division of labor with Floyd, and Claude-specific rules.
3. Read `.supercache/READONLY` — you MUST NOT write to `.supercache/`.
4. Read `SSOT/Dr_ClaudeGoode_SSOT.md` for current project state. Perform the Verification Sweep Protocol defined in `.supercache/contracts/document-management.md` for sections relevant to your task.
5. Read `Issues/Dr_ClaudeGoode_ISSUES.md` for open issues and blockers.
6. This project is a CLI/library. No port binding. No claim needed.
7. Read `.supercache/contracts/execution-contract.md` — this governs how you prove your work.
8. Read `.supercache/contracts/repo-structure.md` — canonical layout for this project's language, plus the migration workflow if structural changes are needed.
9. Read `.supercache/contracts/git-discipline.md` — pre-commit checklist, commit message standards, secret hygiene, and reputation guardrails.
10. Read `.supercache/contracts/document-management.md` — Anti-Cruft Rule, canonical document homes, SSOT verification sweep, reference materials tier.
11. Read `.supercache/contracts/repo-hygiene.md` — `.gitignore` baseline for this language, cleanup triggers, project root tidiness standards.
12. Read `.supercache/manifests/model-routing.yaml` — this tells you which LLM to use for what.

### Governance Location
```
.supercache/ → /Volumes/SanDisk1Tb/.supercache
```
This directory contains global templates, contracts, manifests, and routing config.
It is **READ-ONLY**. Do not create, modify, or delete any file there.

### Where You Write

| Location             | Purpose                                          | Example                                         |
|----------------------|--------------------------------------------------|-------------------------------------------------|
| `SSOT/`              | Project status, decisions, findings, verification | `SSOT/Dr_ClaudeGoode_SSOT.md`, `SSOT/decision-log.md` |
| `Issues/`            | Bugs, blockers, tasks, help-desk ledger          | `Issues/Dr_ClaudeGoode_ISSUES.md`, `Issues/0001-description.md` |
| `.floyd/`            | Agent working state, session logs, runtime cache | `.floyd/agent_log.jsonl`                        |
| Project source files | Your actual work                                 | Any file in the project tree not listed below   |

### Where You Do NOT Write

| Location          | Reason                                       |
|-------------------|----------------------------------------------|
| `.supercache/`    | Global governance — READ-ONLY for all agents |
| <!-- ADD HERE --> | <!-- Project-specific no-write zones -->     |

---

## Project Identity

| Field                | Value                                                                   |
|----------------------|-------------------------------------------------------------------------|
| **Name**             | Dr.ClaudeGoode                                                          |
| **Purpose**          | Harness experimentation lab — Claude Code surface manipulation and governance compliance testing |
| **Primary Language** | Markdown / Shell (experimentation surface, no compiled output)          |
| **Runtime**          | N/A — text-file editing only                                            |
| **Module System**    | N/A                                                                     |
| **Framework**        | None                                                                    |
| **Database**         | None                                                                    |
| **Port**             | N/A — no server component                                               |
| **Repository**       | None — local only, /Volumes/Storage/Dr_ClaudeGoode                      |
| **Current Phase**    | Active development (lab workspace)                                      |

---

## Project Structure

```
Dr_ClaudeGoode/
├── FLOYD.md                      # This file — canonical project spec
├── .gitignore                    # Git ignore rules
├── personality-swap.sh           # Personality Engine CLI — swap/restore/verify
├── personality-rubric-test.sh    # 10-metric differentiation rubric test
├── SSOT/                         # Project status and decisions
│   └── Dr_ClaudeGoode_SSOT.md    # Single source of truth
├── Issues/                       # Bug and task tracking
│   └── Dr_ClaudeGoode_ISSUES.md  # Issues ledger
├── personalities/                # Personality surface definitions
│   ├── maestro/surfaces/         # Serious coding guru
│   ├── breeze/surfaces/          # Warm, effortless excellence
│   ├── sentinel/surfaces/        # Meticulous sysadmin
│   ├── sage/surfaces/            # Strategic architect
│   └── ops/surfaces/             # Production-grade execution
├── docs/                         # Documentation
│   └── harness-cheat-sheet.md    # Complete harness layer map + failure modes
└── .floyd/                       # Agent working state (gitignored)
    ├── .supercache_version       # Governance version stamp
    └── agent_log.jsonl           # Session log
```

---

## Build & Verify Commands

This project is a text-editing lab. No compilation, no test suite, no build step.

| Action         | Command                              | Expected Result             |
|----------------|--------------------------------------|-----------------------------|
| **Type check** | N/A — no compiled language           | N/A                         |
| **Build**      | N/A — no build step                  | N/A                         |
| **Test**       | N/A — no test suite                  | N/A                         |
| **Lint**       | N/A — no linter configured           | N/A                         |
| **Start**      | N/A — no server component            | N/A                         |
| **Dev**        | N/A — editing surfaces directly      | N/A                         |

### Verification sequence after any change:
```bash
# Verify governance compliance after edits
bash /Volumes/SanDisk1Tb/.supercache/bootstrap.sh --verify /Volumes/Storage/Dr_ClaudeGoode
```

---

## Port Allocation

This project is a CLI/library/script. No port binding. No claim needed.

---

## Project-Specific Rules

| #   | Rule                                                                          | Rationale                                                      |
|-----|-------------------------------------------------------------------------------|----------------------------------------------------------------|
| R1  | This project edits files under ~/.claude/ only — never under .supercache/     | Governance layer is READ-ONLY for all agents                   |
| R2  | All experiments must be reversible — provide rollback steps for every patch   | Lab workspace must remain clean and recoverable                |
| R3  | Surface inventory changes must be recorded in SSOT                            | Keeps the map of editable surfaces current across sessions     |
| R4  | No port binding, no server processes, no compiled output                      | This is a text-surface lab, not a running service              |

---

## Known Patterns & Lessons

| Pattern                          | Trigger                                        | Fix                                                  | Confidence |
|----------------------------------|------------------------------------------------|------------------------------------------------------|------------|
| governance-version-drift         | .floyd/.supercache_version != .supercache/VERSION | Run bootstrap.sh --repair /Volumes/Storage/Dr_ClaudeGoode | 1.0        |
| harness-surface-moved            | File not found at expected ~/.claude/ path      | Check if moved to quarantine-*/ dir                  | 0.9        |

---

## Environment Variables

None — all configuration is hardcoded or CLI-driven. This project edits text files on disk and has no runtime configuration.

---

## Execution Contract

Before claiming any task complete, provide:

1. **Exact action taken** — what you did, specifically
2. **Direct evidence** — file path + line, command + output, diff, or screenshot
3. **Verification result** — run the verification sequence above, all must exit 0
4. **Status** — mark COMPLETE only after steps 1-3 are proven

See `.supercache/contracts/execution-contract.md` for the full contract.

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
