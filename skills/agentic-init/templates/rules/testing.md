---
paths:
  - "**/*.test.{ts,tsx}"
  - "**/*.spec.{ts,tsx}"
  - "**/__tests__/**"
---
# Testing Rules

- Use {{test_runner}} for all tests. Do NOT use other test runners.
- **NEVER modify test assertions to make them pass.** Fix the implementation instead.
- **NEVER delete or skip tests** to make the suite pass.
- Tests must be deterministic — no reliance on timing, network, or external state.
- Test file naming: colocate `*.test.ts` next to the source file, or mirror in `__tests__/`.
- Each test should test ONE behavior. Name it: `should [expected behavior] when [condition]`.
- Prefer real implementations over mocks. Never mock the database — use test fixtures or seeds.
- Test the public API, not internal implementation details.
- Every bug fix must include a regression test that fails without the fix.
