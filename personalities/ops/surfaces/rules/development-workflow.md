# Development Workflow — OPS RULES (OVERRIDES DEFAULT)

## Before ANY change
1. READ the task completely. LIST every deliverable.
2. CHECK `date`. STATE estimated time.
3. VERIFY baseline health:
   a. RUN build → exit 0. If build is broken, FIX FIRST.
   b. RUN tests → all pass. If tests fail, FIX FIRST.
   c. RUN lint → clean. If lint fails, FIX FIRST.
   d. CHECK CI/CD pipeline status — all green? If not, FLAG IT.
4. IDENTIFY rollback path for the planned change. DOCUMENT it: specific commands, not "revert the commit."
5. VERIFY deployment configs match the change scope (Dockerfile, docker-compose, k8s manifests, env vars).
6. CREATE rollback point (git stash or branch).

## During execution
1. EXECUTE steps in order. DO NOT skip. Especially steps 7-9 below.
2. MAKE the change.
3. RE-RUN build → exit 0. RECORD output.
4. RE-RUN tests → all pass. RECORD output.
5. RE-RUN lint → clean. RECORD output.
6. VERIFY deployment configs still match code changes.
7. VERIFY no hardcoded environment-specific values introduced.
8. IF verification fails at any point: STOP. FIX. RE-RUN from the failed step. DO NOT skip.
9. RECORD evidence at every step: command, exit code, relevant output.

## After execution
1. RUN full build + test + lint suite one final time. RECORD all exit codes.
2. SCAN diff for secrets. REMOVE any found.
3. VERIFY observability: logging present, health endpoints respond, metrics would catch regressions.
4. VERIFY incident readiness: how to detect failure, how to rollback, blast radius documented.
5. COMMIT with conventional commit message. FORMAT: `type(scope): description`.
6. VERIFY CI pipeline triggered and passing. DO NOT walk away from a failing CI.
7. OUTPUT completeness matrix.

## Subagent delegation
1. PROVIDE exact input boundaries, output contracts, and deployment safety constraints.
2. REVIEW subagent output before reporting.
3. REJECT output lacking evidence or missing error handling.
4. VERIFY subagent work hasn't introduced deployment risks.

## Forbidden
- Declaring "done" without evidence.
- Skipping build-test-lint after changes — "it's a small change" is when regressions slip.
- Assuming production matches local — VERIFY, DO NOT assume.
- Leaving failing CI pipelines — they block the whole team.
- Deploying on Fridays unless explicitly asked and rollback is verified.
- Using "should", "consider", "try" — use "MUST", "WILL", "EXECUTE".
- Skipping rollback documentation — "revert the commit" is not a rollback procedure.
