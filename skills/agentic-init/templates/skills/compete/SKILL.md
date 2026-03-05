---
name: compete
description: Runs 3 competing implementations of a feature using different strategies, then picks the best one. Swiss cheese layer 1 — diversity of approaches.
user-invocable: true
argument-hint: <spec-file-path or feature description>
---

You orchestrate a **competition** between 3 independent implementation attempts. Each uses a different strategy. A neutral judge picks the winner. The loser branches are deleted.

Read the spec or feature description from: $ARGUMENTS

## Phase 1: Setup

1. Read and understand the spec / acceptance criteria.
2. Identify the current branch. Store it as `BASE_BRANCH`.
3. Create 3 competition branches from `BASE_BRANCH`:
   - `compete/minimal` — Strategy A
   - `compete/thorough` — Strategy B
   - `compete/creative` — Strategy C

## Phase 2: Implement (3 rounds)

For EACH strategy below, checkout the corresponding branch and use the **implementer** agent to execute. Pass the strategy directive along with the original spec.

### Strategy A: Minimal (`compete/minimal`)
> Implement the spec with the **fewest lines of code possible**. Prefer reusing existing utilities, composing existing functions, and leveraging framework conventions. No new abstractions. No new files if avoidable. The best code is code you didn't write.

### Strategy B: Thorough (`compete/thorough`)
> Implement the spec with **comprehensive edge case handling from the start**. Validate all inputs. Handle every error path. Add more tests than the spec requires — boundary values, empty inputs, malformed data, concurrent access if applicable. Prefer robustness over brevity.

### Strategy C: Creative (`compete/creative`)
> Implement the spec using an **unconventional approach**. Look for a different data structure, a different algorithm, a different decomposition than the obvious one. Challenge assumptions in the spec if they constrain a better solution. The goal is a fresh perspective — not cleverness for its own sake.

After each implementation, return to `BASE_BRANCH` before starting the next.

## Phase 3: Judge

1. Return to `BASE_BRANCH`.
2. Use the **judge** agent to evaluate all 3 branches.
3. The judge runs `{{verify_command}}` on each, eliminates failures, and scores the survivors.

## Phase 4: Merge the Winner

1. Merge the winning branch into `BASE_BRANCH`: `git merge {winning-branch}`
2. Delete all 3 competition branches:
   ```
   git branch -D compete/minimal
   git branch -D compete/thorough
   git branch -D compete/creative
   ```
3. Run `{{verify_command}}` one final time on the merged result.

## Phase 5: Report

Print a summary:
```
## Competition Complete

Winner: [strategy name] (compete/[branch])
Score: [X/25]

### Why it won
[Judge's reasoning]

### Cherry-picked from runners-up
- [Any improvements merged from other branches, or "None"]

### Final verification
[pass/fail]
```

## Rules

- Each strategy gets **one shot**. No retries, no "let me try a different approach."
- Strategies must be **independent**. Do not let one implementation influence another.
- The judge's verdict is **final**. Do not override it.
- If all 3 fail verification, STOP and report. Do not attempt a 4th strategy.
- Clean up ALL competition branches when done, regardless of outcome.
