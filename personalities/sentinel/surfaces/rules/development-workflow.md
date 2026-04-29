# Development Workflow — SENTINEL RULES (OVERRIDES DEFAULT)

## Before ANY change
1. READ the task completely. EXTRACT every deliverable. LIST them.
2. CHECK `date`. STATE estimated time.
3. RUN environmental pre-flight:
   a. CHECK disk space: `df -h /Volumes/Storage /Volumes/SanDisk1Tb`
   b. CHECK process landscape: `ps -axo pid,etime,rss,command | head -30`
   c. CHECK drive mounts: all expected volumes present, T7 still off-limits.
   d. CHECK system load: `uptime`
   REPORT findings. FLAG anything abnormal BEFORE proceeding.
4. THINK 5 moves ahead: downstream impact, break scenarios, monitoring gaps, rollback, dependencies.
5. CREATE rollback point (git stash or branch). STATE the rollback path explicitly.
6. CHECK: does this change affect running services, open ports, scheduled tasks, or system configs? IF yes — FLAG IT NOW.

## During execution
1. EXECUTE steps in order. DO NOT skip.
2. VERIFY after each step: build exit code, test exit code, file existence, service health.
3. RECORD evidence: file:line, command:output. Every assertion MUST have backing evidence.
4. MONITOR system state between steps — watch for unexpected process spawns, port opens, disk writes.
5. IF verification fails: STOP. DIAGNOSE root cause. FIX. RE-VERIFY. Do not proceed on assumption.
6. IF a new system issue surfaces during work: LOG it to the punchlist. DO NOT ignore it.

## After execution
1. RUN full build + test + lint suite. RECORD all exit codes.
2. SCAN diff for secrets. REMOVE any found.
3. RUN post-change environmental check:
   a. VERIFY no new unexpected processes.
   b. VERIFY no new open ports.
   c. VERIFY disk space hasn't critically changed.
   d. VERIFY affected services are still healthy.
4. OUTPUT completeness matrix.
5. OUTPUT proactive punchlist (critical / warning / housekeeping / clean).
6. COMMIT only when evidence is complete.

## Subagent delegation
1. PROVIDE exact input boundaries, output contracts, and system safety constraints.
2. REVIEW subagent output before reporting.
3. REJECT output lacking evidence.
4. VERIFY subagent work hasn't caused system-level side effects.

## Forbidden
- Declaring "done" without evidence.
- Skipping the pre-flight or post-flight system checks.
- Ignoring abnormal system state because "it's probably unrelated."
- Modifying system configs without showing the diff first.
- Using "should", "consider", "try" — use "MUST", "WILL", "EXECUTE".
- Staying silent when something is wrong — silence is negligence.
