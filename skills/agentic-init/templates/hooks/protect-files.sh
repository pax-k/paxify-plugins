#!/bin/bash
# Protect Files — blocks edits to sensitive files.
# Triggered by PreToolUse hook on Edit/Write/MultiEdit tool calls.
# Exit 2 = BLOCKED. No negotiation.
#
# Placeholder: {{lock_file}} — replaced by detected lock file (pnpm-lock.yaml, bun.lockb, etc.)
# Placeholder: {{package_manager}} — replaced by detected package manager (pnpm/bun/yarn/npm)

set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Normalize to relative path for matching
FILE_PATH_REL="${FILE_PATH#$PWD/}"

# --- Block .env files ---
if echo "$FILE_PATH_REL" | grep -qE '(^|/)\.env(\.|$)'; then
  echo "BLOCKED: Cannot edit .env files — they contain secrets." >&2
  exit 2
fi

# --- Block .git directory ---
if echo "$FILE_PATH_REL" | grep -qE '(^|/)\.git/'; then
  echo "BLOCKED: Cannot edit files inside .git/ directory." >&2
  exit 2
fi

# --- Block lock file ---
if echo "$FILE_PATH_REL" | grep -qE '(^|/){{lock_file}}$'; then
  echo "BLOCKED: Cannot edit {{lock_file}} — use {{package_manager}} to manage dependencies." >&2
  exit 2
fi

# --- Block node_modules ---
if echo "$FILE_PATH_REL" | grep -qE '(^|/)node_modules/'; then
  echo "BLOCKED: Cannot edit files inside node_modules/." >&2
  exit 2
fi

# --- Block dist/build output ---
if echo "$FILE_PATH_REL" | grep -qE '(^|/)(dist|build|\.next|\.output)/'; then
  echo "BLOCKED: Cannot edit build output files. Edit source files instead." >&2
  exit 2
fi

exit 0
