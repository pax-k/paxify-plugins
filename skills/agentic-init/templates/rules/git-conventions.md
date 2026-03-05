# Git Conventions

- **Conventional commits**: `type(scope): description` — types: feat, fix, refactor, test, docs, chore, ci.
- Scope is optional but recommended for monorepos (e.g., `feat(web): add dark mode`).
- Commit messages: imperative mood, lowercase, no period at end. Max 72 chars for subject line.
- **PRs only** — never push directly to {{protected_branch}}. Create a feature branch and open a PR.
- Branch naming: `type/short-description` (e.g., `feat/dark-mode`, `fix/login-redirect`).
- One logical change per commit. Don't mix refactoring with features.
- Run `{{verify_command}}` before every commit. Do not commit if verification fails.
- Never use `--no-verify` to skip pre-commit hooks.
- Never force push to shared branches.
