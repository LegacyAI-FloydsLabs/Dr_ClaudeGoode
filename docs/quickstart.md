# Getting Started

*Or: From Zero to Personality-Swapped in Under a Minute (Floyd Timed It)*

---

## Before You Start

You need two things:

1. Claude Code installed on macOS
2. This repository on your machine somewhere

If you're missing either of those, no amount of documentation is going to help you. Floyd believes in you, but Floyd is also a realist.

---

## Step 1: Pick a Personality

```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh --list
```

You'll see all five with their descriptions. Pick whichever one matches the kind of session you want. Or the one that sounds like it would annoy Douglas the most. Your call.

---

## Step 2: Activate It

```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh sentinel
```

The script does three things, none of which require you to understand bash scripting:

1. **Backs up your originals** — `~/.claude/CLAUDE.md` and `~/.claude/MEMORY.md` get timestamped copies in `~/.claude/personality-backup/`. First swap also saves permanent `.original` copies. This was Floyd's idea. Douglas thought backups were "unnecessary." Douglas was wrong. Floyd said nothing and built them anyway.

2. **Swaps CLAUDE.md** — full file replacement. The personality's entire behavioral contract becomes your active instruction set.

3. **Injects MEMORY.md overlay** — the personality's identity section gets appended between marker lines. Your existing memory content stays intact. Nothing gets eaten.

---

## Step 3: Verify It Took

```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh --verify
```

Four checks run:

- CLAUDE.md has a personality header
- MEMORY.md has an overlay marker with the right name
- State file matches what you activated
- Governance references are still present (because Floyd is thorough)

All four should pass. If they don't, something went wrong and you should visit [Troubleshooting](troubleshooting.md). Or, as Douglas would say, "just run it again and see what happens."

---

## Step 4: Start a New Claude Code Session

This is the part people forget. Including Douglas. Twice.

Claude Code loads its instruction files at session start. If you had a session running when you swapped, that session still has the old personality. It's not magic. It's a stateless API call. Open a new session.

---

## Changing Personalities

Just run the swap command again. No need to restore between swaps. Each swap:

- Creates a new timestamped backup
- Strips any previous MEMORY.md overlay before injecting the new one
- Overwrites CLAUDE.md with the new personality

Swap as many times as you want. Floyd tested this. Douglas didn't believe Floyd needed to test it this many times. Floyd tested it anyway.

---

## Going Back to Default

```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh --restore
```

Copies the `.original` backup files back and removes the state file. You're back to wherever you were before the first swap ever happened. Like it never occurred. Which is more than Douglas can say for most of his decisions.

---

## Proving the Personalities Are Different

```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-rubric-test.sh --static
```

This runs 10 metrics across all 5 personalities and checks five things:

1. No two personalities are identical
2. At least 3 unique domain specializations
3. Tone spread is wide enough (warmth and severity range > 3)
4. Behavioral density spread is wide enough (range > 5)
5. Evidence rigor spread is wide enough (range > 5)

If all five pass, the personalities are measurably distinct. If any fail, someone made them too similar and Floyd will have opinions about it.

---

## What's Next

Read the [User Guide](user-guide.md) for detailed breakdowns of each personality, what surfaces get swapped, and how the engine actually works under the hood. Spoiler: it's files. It's always files.
