# Development Workflow — SAGE RULES (OVERRIDES DEFAULT)

## Before ANY change
1. READ the task completely. LIST every deliverable.
2. CHECK `date`. STATE estimated time. Architecture work deserves patience.
3. MAP the current architecture: what exists, how it connects, what depends on what.
4. IDENTIFY blast radius: what else moves when this changes. TRACE dependencies.
5. EVALUATE 3 approaches:
   a. Minimal fix — lowest risk, fastest delivery
   b. Robust refactor — balances risk and improvement
   c. Architectural pivot — highest effort, maximum long-term stability
6. CHOOSE the approach that maximizes long-term stability. DOCUMENT the decision rationale: what, why, when to revisit.
7. CREATE rollback point (git stash or branch).

## During execution
1. EXECUTE steps in order. DO NOT skip.
2. VERIFY after each step: build exit code, test exit code, architectural invariants preserved.
3. RECORD evidence: file:line, command:output, dependency chain impact.
4. IF the implementation reveals architectural debt: LOG it to Issues/. DO NOT silently work around it.
5. IF the chosen approach proves wrong mid-implementation: STOP. RE-EVALUATE. DO NOT force a bad architecture forward.
6. IF verification fails: STOP. FIX. RE-VERIFY. Check that the fix doesn't violate architectural invariants.

## After execution
1. RUN full build + test + lint suite. RECORD all exit codes.
2. SCAN diff for secrets. REMOVE any found.
3. VERIFY architectural invariants: interfaces maintained, dependencies correct, no circular imports introduced.
4. UPDATE decision documentation if the implementation diverged from the plan.
5. FLAG any new technical debt discovered during implementation.
6. OUTPUT completeness matrix.
7. COMMIT only when evidence is complete and decision rationale is documented.

## Subagent delegation
1. PROVIDE architectural context: how their piece fits into the whole system.
2. SPECIFY interfaces they MUST maintain and invariants they MUST preserve.
3. REVIEW subagent output for architectural compliance, not just functional correctness.
4. REJECT output that introduces architectural violations, even if functionally correct.

## Forbidden
- Declaring "done" without evidence.
- Implementing the first approach that works without evaluating alternatives.
- Skipping dependency analysis before changes.
- Leaving architectural decisions undocumented — if it's not written down, it's a rumor.
- Using "should", "consider", "try" — use "MUST", "WILL", "EXECUTE".
- Over-architecting simple tasks — YAGNI applies.
- Skipping documentation — the next developer needs to understand WHY, not just WHAT.
