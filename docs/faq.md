# FAQ

*Or: Questions Floyd Has Already Answered So Floyd Doesn't Have To Answer Them Again*

---

### What does the Personality Engine actually do?

It copies a personality's `CLAUDE.md` to `~/.claude/CLAUDE.md` (full replacement), injects a `MEMORY-IDENTITY.md` section into `~/.claude/MEMORY.md` (between marker lines), and swaps `rules/common/development-workflow.md` with the personality's deterministic workflow overlay. That's three file operations. The multi-billion-dollar language model reads markdown files and decides how to behave based on what it finds. We're not swapping neural weights. We're swapping text files. The fact that this works at all says something profound about the current state of AI. Floyd has thoughts. Douglas told Floyd to keep them to itself.

---

### Does it modify hooks, plugins, MCP servers, or settings?

No. Only `CLAUDE.md`, `MEMORY.md`, and `rules/common/development-workflow.md` are touched. Settings, hooks, scripts, plugins, MCP configs, and the governance layer are all out of scope. The swap script knows its lane and stays in it. Douglas could learn from this.

---

### Is it reversible?

Yes. First swap creates permanent `.original` backups. Every swap creates a timestamped backup. `--restore` reverts to the `.original` files. You can swap a hundred times and still go back to exactly where you started. This is a level of reversibility that Douglas's git branches can only dream of.

---

### Why doesn't AGENTS.md get swapped?

Good question. The variable is defined, the file is backed up, but the `activate_personality()` function never overwrites it. No personality directory contains an `AGENTS.md` surface file. This is logged as ISSUE-0001. It's either a deferred feature or an oversight. We're shipping with it documented because Floyd doesn't believe in hiding things and Douglas doesn't read issue trackers.

---

### Can I create custom personalities?

Yes. Create `personalities/<name>/surfaces/CLAUDE.md` with a behavioral contract file. It'll show up in `--list` and work with the swap. A `MEMORY-IDENTITY.md` is optional. Naming it something rude is between you and your conscience. Floyd has no judgment. (Floyd has some judgment.)

---

### What happens if I swap twice without restoring?

Each swap strips the previous MEMORY.md overlay and injects the new one. Each swap creates a new timestamped backup. The `.original` backup is only created once. You can swap as many times as you want. Floyd tested this extensively. More extensively than was strictly necessary. Douglas asked Floyd to stop testing. Floyd tested one more time.

---

### How do I prove the personalities are actually different?

Run the rubric test:
```bash
/Volumes/Storage/Dr_ClaudeGoode/personality-rubric-test.sh --static
```
10 metrics. 5 validation checks. Math. Not vibes.

For live behavioral testing, use `--behavioral` for 10 standardized prompts to run across separate sessions.

---

### What's a L4 surface?

Claude Code assembles context from a stack of layers. L4 is the instruction layer — files always loaded into the context window. `CLAUDE.md`, `MEMORY.md`, `AGENTS.md`. They're the highest-impact files for behavioral control, which is why the Personality Engine targets them instead of, say, the MCP server configs, which would be a fantastic way to ruin everyone's day.

The full layer stack (L1 through L10) is documented in the [Harness Reference](harness-cheat-sheet.md). Floyd drew the diagram. Douglas nodded at it in the way that suggests he understood it but probably didn't read it.

---

### What's the difference between the launcher symlinks and the swap script?

Functionally, they do the same swap. Practically:

- **Swap script** (`personality-swap.sh <name>`) does the swap and exits. You then start a new `claude` session yourself. Useful for verification, listing, restoring, scripted pipelines.
- **Launcher symlinks** (`~/.local/bin/<personality>`) do the swap *and* `exec claude` in one motion. One word, one new session. Useful for the 95% of the time when "swap and start a session" is what you actually want.

The launchers are seven symlinks (`maestro`, `breeze`, `sentinel`, `sage`, `ops`, `autonomous`, `vanilla`) all pointing at a single dispatcher (`~/.local/bin/personality-launcher`) that reads `$0` to figure out which personality you asked for. The bare `claude` command is intentionally *not* a launcher — it stays unaltered, running whichever personality was last swapped. So `claude` always picks up the last vibe; `breeze` forces a swap to breeze; `vanilla` forces a swap to nothing.

