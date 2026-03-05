# {{project_name}}

{{project_description}}

## Stack
{{stack_summary}}

## Commands
- `{{dev_command}}` — start development server
- `{{build_command}}` — production build
- `{{test_command}}` — run tests
- `{{lint_command}}` — lint code
- `{{typecheck_command}}` — type check
- `{{verify_command}}` — run ALL checks (typecheck + lint + test). Run before EVERY commit.

## Workflow
1. **Plan before coding.** For non-trivial work, use the architect agent to produce an ADR. Review before implementing.
2. **TDD.** Write tests from acceptance criteria. Confirm they fail. Then implement. Never modify tests to pass — fix the implementation.
3. **Verify.** Run `{{verify_command}}` before every commit. Fix all issues.
4. **Conventional commits.** `type(scope): description`. One logical change per commit.
5. **PRs only.** Never push directly to {{protected_branch}}. Create a feature branch and open a PR.

## Key Rules
- TypeScript strict. No `any`. Named exports only.
{{#if_db_layer}}
- Database access ONLY through {{db_layer}}. Never write raw queries in route handlers.
{{/if_db_layer}}
- See `.claude/rules/` for detailed, path-scoped coding patterns.
- See `.claude/agents/` for specialist agents (architect, implementer, reviewer, debugger, docs).

{{#if_monorepo}}
## Structure
{{workspace_map}}

See per-workspace CLAUDE.md files for workspace-specific conventions.
{{/if_monorepo}}
