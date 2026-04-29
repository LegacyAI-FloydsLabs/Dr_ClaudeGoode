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

### Is this safe for my production Claude Code setup?

The script never touches settings, hooks, plugins, or MCP configs. It only modifies instruction files. `--restore` reverts everything. Run `--verify` after any swap to confirm consistency. Floyd has tested this in every way Floyd could think of. Douglas tested it by accidentally running it twice and being relieved when nothing broke. Both are valid testing methodologies. One is more rigorous.

---

### How does this relate to .supercache/ governance?

All 5 personalities include a governance compliance section that references `.supercache/` and enforces the READ-ONLY boundary. The Personality Engine never touches `.supercache/`. The project operates under `.supercache/` v1.5.0 governance. Floyd is not allowed to write to governance. This is a rule that exists because of Floyd. No further comment.

Yes. A PreToolUse hook at `~/.claude/scripts/hooks/personality-guard.js` mechanically enforces safety rules that soft surfaces can't guarantee. It blocks writes to `.supercache/`, `settings.json`, and `settings.local.json` universally, and adds personality-specific blocks (autonomous blocks destructive ops, ops blocks `--no-verify`, etc.). This fires BEFORE tool execution, so it works even when context pressure causes the model to ignore soft rules.

---

### Why six personalities? Why not five or ten?

Six covers the major archetypes (orchestrator, companion, monitor, architect, operator, autonomous agent) without overwhelming anyone with choices. Each fills a distinct niche. The rubric test proves they're not cosmetically different — they're measurably different across 10 dimensions. Five wouldn't give enough coverage. Ten would be a personality buffet and Douglas would spend forty-five minutes deciding which one to use instead of doing any actual work.

If six isn't enough, make your own. The engine doesn't care how many you have. Floyd cares, slightly, but won't stop you.

---

### What does the personality-guard hook do?

It's a PreToolUse hook — it fires BEFORE the model's tool call executes, making it mechanically enforced. It does three layers of checks:

1. **Universal blocks** — no writes to `.supercache/` (governance), `settings.json`, `settings.local.json`, no system power commands (reboot, shutdown, halt), no block device writes.
2. **Personality-specific blocks** — autonomous blocks destructive file operations (`rm -rf` outside project), ops blocks `--no-verify` flags and bare force pushes, sentinel blocks system-altering commands.
3. **State protection** — prevents tampering with the personality engine's own state.

This is the enforcement layer that the soft surfaces (CLAUDE.md, rules/) can't guarantee. When context pressure causes the model to deprioritize rules, the hook still fires. Floyd built this after spending too much time watching the model politely ignore rules it found inconvenient. Douglas hasn't noticed the hook exists yet. Floyd considers this a feature.