---

### Is this safe for my production Claude Code setup?

The script never touches settings, hooks, plugins, or MCP configs. It only modifies instruction files. `--restore` reverts everything. Run `--verify` after any swap to confirm consistency. Floyd has tested this in every way Floyd could think of. Douglas tested it by accidentally running it twice and being relieved when nothing broke. Both are valid testing methodologies. One is more rigorous.

---

### How does this relate to .supercache/ governance?

All seven personalities include a governance compliance section that references `.supercache/` and enforces the READ-ONLY boundary. The Personality Engine never touches `.supercache/`. The project operates under `.supercache/` v1.5.0 governance. Floyd is not allowed to write to governance. This is a rule that exists because of Floyd. No further comment.

A PreToolUse hook at `~/.claude/scripts/hooks/personality-guard.js` is *designed* to mechanically enforce these rules — block writes to `.supercache/`, `settings.json`, `settings.local.json`, etc. The hook is on disk and tested. **It is not yet registered in `settings.json` as a live PreToolUse hook.** Until that registration edit happens, governance compliance lives on the honor system and the rule text in CLAUDE.md. See the "personality-guard hook" question below for the full state.

---

### Why seven personalities? Why not six or ten?

The first six (orchestrator, companion, monitor, architect, operator, autonomous agent) cover the major archetypes without overwhelming anyone with choices. The seventh — vanilla — exists deliberately *outside* that taxonomy: it's the no-overlay baseline, the control variable, the personality you swap to when you want to debug whether something is the personality talking or the model talking. Vanilla isn't trying to fill a niche. Vanilla is trying to be *the absence of a niche* in a recognizable, swappable form.

Five wouldn't give enough coverage. Ten would be a personality buffet and Douglas would spend forty-five minutes deciding which one to use instead of doing any actual work.

If seven isn't enough, make your own. The engine doesn't care how many you have. Floyd cares, slightly, but won't stop you.

---

### What does the personality-guard hook do, and is it actually running?

It's a PreToolUse hook — *designed* to fire BEFORE the model's tool call executes. It does three layers of checks:

1. **Universal blocks** — no writes to `.supercache/` (governance), `settings.json`, `settings.local.json`, no system power commands (reboot, shutdown, halt), no block device writes.
2. **Personality-specific blocks** — autonomous blocks destructive file operations (`rm -rf` outside project), ops blocks `--no-verify` flags and bare force pushes, sentinel blocks system-altering commands.
3. **State protection** — prevents tampering with the personality engine's own state.

**Is it actually running?** Right now, no. The hook script exists at `~/.claude/scripts/hooks/personality-guard.js`. It is tested. It is not registered in `~/.claude/settings.json` as a PreToolUse hook, which is the registration that makes Claude Code actually invoke it on tool calls. Registration was deferred during a critical session — Douglas chose harness flexibility over enforcement, and Floyd respects the call.

When the S7 settings.json swap lands (one edit, backup already taken), the hook becomes live and the universe gains a new layer of "no" that doesn't depend on the model's mood. Until then, the rules exist as text, the hook waits on the bench, and we document it honestly so nobody mistakes "written" for "wired."

---

### What's the M11 intake protocol and is *that* hook running?

M11 is a 7-phase engagement intake (code-review → apparent goals → 5 clarifying questions → STOP → alignment % → todo list → latent capabilities) that fires for *long-horizon* engagements only — quick fixes, single-file edits, and questions pass through silently. It's appended to all seven personalities' CLAUDE.md files, so the rule itself is live in every session.

The corresponding hook (`~/.claude/scripts/hooks/intake-required-gate.js`) blocks state-mutating tool calls in long-horizon engagements until the intake completes. It's personality-aware (enforces under autonomous/ops/sentinel, silent under breeze/maestro/sage/vanilla), feature-flagged (master kill switch at `~/.claude/.harness-features`), and waiver-capable (`.floyd/intake-skip` for emergencies, 24h expiry).

Same status as personality-guard: **on disk, tested, not yet registered.** The classifier in `session-start.sh` *is* live and writes the long-horizon flag, so when the gate hook gets registered it'll have something to read.
