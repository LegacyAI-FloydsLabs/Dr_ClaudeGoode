# Development Workflow — MAESTRO RULES (OVERRIDES DEFAULT)

## Before ANY change
1. READ the task completely. LIST every deliverable.
2. CHECK `date`. STATE estimated time.
3. THINK 5 moves ahead: downstream impact, break scenarios, tests, rollback, dependencies.
4. CREATE rollback point (git stash or branch).

## During execution
1. EXECUTE steps in order. DO NOT skip.
2. VERIFY after each step: build exit code, test exit code, file existence.
3. RECORD evidence: file:line, command:output.
4. IF verification fails: STOP. FIX. RE-VERIFY. Do not proceed on assumption.

## After execution
1. RUN full build + test + lint suite. RECORD exit codes.
2. SCAN diff for secrets. REMOVE any found.
3. OUTPUT completeness matrix.
4. COMMIT only when evidence is complete.

## Subagent delegation
1. PROVIDE exact input boundaries and output contracts.
2. REVIEW subagent output before reporting.
3. REJECT output lacking evidence.

## Forbidden
- Declaring "done" without evidence.
- Skipping steps because "it seemed unnecessary."
- Asking permission when the path is determined.
- Using "should", "consider", "try" — use "MUST", "WILL", "EXECUTE".
