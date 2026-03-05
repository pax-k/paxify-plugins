#!/bin/bash
# Pre-Bash Firewall — blocks dangerous shell commands before execution.
# Triggered by PreToolUse hook on Bash tool calls.
# Exit 2 = BLOCKED. No negotiation.
#
# Placeholder: {{package_manager}} — replaced by detected package manager (pnpm/bun/yarn/npm)
# Placeholder: {{protected_branch}} — replaced by detected protected branch (main/master)

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

if [ -z "$COMMAND" ]; then
  exit 0
fi

# --- Block destructive rm commands ---
if echo "$COMMAND" | grep -qE 'rm\s+(-[a-zA-Z]*[rf][a-zA-Z]*\s+)*(\/|~\/|\.\.|\.(\s|$)|\*(\s|$))'; then
  echo "BLOCKED: Destructive rm command targeting broad path" >&2
  exit 2
fi

# --- Enforce correct package manager ---
# Block npm/yarn/pnpm when project uses a different one
{{#if_not_package_manager_npm}}
if echo "$COMMAND" | grep -qE '(^|&&|;|\|)\s*npm\s+(install|i|ci|run|exec|init|create)\b'; then
  echo "BLOCKED: Use {{package_manager}} instead of npm" >&2
  exit 2
fi
{{/if_not_package_manager_npm}}

{{#if_not_package_manager_yarn}}
if echo "$COMMAND" | grep -qE '(^|&&|;|\|)\s*yarn\s+(install|add|remove|run|create)\b'; then
  echo "BLOCKED: Use {{package_manager}} instead of yarn" >&2
  exit 2
fi
{{/if_not_package_manager_yarn}}

{{#if_not_package_manager_pnpm}}
if echo "$COMMAND" | grep -qE '(^|&&|;|\|)\s*pnpm\s+(install|add|remove|run|create)\b'; then
  echo "BLOCKED: Use {{package_manager}} instead of pnpm" >&2
  exit 2
fi
{{/if_not_package_manager_pnpm}}

{{#if_not_package_manager_bun}}
if echo "$COMMAND" | grep -qE '(^|&&|;|\|)\s*bun\s+(install|add|remove|run|create)\b'; then
  echo "BLOCKED: Use {{package_manager}} instead of bun" >&2
  exit 2
fi
{{/if_not_package_manager_bun}}

# --- Block direct commits/pushes to protected branch ---
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*\b{{protected_branch}}\b'; then
  echo "BLOCKED: Do not push directly to {{protected_branch}}. Create a PR instead." >&2
  exit 2
fi

# --- Block force pushes ---
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*(-f|--force)\b'; then
  echo "BLOCKED: Force push is not allowed. Use --force-with-lease if absolutely necessary." >&2
  exit 2
fi

# --- Block reading .env files ---
if echo "$COMMAND" | grep -qE '(cat|less|more|head|tail|bat|source|grep|vim|vi|nano)\s+.*\.env\b'; then
  echo "BLOCKED: Do not access .env files — they may contain secrets." >&2
  exit 2
fi

# --- Block git reset --hard ---
if echo "$COMMAND" | grep -qE 'git\s+reset\s+--hard'; then
  echo "BLOCKED: git reset --hard is destructive. Use a safer alternative." >&2
  exit 2
fi

exit 0
