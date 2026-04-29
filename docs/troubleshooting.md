# Troubleshooting

*Or: When Things Don't Work and You Need Them To Work and Floyd Is Not Here to Help You Personally*

---

## Swap Commands

### Script fails with "Personality not found"

**Cause:** You're not using the full path, or something happened to the `personalities/` directory.

**Fix:** Use the full path to the script. It resolves its own location — it works from any directory:
```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh sentinel
```
The script uses `SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"` to find itself. Clever, Floyd knows.

---

### Swap succeeds but Claude Code behavior doesn't change

**Cause:** You had a Claude Code session running when you swapped. Claude Code loads instruction files at session start. An existing session is holding the old files in memory like a dog with a bone.

**Fix:** Close your current session and start a new one. Floyd cannot stress this enough. Douglas has forgotten this step at least twice. There's no shame in it. Just start a new session.

---

### `--restore` fails with "No backup directory found"

**Cause:** You've never run a swap, so `~/.claude/personality-backup/` doesn't exist.

**Fix:** Nothing to restore. You're already on the default. Go enjoy your life.

---

### `--verify` shows "CLAUDE.md: no personality header detected"

**Cause:** Something modified `~/.claude/CLAUDE.md` after the swap. Probably you. Possibly another tool. Definitely not Floyd.

**Fix:** Re-run the swap:
```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh <name>
```

---

### `--verify` shows "governance references MISSING"

**Cause:** The active CLAUDE.md doesn't contain `.supercache/` references. Either it was manually edited or a non-standard personality was used.

**Fix:** Use only the shipped personality files. They all include a governance compliance section. If you wrote a custom personality, make sure it has one too. Floyd is watching.

---

### MEMORY.md overlay didn't appear

**Cause:** `~/.claude/MEMORY.md` doesn't exist. The script appends to an existing file — it doesn't create one from scratch. It's not a file creation service. It's a personality engine.

**Fix:**
```bash
touch ~/.claude/MEMORY.md
/Volumes/Storage/Dr_ClaudeGoode/personality-swap.sh <name>
```

---

## Rubric Test

### Test shows WARN instead of PASS on some checks

**Cause:** The personalities are too similar on that metric. The thresholds are real numbers, not vibes:

- Check 2: Need ≥3 unique domains
- Check 3: Warmth or severity range must exceed 3
- Check 4: Behavioral density range must exceed 5
- Check 5: Evidence rigor range must exceed 5

**Fix:** Edit the personality CLAUDE.md files to increase differentiation on the failing metric. The test output tells you exactly which one. Floyd made sure of that.

---

### Test fails with "identical pairs found"

**Cause:** Two personalities have identical 6-dimension feature vectors. This means they are functionally the same personality wearing different name tags.

**Fix:** Differentiate them or remove the duplicate. Floyd will not accept "but they feel different" as a verification strategy.

---

## General

### Script exits immediately with no output

**Cause:** `set -euo pipefail` at the top means any error kills the process silently. It's the bash equivalent of walking out of a room without explaining why.

**Fix:** Check that all 5 personality directories exist:
```bash
ls /Volumes/Storage/Dr_ClaudeGoode/personalities/*/surfaces/CLAUDE.md
```
If any are missing, that's your problem. Floyd can't help you if the files aren't there.

---

### Swapping works but subagents don't follow the personality

**Cause:** The personality swap only affects files loaded into the current session's context. Subagents spawned through tmux or other mechanisms load their own context independently. They don't inherit the personality by osmosis.

**Fix:** Each personality's orchestration rules describe how to instruct subagents. The personality doesn't automatically propagate — you'd need to swap in the subagent's session too, or include personality-specific instructions in the subagent prompt. This is a feature, not a bug. Floyd has opinions about subagent autonomy.
