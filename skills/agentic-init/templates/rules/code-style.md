# Code Style

- TypeScript strict mode. No `any` — use `unknown` + type narrowing.
- Named exports only. No default exports (except pages/layouts if framework requires it).
- Imports: external packages first, then internal aliases, then relative paths. Blank line between groups.
- Prefer `const` over `let`. Never use `var`.
- Use early returns to reduce nesting.
- Functions: explicit return types on exported functions. Inferred types are fine for internal/private functions.
- Naming: `camelCase` for variables/functions, `PascalCase` for types/components, `SCREAMING_SNAKE_CASE` for constants.
- No magic numbers — extract to named constants.
- Keep files under 300 lines. If larger, split into focused modules.
- No `console.log` in committed code. Use proper logging if the project has a logger.
