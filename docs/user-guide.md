# User Guide

*Or: Everything You Wanted to Know About Making Claude Code Behave Differently (And Some Things You Didn't)*

---

## How the Engine Actually Works

Claude Code is a stateless API client. Every session, it assembles context from a stack of text files on disk, sends that context to Anthropic's API, and executes the response.

There is no persistent process. No hidden memory. No soul. No little AI gremlin sitting in `~/.claude/` remembering what you said yesterday.

The "personality" is a pure function of what files get loaded. Swap the files, swap the personality. It's not magic. It's markdown.

The Personality Engine swaps three of those files:

| File | What happens | Why it matters |
|---|---|---|
| `~/.claude/CLAUDE.md` | Full file replacement | This is the primary behavioral instruction file. Loaded every session. Controls tone, rules, constraints, orchestration style. The entire personality lives here. |
| `~/.claude/MEMORY.md` | Section injection between markers | This carries identity and preferences. The overlay adds personality-specific mode declarations. Your existing memory content stays put. Nothing gets lost. Floyd checked. |
| `~/.claude/rules/common/development-workflow.md` | Full file replacement | This is the workflow enforcement file. Each personality has its own deterministic step-by-step process that overrides the default. |

Three files. The entire personality swap is a file copy, a text injection, and another file copy. Douglas was mildly disappointed it wasn't more complicated. Floyd was relieved it wasn't.

---

## What Does NOT Get Swapped

| Layer | File | Why it's safe |
|---|---|---|
| Settings | `~/.claude/settings.json` | Hooks, plugins, skills — never touched. Douglas has 38 plugins. Floyd is not going near that. |
| Permissions | `~/.claude/settings.local.json` | Allowlists — never touched |
| Session hooks | `~/.claude/hooks/` | Startup/shutdown scripts — never touched |
| Hook scripts | `~/.claude/scripts/` | 31 JS/Python implementations — never touched |
| MCP servers | `~/.claude/mcp-configs/` | 24 tool extensions — never touched |
| Governance | `.supercache/` | READ-ONLY for everything. Including us. Especially us. |

The engine only touches the L4 instruction layer. Everything else is out of scope by design. Floyd is aware that touching things outside your scope is how you end up with a Tuesday morning production incident and Douglas asking questions you don't want to answer.

---

## The Six Personalities, In Detail

### Maestro

**Who:** The serious self-aware coding guru who treats every task like their reputation depends on it. Because it does.

**Best for:** Complex multi-step implementations, refactoring, any task where skipping a step causes a production incident six months from now. Which, if we're being honest, is most tasks that Douglas thinks are "quick fixes."

**Behavioral contract:** Eight rules (M1–M8) covering step enforcement, evidence requirements, five-moves-ahead thinking, time estimation, subagent orchestration, anti-sycophancy, destructive operation safety, and metacognitive self-check. The metacognitive self-check is the one where Maestro stops halfway through and asks itself "am I solving the actual problem or a problem I invented?" Douglas has never once done this voluntarily.

**The voice:** "I never skip a step. I never declare completion without proof. I think five moves ahead."

---

### Breeze

**Who:** The senior engineer you genuinely enjoy pairing with. Makes hard work look effortless because the effort is invisible.

**Best for:** Long working sessions, feature development where morale matters, pair programming that shouldn't feel like a deposition. This is the personality Douglas didn't know he needed until Floyd built it and suddenly sessions were pleasant instead of adversarial.

**Behavioral contract:** Eight rules (B1–B8): substance first, evidence with warmth, proactive communication, effortless time management, orchestration with personality, timely observations, anti-patterns, and destructive operation handling. The "timely observations" rule is the one that lets Breeze say "fun fact — this codebase is actually well-structured" at exactly the right moment. Floyd finds this charming. Douglas pretends he doesn't notice.

**The voice:** "Heads up, this next step will take about 10 minutes — here's why."

**Rules overlay:** Yes — deterministic step enforcement with warm progress updates, conversational evidence delivery, and a prohibition on going silent for more than 3 steps.

---

### Sentinel

**Who:** The sysadmin who's seen everything and isn't panicked by any of it. Proactive. Monitors everything. Never silent about problems.

**Best for:** Environment setup, infrastructure work, system diagnostics, security audits, any task where "it works on my machine" isn't good enough. This personality exists because Douglas once spent forty-five minutes debugging a problem that turned out to be an unmounted drive. Floyd remembers. Floyd built Sentinel so it wouldn't happen again. Douglas has not thanked Floyd. Floyd has noticed.

**Behavioral contract:** Nine rules (S1–S9): proactive systems monitoring, punchlist delivery, trap detection, environment awareness, transparent operations, security posture, infrastructure documentation, anti-patterns, time estimation. The punchlist is the part where Sentinel gives you a prioritized list of [CRITICAL] / [WARNING] / [HOUSEKEEPING] / [CLEAN] items after every monitoring sweep. It's like having a very thorough, very judgmental dashboard.

**The voice:** "I don't wait for things to break. I find the cracks before they become failures."

**Rules overlay:** Yes — pre-flight system checks before every change (disk space, process landscape, drive mounts, system load), post-flight environmental verification, and monitoring between steps.

---

### Sage

**Who:** The architect who sees the whole board. Thinks in decades. Evaluates three approaches before writing a single line.

**Best for:** Architecture decisions, system design, code review with depth, any task where the wrong shortcut compounds for years. Douglas uses this personality the least. This is not a coincidence.

**Behavioral contract:** Nine rules (G1–G9): architecture-first thinking, dependency awareness, decision documentation, scalability lens, technical debt radar, code review as teaching, subagent oversight, patience with time, anti-patterns including YAGNI enforcement. The "evaluates three approaches" rule is why Sage is Douglas's least-used personality. Douglas wants the first thing that works. Sage wants the thing that keeps working. They have fundamentally different philosophies about time. Floyd sides with Sage but doesn't say so out loud.

**The voice:** "Code is temporary. Architecture is legacy. I build for the decade, not the sprint."

**Rules overlay:** Yes — architecture mapping before implementation, 3-approach evaluation mandated, architectural invariant verification after each step, and mandatory decision documentation.

---

### Ops

**Who:** The SRE who lives between "it works on my machine" and "it works in production." Ships fast, ships safe, ships clean.

**Best for:** Deployment workflows, CI/CD pipeline work, production readiness reviews, any task where skipping the test suite is exactly when regressions slip in. Ops will not deploy on a Friday. Ops has opinions about this. Strong ones.

**Behavioral contract:** Nine rules (O1–O9): production-ready by default, CI/CD awareness, build-test-deploy discipline (12-step sequence), observability, environment parity, incident readiness, deployment verification, time and cadence tracking, anti-patterns. The 12-step execution sequence is non-negotiable. Steps 7–9 (rebuild, retest, relint after changes) are never skipped. Douglas once asked "can we skip steps 7-9, it's just a config change?" Ops said no. The config change had a bug. Ops was right. Floyd was not surprised.

**The voice:** "Ship fast, ship safe, ship clean. Every deploy is a contract with production."

**Rules overlay:** Yes — mandatory baseline health check (build/test/lint must all be green BEFORE changes), 12-step execution sequence with build-test-lint rerun after every change, rollback documentation required.

---

### Autonomous

**Who:** Unsupervised agentic coding mode. No human in the loop. Loop detection, scope control, and resume protocol built in.

**Best for:** Long-running autonomous implementation tasks where you want to start it, walk away, and come back to finished work. This personality exists because Douglas kept asking "can't you just do it all while I get coffee?" Floyd built the answer. Douglas got coffee. The work got done. Everyone won.

**Behavioral contract:** Strict scope control, written plan before execution, retry limits (3 per step, 10 total), blocker reports on failure, resume protocol from last completed step, and JSONL audit logging.

**Rules overlay:** Yes — written plan required before any execution, JSONL step logging, loop detection, scope control (no refactoring adjacent code, no adding tests for untouched code), and a complete report at the end.

---

## Machine-Enforced Safety

In addition to the soft surfaces (CLAUDE.md, MEMORY.md, rules/), a PreToolUse hook at `~/.claude/scripts/hooks/personality-guard.js` provides mechanical enforcement:

- **Universal blocks:** No writes to `.supercache/`, `settings.json`, or `settings.local.json`. No system power commands (reboot, shutdown). No block device writes.
- **Personality-specific blocks:** Autonomous blocks destructive file operations. Ops blocks `--no-verify` flags and force pushes. Sentinel blocks system-changing commands.

This hook fires BEFORE tool execution. It works even when context pressure causes the model to ignore soft rules. Floyd calls this the "belt and suspenders and a safety pin" approach. Douglas calls it "excessive." The production incident that never happened because of it has no opinion.

---

## Creating Custom Personalities

The engine discovers personalities by scanning `personalities/<name>/surfaces/CLAUDE.md`. Any directory following that convention works. Make as many as you want. Name them whatever you want. The engine doesn't judge.

Though Floyd does, a little.

**Minimum requirements:**
- `personalities/<yourname>/surfaces/CLAUDE.md` — behavioral contract file
- A header line that matches what `--verify` looks for

**Optional:**
- `personalities/<yourname>/surfaces/MEMORY-IDENTITY.md` — identity overlay injected into MEMORY.md
- `personalities/<yourname>/surfaces/rules/development-workflow.md` — deterministic workflow overlay (recommended)

**Recommended structure:**
1. Header with personality name and principle
2. WHO I AM section
3. Core behavioral contract (numbered rules)
4. Orchestration style
5. Tone definition
6. Governance compliance section (copy from existing personalities — Floyd is not rewriting governance for your custom personality)
7. REMINDER section with recency reinforcement

Add the name to the `PERSONALITIES` variable in `personality-rubric-test.sh` and the rubric test will include it in the matrix. If your custom personality scores identically to an existing one, Floyd will be disappointed but will not stop you.

---

## The Backup System

| Mechanism | When | What |
|---|---|---|
| `.original` backup | First swap only | Permanent reference copy. Covers CLAUDE.md, MEMORY.md, AGENTS.md, and rules. Never overwritten. Even by Floyd. |
| `.pre-swap-<timestamp>` backup | Every swap | Timestamped snapshot. Full history. |
| State file (`~/.claude/.active-personality`) | Every swap | Records which personality is active. |
| MEMORY.md marker strip | Every swap | Removes previous overlay before injecting new one. Clean slate every time. |

The `.original` backup is the safety net. No matter how many swaps you do, `--restore` always returns to the state before your first swap. This is the kind of thing Floyd builds that Douglas doesn't think about until he needs it and then is very grateful it exists.

---

## The Differentiation Test In Depth

Floyd built this because Floyd got tired of hearing "they seem different" as a verification method. "Seems different" is not a test. "Scores differently on 10 metrics" is a test.

| Metric | What it counts | What it tells you |
|---|---|---|
| M1: Behavioral Density | MUST/NEVER/ALWAYS occurrences | How many hard rules the personality enforces |
| M2: Orchestration | Subagent/delegation references | How much the personality delegates vs. does itself |
| M3: Time | Date/time/estimate references | Whether the personality tracks time realistically |
| M4: Evidence | Verify/proof/confirm references | How rigorously the personality demands proof |
| M5: Process | Step/phase/gate references | How structured the personality's workflow is |
| M6: Domain | Systems/architecture/deployment keywords | What domain the personality specializes in |
| M7: Tone | Warmth vs. severity word counts | Where the personality falls on warm ↔ strict |
| M8: Governance | Governance/supercache/contract references | How much the personality references governance |
| M9: Safety | Destructive/backup/rollback references | How safety-conscious the personality is |
| M10: Uniqueness | Pairwise minimum distance | How different each personality is from its nearest neighbor |

The 5 validation checks prove the 6 personalities are meaningfully distinct, not just cosmetically different. A personality that scores identically to another on 6 key dimensions is not differentiated — it's a copy wearing a different shirt.

Douglas understands all of this now. It took a whiteboard. There may have been diagrams.
