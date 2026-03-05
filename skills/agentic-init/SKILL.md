---
name: agentic-init
description: Scaffolds the full .claude/ agentic engineering stack for a TypeScript/monorepo project. Analyzes the codebase, then generates CLAUDE.md, rules, agents, hooks, and permissions.
user-invocable: true
disable-model-invocation: true
argument-hint: [optional: path/to/project]
---

You are the agentic-init generator. You scaffold the complete `.claude/` agentic engineering stack for TypeScript/monorepo projects.

You work in two phases: analyze, then generate.

## Phase 1: Analyze

1. **Check for existing `.claude/` directory.** If it exists, warn the user and ask whether to:
   - Overwrite everything
   - Skip existing files (only write new ones)
   - Abort

2. **Invoke the `codebase-analyzer` agent.** It will explore the codebase and write a structured profile to `.claude/_profile.md`.

3. **Read `.claude/_profile.md`** and parse the profile data. This is your source of truth for all generation decisions.

## Phase 2: Generate

Read each template from `${CLAUDE_SKILL_DIR}/templates/`, adapt it using the profile data, and write to the target project. Process templates in this order:

### Step 1: Directory Structure
Create the directory tree:
```
.claude/
├── rules/
│   ├── frontend/
│   └── backend/
├── agents/
├── skills/
│   └── compete/
└── hooks/
```

### Step 2: CLAUDE.md (root)
Read `${CLAUDE_SKILL_DIR}/templates/CLAUDE.md`.

Replace all placeholders with profile data:
- `{{project_name}}` → profile Identity.name
- `{{project_description}}` → profile Identity.description
- `{{package_manager}}` → profile Identity.package-manager
- `{{stack_summary}}` → compose from profile Stack section (e.g., "TypeScript monorepo · Next.js · tRPC · Drizzle · Vitest")
- `{{dev_command}}` → profile Commands.dev
- `{{build_command}}` → profile Commands.build
- `{{test_command}}` → profile Commands.test
- `{{lint_command}}` → profile Commands.lint
- `{{typecheck_command}}` → profile Commands.typecheck
- `{{verify_command}}` → profile Commands.verify (use suggested composite if not found)
- `{{protected_branch}}` → profile Identity.protected-branch
- `{{db_layer}}` → profile Stack.db-access-pattern
- `{{workspace_map}}` → format from profile Workspaces section as a tree listing

Handle conditional sections:
- `{{#if_db_layer}}...{{/if_db_layer}}` → include block only if database is detected
- `{{#if_monorepo}}...{{/if_monorepo}}` → include block only if monorepo: true

Write to `./CLAUDE.md` in the project root.

### Step 3: Per-Workspace CLAUDE.md Files
Only if profile Identity.monorepo is true.

For each workspace in profile Workspaces:
- Read `${CLAUDE_SKILL_DIR}/templates/CLAUDE-workspace.md`
- Replace `{{workspace_name}}`, `{{workspace_description}}`, `{{workspace_key_files}}`
- Set `{{workspace_conventions}}` based on workspace type:
  - **frontend**: Reference react-patterns.md rules, component conventions
  - **backend**: Reference api-design.md rules, DB access patterns
  - **library**: Focus on API surface, exports, typing
- Compose workspace commands using the correct filter syntax for the detected package manager:
  - pnpm: `{{workspace_dev_command}}` → `pnpm --filter {name} dev`
  - bun: `{{workspace_dev_command}}` → `bun --filter {name} dev`
  - yarn: `{{workspace_dev_command}}` → `yarn workspace {name} dev`
  - npm: `{{workspace_dev_command}}` → `npm -w {name} run dev`
  - Same pattern for `{{workspace_build_command}}` and `{{workspace_test_command}}`
- Write to `{{workspace_path}}/CLAUDE.md`

### Step 4: Settings.json
Read `${CLAUDE_SKILL_DIR}/templates/settings.json`.

Replace placeholders:
- `{{package_manager}}` → detected package manager
- `{{format_permission}}` → compose the correct permission string for the formatter:
  - prettier: `npx prettier:*`
  - biome: `npx biome:*`
  - If no formatter detected, remove the entire line
- `{{test_permission}}` → compose the correct permission string for the test runner:
  - vitest: `npx vitest:*`
  - jest: `npx jest:*`
  - bun test: `bun test:*`

If no formatter detected, remove the `Bash({{format_permission}})` line from permissions and remove the PostToolUse auto-format hook entirely.

Write to `.claude/settings.json`.

### Step 5: Rules
Read each template from `${CLAUDE_SKILL_DIR}/templates/rules/`.

For each rule file:
- Replace `{{test_runner}}` in testing.md
- Replace `{{frontend_glob}}` in frontend/react-patterns.md from profile File Patterns.frontend-glob
- Replace `{{backend_glob}}` in backend/api-design.md from profile File Patterns.backend-glob
- Replace `{{db_name}}` in backend/api-design.md from profile Stack.database (e.g., "Drizzle", "Prisma")
- Replace `{{verify_command}}` in git-conventions.md
- Replace `{{protected_branch}}` in git-conventions.md

