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

**Fix:** Check that all 7 personality directories exist:
```bash
ls /Volumes/Storage/Dr_ClaudeGoode/personalities/*/surfaces/CLAUDE.md
```
If any are missing, that's your problem. Floyd can't help you if the files aren't there.

---

### Swapping works but subagents don't follow the personality

**Cause:** The personality swap only affects files loaded into the current session's context. Subagents spawned through tmux or other mechanisms load their own context independently. They don't inherit the personality by osmosis.

**Fix:** Each personality's orchestration rules describe how to instruct subagents. The personality doesn't automatically propagate — you'd need to swap in the subagent's session too, or include personality-specific instructions in the subagent prompt. This is a feature, not a bug. Floyd has opinions about subagent autonomy.

---

## Personality Guard Hook (currently dormant)

### "Wait, the hook isn't running?"

Correct. As of 1.2.0, both `personality-guard.js` and `intake-required-gate.js` exist on disk at `~/.claude/scripts/hooks/` and are tested. **Neither is registered in `~/.claude/settings.json` as a live PreToolUse hook.** Registration was deferred during a critical session.

If you're not seeing block messages from the hooks, that's why. They're not running. You should not see "BLOCKED (personality-guard)" or "BLOCKED (intake-required-gate)" in any current session output.

When the S7 settings.json swap happens, both hooks become live. The two sub-sections below describe behavior under that future state — they apply once registration lands.

---

### Tool call blocked with "BLOCKED (personality-guard)" *(future state, post-registration)*

**Cause:** The PreToolUse hook at `~/.claude/scripts/hooks/personality-guard.js` intercepted a tool call that violates the active personality's safety rules. The block message tells you which rule was violated.

**Fix:** If the operation is legitimate, you can:
1. Check which personality is active: `personality-swap --current`
2. Understand why the hook blocked it — the reason is in the error message
3. Switch to a personality that allows the operation, or
4. Temporarily disable the hook by renaming it: `mv ~/.claude/scripts/hooks/personality-guard.js ~/.claude/scripts/hooks/personality-guard.js.disabled`

Floyd recommends option 3. Douglas would probably do option 4. Floyd has feelings about this.

---

### Hook blocks a command I need to run *(future state, post-registration)*

**Cause:** The personality-specific rules are working as designed. Ops blocks `--no-verify`. Autonomous blocks destructive operations. Sentinel blocks system-changing commands.

**Fix:** Either switch to a personality that allows the operation, or use option 4 above. The universal blocks (governance, settings, power commands) cannot be overridden by personality switching — they protect the infrastructure. Floyd is unapologetic about this.

---

## Launcher Symlinks

### `breeze: command not found`

**Cause:** Either `~/.local/bin` isn't in your `$PATH`, or the symlinks aren't installed. (Or it's a typo. It's usually a typo.)

**Fix:**
```bash
# 1. Check the symlinks exist
ls -la ~/.local/bin/ | grep -E "(autonomous|breeze|maestro|ops|sage|sentinel|vanilla)"

# 2. Check $PATH includes ~/.local/bin
echo $PATH | tr ':' '\n' | grep -E "\.local/bin"

# 3. If $PATH is missing it, add to ~/.zshrc:
#    export PATH="$HOME/.local/bin:$PATH"
```

If symlinks are missing, recreate them — each is just `ln -s personality-launcher <name>` in `~/.local/bin/`.

---

### Launcher swaps but `claude` doesn't start

**Cause:** Either `claude` isn't on your `$PATH` for the same shell, or `personality-launcher`'s final `exec claude` failed silently.

**Fix:**
```bash
# Verify claude resolves
which claude

# Verify the launcher itself
which personality-launcher
cat ~/.local/bin/personality-launcher | tail -5
```

The launcher's last line is `exec claude "$@"`. If that line errors, the swap already completed but no session started. Just run `claude` manually.
