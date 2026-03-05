# agentic-init

Claude Code plugin that scaffolds the full `.claude/` agentic engineering stack for TypeScript/monorepo projects.

Defense-in-depth: CLAUDE.md, path-scoped rules, specialist agents, lifecycle hooks, and scoped permissions.

## Install

```bash
# From the Claude Code CLI
/plugin install path/to/agentic-init-plugin

# Or test locally
claude --plugin-dir ./agentic-init-plugin
```

## Usage

```bash
/agentic-init
```

The plugin analyzes your codebase and generates a complete `.claude/` directory tailored to your project.

## What It Generates

### CLAUDE.md
Project constitution (~80-100 lines). Commands, workflow, key rules. Acts as a router to detailed context — not a novel.

### .claude/rules/
Path-scoped instructions that load only when Claude touches matching files:
- **code-style.md** — TypeScript strict, naming, imports (always loaded)
- **git-conventions.md** — conventional commits, PR workflow (always loaded)
- **testing.md** — test runner, assertion rules (loaded for test files)
- **security.md** — OWASP, input validation, no secrets (always loaded)
- **frontend/react-patterns.md** — framework-specific patterns (loaded for frontend files)
- **backend/api-design.md** — API design, DB access layer (loaded for backend files)

### .claude/agents/
Specialist subagents with isolated context and scoped tools:
- **architect.md** — read-only planner, produces ADRs
- **implementer.md** — TDD workflow: tests first → implement → verify
- **reviewer.md** — adversarial reviewer with zero prior context
- **debugger.md** — systematic root-cause debugging
- **docs.md** — documentation updater

### .claude/hooks/
Shell scripts at lifecycle events. Exit 2 = blocked, no negotiation:
- **pre-bash-firewall.sh** — blocks dangerous commands, enforces package manager
- **protect-files.sh** — blocks edits to .env, lock files, node_modules
- **auto-format.sh** — runs formatter after every edit

### .claude/settings.json
Permissions allowlist + hook wiring. Generous permissions for safe operations, hooks catch the dangerous ones.

## How It Works

**Phase 1: Analyze** — A read-only `codebase-analyzer` agent explores your project and produces a structured profile: package manager, monorepo structure, framework, test runner, formatter, linter, database layer, git conventions, file patterns.

**Phase 2: Generate** — The `/agentic-init` skill reads the profile and adapts template files to your project. Every placeholder is replaced with detected values. Conditionals handle monorepo vs single-project, Next.js vs other frameworks, etc.

## What It Detects

| Category | Detects |
|---|---|
| Package manager | pnpm, bun, yarn, npm (from lock files) |
| Monorepo | Workspaces, workspace types (frontend/backend/library) |
| Framework | Next.js, Remix, Astro, Express, Fastify, Hono, tRPC |
| Test runner | Vitest, Jest, Bun test, Playwright, Cypress |
| Formatter | Prettier, Biome |
| Linter | ESLint, Biome, oxlint |
| Database | Drizzle, Prisma, TypeORM, Knex |
| Git | Commit style, protected branches, CI config |

## Workflow Integration

This plugin generates the guardrails layer. For spec-driven workflow (plan → implement → review), use [OpenSpec](https://github.com/Fission-AI/openspec).

## Customization

After generation, review and customize:
1. Edit `CLAUDE.md` to add project-specific rules
2. Adjust path globs in rules to match your directory structure
3. Add/remove agent capabilities as needed
4. Tune hook scripts for your team's conventions
5. Modify `settings.json` permissions for your tooling

## License

MIT
