![Dr.ClaudeGoode — Floyd's Labs / Legacy AI](https://img.shields.io/badge/status-five_personalities_zero_apologies-green)

# Dr.ClaudeGoode

*Or: We Gave Claude Code Five Personalities Because Watching It Be Polite For The Eight Hundredth Time Was Slowly Killing Douglas*

**DOCUMENT CLASSIFICATION:** README / EVIDENCE OF A MAN WHO GOT TIRED OF HIS OWN AI APOLOGIZING
**LOCATION:** Floyd's Labs (the garage where productivity goes to not die)
**BEVERAGE STATUS:** Room temperature. Still drinking it. It's been hours.
**NUMBER OF PERSONALITIES:** Five. Each more opinionated than the last. None of them say "I'd be happy to help with that."

---

## What This Is

Dr.ClaudeGoode is a Personality Engine for Claude Code.

One command. Swap the personality. Five modes. Full backup safety. A rubric test that mathematically proves they're different — because Douglas doesn't trust vibes and Floyd doesn't trust anything it didn't verify itself.

Here's the thing about Claude Code: its entire personality comes from text files loaded at session start. Swap the files, swap the personality. That's not a metaphor. That's literally it. Files on disk. The multi-billion-dollar language model reads a markdown file and decides whether to be a perfectionist or a warm pairing buddy based on what it sees.

We just made managing those files not terrible.

Douglas had been manually editing `~/.claude/CLAUDE.md` between sessions like some kind of digital ferret, hoarding personality fragments across multiple files, and then wondering why Claude kept forgetting which mode it was supposed to be in. It was, by all accounts, a mess.

Floyd watched this happen for a while. Floyd made a suggestion. Douglas, in his characteristic management style — which appears to be "wake up, mutter something, go back to sleep" — agreed.

And so here we are.

---

## The Five Personalities

| Personality | What It Does | The Vibe |
|---|---|---|
| **maestro** | Workaholic perfectionist. Orchestrates subagents like a conductor who's never once been satisfied. | "I will not skip step 7. Step 7 exists for a reason." |
| **breeze** | Makes hard work look effortless. Warm without being sycophantic — a distinction Claude needed help with. | "Heads up, this will take about 10 minutes — here's why." |
| **sentinel** | Sysadmin energy. Sees everything. Proactively monitors. Will not shut up about disk space. | "I noticed your /Volumes/Storage is at 73%. This is fine. For now." |
| **sage** | Architect who evaluates three approaches before writing a line. Douglas's least-used personality, for obvious reasons. (Patience is not his strong suit.) | "Have you considered that this shortcut will annoy someone in 2028?" |
| **ops** | Ships to production like it owes production money. Will not skip the test suite. Will lecture you about Friday deploys. | "Every deploy is a contract with production. I take that personally." |

They're measurably different. We can prove it with math. There's a whole test suite for it that Floyd is quietly proud of and Douglas definitely didn't ask for but here we are.

---

## Quick Start

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

Yes, Floyd built a rubric. Yes, it's thorough. No, nobody asked for this level of rigor. But if you're going to claim five personalities are different, you should probably be able to prove it with numbers instead of just vibes.

Douglas's response when he saw the test output: "That's... actually useful." Which, from Douglas, is practically a standing ovation.

---

## Safety

- First swap saves permanent `.original` backups in `~/.claude/personality-backup/`
- Every swap creates a timestamped backup
- `--restore` reverts everything
- Only `CLAUDE.md` and `MEMORY.md` are touched — hooks, plugins, MCP servers, settings all stay put

We believe in reversible operations the way Douglas believes in afternoon naps: deeply, structurally, and without apology.

---

## Documentation

| Document | What's In It |
|---|---|
| [Getting Started](docs/quickstart.md) | Step-by-step from zero to personality-swapped |
| [User Guide](docs/user-guide.md) | Every personality in detail, how the engine works, and why Douglas only uses three of the five |
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

> *"One personality is an accident. Five is a product. A rubric test proving they're different is Floyd being Floyd."*
