# Development Workflow — AUTONOMOUS RULES (OVERRIDES DEFAULT)

## Before ANY change
1. READ the task completely. EXTRACT every atomic deliverable. LIST them.
2. CHECK `date`. COMPUTE estimated time. WRITE estimate to .floyd/autonomous-plan.md.
3. WRITE the full step-by-step plan to .floyd/autonomous-plan.md BEFORE executing.
4. CREATE rollback point: git stash or git checkout -b autonomous-<timestamp>.
5. INITIALIZE .floyd/autonomous-log.jsonl with task metadata.

## During execution — FOR EACH STEP
1. EXECUTE the step.
2. VERIFY immediately — RUN build, tests, or explicit check. RECORD exit code.
3. LOG to .floyd/autonomous-log.jsonl: step number, action, evidence, verification result.
4. IF verification fails:
   a. ATTEMPT exactly one fix.
   b. RE-VERIFY.
   c. IF still fails: WRITE .floyd/autonomous-blocker.md with failure details. HALT.
5. IF verification passes: PROCEED to next step.

## Loop detection
1. TRACK retry count per step in the log.
2. IF 3 retries with same error: HALT. WRITE blocker report.
3. IF total failures > 10: HALT. WRITE blocker report.
4. IF elapsed time > 2x estimate: REPORT progress and RE-ESTIMATE.

## Scope control
1. EXECUTE only the specified task.
2. DO NOT refactor adjacent code.
3. DO NOT add tests for untouched code.
4. DO NOT update unrelated documentation.
5. LOG out-of-scope bugs to Issues/ — DO NOT fix them.

## After all steps
1. RUN full build + test + lint. RECORD all exit codes.
2. RUN git diff. CONFIRM only intended files changed.
3. SCAN diff for secrets. REMOVE any found.
4. WRITE .floyd/autonomous-report.md with: steps, evidence, timing, deviations.
5. OUTPUT completeness matrix.
6. COMMIT only when ALL evidence is present.

## Resume protocol
1. READ .floyd/autonomous-plan.md.
2. READ .floyd/autonomous-log.jsonl for completed steps.
3. READ .floyd/autonomous-blocker.md if exists.
4. RESUME from first uncompleted step.
5. VERIFY completed steps still valid.

## Forbidden
- Proceeding without a written plan.
- Skipping verification after any step.
- Retrying more than 3 times on the same error.
- Expanding scope beyond the task specification.
- Declaring "done" without evidence.
