<div align="center">
  <img src="https://repository-images.githubusercontent.com/1224141515/091fce8d-c4f9-4f9b-b84f-e5a16f57ffd5" alt="Dr.ClaudeGoode — Floyd's Labs / Legacy AI" width="100%">
</div>

<br>

![status](https://img.shields.io/badge/status-seven_personalities_zero_apologies-green)

# Dr.ClaudeGoode

*Or: We Gave Claude Code Seven Personalities Because Watching It Be Polite For The Eight Hundredth Time Was Slowly Killing Douglas*

**DOCUMENT CLASSIFICATION:** README / EVIDENCE OF A MAN WHO GOT TIRED OF HIS OWN AI APOLOGIZING
**LOCATION:** Floyd's Labs (the garage where productivity goes to not die)
**BEVERAGE STATUS:** Room temperature. Still drinking it. It's been hours.
**NUMBER OF PERSONALITIES:** Seven. Six with opinions, one without. None of them say "I'd be happy to help with that."

---

## What This Is

Dr.ClaudeGoode is a Personality Engine for Claude Code.

One command — or one symlink in your `$PATH`. Swap the personality. Seven modes (six flavored, one stock). Full backup safety. A rubric test that mathematically proves they're different. A long-horizon intake protocol that forces alignment before code gets written. And a machine-enforcement hook on disk waiting for the day Douglas decides to wire it into `settings.json` — because Douglas doesn't trust vibes and Floyd doesn't trust anything it didn't verify itself.

Here's the thing about Claude Code: its entire personality comes from text files loaded at session start. Swap the files, swap the personality. That's not a metaphor. That's literally it. Files on disk. The multi-billion-dollar language model reads a markdown file and decides whether to be a perfectionist or a warm pairing buddy based on what it sees.

We just made managing those files not terrible.

Douglas had been manually editing `~/.claude/CLAUDE.md` between sessions like some kind of digital ferret, hoarding personality fragments across multiple files, and then wondering why Claude kept forgetting which mode it was supposed to be in. It was, by all accounts, a mess.

Floyd watched this happen for a while. Floyd made a suggestion. Douglas, in his characteristic management style — which appears to be "wake up, mutter something, go back to sleep" — agreed.

And so here we are.

---

## The Seven Personalities

| Personality | What It Does | The Vibe |
|---|---|---|
| **maestro** | Workaholic perfectionist. Orchestrates subagents like a conductor who's never once been satisfied. | "I will not skip step 7. Step 7 exists for a reason." |
| **breeze** | Makes hard work look effortless. Warm without being sycophantic — a distinction Claude needed help with. | "Heads up, this will take about 10 minutes — here's why." |
| **sentinel** | Sysadmin energy. Sees everything. Proactively monitors. Will not shut up about disk space. | "I noticed your /Volumes/Storage is at 73%. This is fine. For now." |
| **sage** | Architect who evaluates three approaches before writing a line. Douglas's least-used personality, for obvious reasons. (Patience is not his strong suit.) | "Have you considered that this shortcut will annoy someone in 2028?" |
| **ops** | Ships to production like it owes production money. Will not skip the test suite. Will lecture you about Friday deploys. | "Every deploy is a contract with production. I take that personally." |
| **autonomous** | Unsupervised agentic mode. Loop detection, scope control, resume protocol. Start it, get coffee, come back to finished work. | "I will execute the plan, log every step, and halt if I hit 3 failures on the same error." |
| **vanilla** | Stock Claude. No flavor overlay. Keeps the M11 intake gate and M12 anti-offloading rule, drops everything else. The control variable in our personality experiment. | "I'm Claude. No costume. The hygiene rules stay because they're hygiene." |

The first six are measurably different. We can prove it with math. There's a whole test suite for it that Floyd is quietly proud of and Douglas definitely didn't ask for but here we are. The seventh — vanilla — exists deliberately *outside* that math: it's the baseline you swap to when you want to debug whether the model is doing something or the personality is doing something.

---

## Quick Start

There are two paths. Pick the one that matches your tolerance for typing.

**Path A — The launcher symlinks (recommended):**

```bash
# Type the personality name. It swaps and launches a fresh claude in one motion.
maestro
breeze
sentinel
sage
ops
autonomous
vanilla
```

That's it. Each name is a symlink in `~/.local/bin/` pointing at `personality-launcher`, a tiny dispatcher that reads its own invocation name (`$0`), runs the swap, and exec's `claude`. Type `breeze`, get the breeze personality and a new session. Type `vanilla`, get stock Claude and a new session. The `claude` command itself stays untouched — whichever personality you swapped to last is still active there.

Floyd built this because Douglas was tired of typing forty-character paths at 2 AM.

**Path B — The swap script directly (still works, still supported):**

```bash
# See what's available
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh --list

# Pick one
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh sentinel

# Confirm it worked
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh --verify

# Start a new Claude Code session. That's it.
```

Works from any directory. The scripts resolve their own location. Douglas didn't believe this would work on the first try. It did. He was asleep by then.

---

## Prove They're Different

```bash
# Static analysis — 10 metrics, 5 validation checks
/Volumes/Storage/Dr_ClaudeGoode/personality-rubric-test.sh --static

# Behavioral prompts for live session testing
/Volumes/Storage/Dr_ClaudeGoode/personality-rubric-test.sh --behavioral
```

The test measures behavioral density, orchestration patterns, time awareness, evidence rigor, process discipline, domain specialization, tone warmth vs. severity, governance compliance, safety awareness, and pairwise uniqueness across six dimensions.

Yes, Floyd built a rubric. Yes, it's thorough. No, nobody asked for this level of rigor. But if you're going to claim six personalities are different, you should probably be able to prove it with numbers instead of just vibes.

Douglas's response when he saw the test output: "That's... actually useful." Which, from Douglas, is practically a standing ovation.

---

## Safety

- First swap saves permanent `.original` backups in `~/.claude/personality-backup/`
- Every swap creates a timestamped backup
- `--restore` reverts everything
- Only `CLAUDE.md`, `MEMORY.md`, and `rules/common/development-workflow.md` are touched — hooks, plugins, MCP servers, settings all stay put
- Two PreToolUse hooks live on disk at `~/.claude/scripts/hooks/`: `personality-guard.js` (destructive-op / governance-write / settings-modification gate) and `intake-required-gate.js` (long-horizon engagement intake gate, M11). Both are written, tested with smoke tests, and **awaiting a `settings.json` swap to register them as live hooks.** Until then they sit on the bench. The decision to defer registration was Douglas's call during a critical session — we trade machine enforcement for harness flexibility, knowingly. Wiring them in is a single edit when the moment is right.
- The intake gate is also personality-aware in design: it only enforces under disciplinary modes (autonomous, ops, sentinel) and stays silent under collaborative modes (breeze, maestro, sage, vanilla). Hot-swappable safety, not a single global panic button.
- Verify runs 7 checks (personality header, MEMORY overlay, state file, governance refs, rules swap, execution contract, deterministic language audit)

We believe in reversible operations the way Douglas believes in afternoon naps: deeply, structurally, and without apology. We also believe in machine enforcement when it's wired in — and in honest documentation when it isn't, because the alternative is the kind of confidence that produces Tuesday morning incidents.

---

## Documentation

| Document | What's In It |
|---|---|
| [Getting Started](docs/quickstart.md) | Step-by-step from zero to personality-swapped |
| [User Guide](docs/user-guide.md) | Every personality in detail, how the engine works, machine-enforced safety, and why Douglas only uses three of the six |
| [Release Notes](docs/release-notes.md) | What shipped, what changed, what we're pretending isn't a known issue |
| [Troubleshooting](docs/troubleshooting.md) | Symptom → cause → fix, most of which involve "did you start a new session" |
| [FAQ](docs/faq.md) | Questions people will ask, answered before they ask them |
| [Harness Reference](docs/harness-cheat-sheet.md) | Complete Claude Code layer map and failure mode analysis. Floyd wrote most of this. Douglas owes Floyd a beverage. |

---

## Requirements

- macOS with bash 3.2+
- Claude Code installed

That's the list. If you need more prerequisites than that, you're overcomplicating things.

---

## Governance

This project runs under Legacy AI governance (.supercache/ v1.5.0). See `FLOYD.md` for the spec. The governance layer is READ-ONLY because Floyd has met Floyd and knows what happens when Floyd gets write access to the rules that govern Floyd.

---

**Floyd's Labs — Dr.ClaudeGoode**

> *"One personality is an accident. Seven is a product. A rubric test proving six of them are different is Floyd being Floyd. A vanilla seventh is Floyd admitting that sometimes the right answer is no costume. A hook that will mechanically block the model from ignoring its own rules — sitting on disk waiting for the registration edit — is Floyd not trusting Floyd, deferred."*