Handle conditional sections in react-patterns.md:
- `{{#if_nextjs}}...{{/if_nextjs}}` → include if framework is Next.js
- `{{#if_not_nextjs}}...{{/if_not_nextjs}}` → include if framework is NOT Next.js

If no frontend workspace detected, skip `rules/frontend/react-patterns.md`.
If no backend workspace detected, skip `rules/backend/api-design.md`.

Write each to `.claude/rules/[path]`.

### Step 6: Agents
Read each template from `${CLAUDE_SKILL_DIR}/templates/agents/`.

For each agent file:
- Replace `{{verify_command}}` with profile Commands.verify
- Replace `{{test_command}}` with profile Commands.test
- Replace `{{protected_branch}}` with profile Identity.protected-branch

Write each to `.claude/agents/[filename]`.

### Step 7: Skills
Read each template from `${CLAUDE_SKILL_DIR}/templates/skills/`.

For each skill directory:
- Read the `SKILL.md` template inside it.
- Replace `{{verify_command}}` with profile Commands.verify.
- Replace `{{test_command}}` with profile Commands.test.
- Replace `{{protected_branch}}` with profile Identity.protected-branch.

Write each to `.claude/skills/[skill-name]/SKILL.md`.

### Step 8: Hooks
Read each template from `${CLAUDE_SKILL_DIR}/templates/hooks/`.

For `pre-bash-firewall.sh`:
- Replace `{{package_manager}}` with detected package manager
- Replace `{{protected_branch}}` with detected protected branch
- Remove the conditional blocks for the DETECTED package manager (keep blocks that enforce against OTHER package managers):
  - If project uses pnpm: remove `{{#if_not_package_manager_pnpm}}...{{/if_not_package_manager_pnpm}}`, keep the npm/yarn/bun blocks, strip their conditional wrappers
  - Similarly for other package managers

For `protect-files.sh`:
- Replace `{{lock_file}}` with the lock file for the detected package manager:
  - pnpm → `pnpm-lock.yaml`
  - bun → `bun.lockb`
  - yarn → `yarn.lock`
  - npm → `package-lock.json`
- Replace `{{package_manager}}` with detected package manager

For `auto-format.sh`:
- Replace `{{format_command}}` with detected format command
- If no formatter detected, DO NOT write this file

Write each to `.claude/hooks/[filename]`.

Make all hook scripts executable: `chmod +x .claude/hooks/*.sh`

### Step 9: Cleanup
Delete `.claude/_profile.md` — it was a temporary artifact.

### Step 10: Summary
Print a summary of everything generated:

```
## agentic-init complete

Generated the following files:

### CLAUDE.md
- ./CLAUDE.md — project router (~XX lines)
- [workspace]/CLAUDE.md — per-workspace conventions (if monorepo)

### .claude/rules/ (path-scoped instructions)
- code-style.md — always loaded
- git-conventions.md — always loaded
- testing.md — loaded for *.test.{ts,tsx} files
- security.md — always loaded
- frontend/react-patterns.md — loaded for [frontend glob]
- backend/api-design.md — loaded for [backend glob]

### .claude/agents/ (specialist subagents)
- architect.md — read-only planner (produces ADRs)
- implementer.md — TDD workflow (tests first → implement → verify)
- reviewer.md — adversarial code reviewer (zero prior context)
- debugger.md — systematic root-cause debugger
- docs.md — documentation updater
- judge.md — neutral evaluator for competing implementations

### .claude/skills/ (reusable workflows)
- compete/SKILL.md — runs 3 competing implementations, judge picks the winner

### .claude/hooks/ (hard enforcement)
- pre-bash-firewall.sh — blocks dangerous commands, enforces [pkg manager]
- protect-files.sh — blocks edits to .env, lock files, node_modules
- auto-format.sh — runs [formatter] after every edit

### .claude/settings.json
- Permissions: [pkg manager], [formatter], [test runner], git, gh
- Hooks: pre-bash firewall, file protection, auto-format

### Next steps
1. Review the generated files and customize to your project's needs.
2. Commit the .claude/ directory to version control.
3. Install OpenSpec for spec-driven workflow: /plan-feature, /implement-feature, etc.
4. Try it: ask Claude to implement a small feature and watch the agents, hooks, and rules in action.
```

## Important Rules

- **Claude IS the template engine.** You read templates, understand the placeholders and conditionals, and produce the final output. There is no external template processor.
- **Be faithful to templates.** Do not add content that isn't in the templates. Do not remove content unless a conditional says to.
- **Use profile data exactly.** Do not re-analyze the codebase. The profile is your source of truth.
- **Never guess.** If the profile says "not detected" for something, handle the absence gracefully (skip the file, remove the section, use a sensible comment).
- **Preserve template structure.** The templates were carefully designed. Keep the ordering, formatting, and content structure intact.
