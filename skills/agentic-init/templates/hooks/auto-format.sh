#!/bin/bash
# Auto-Format — runs formatter after every file edit.
# Triggered by PostToolUse hook on Edit/Write/MultiEdit tool calls.
# Always exits 0 — formatting failure should not block the edit.
#
# Placeholder: {{format_command}} — replaced by detected format command (e.g., "npx prettier --write", "npx biome format --write")


set -euo pipefail
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Only format files that exist and are text-like source files
if [ ! -f "$FILE_PATH" ]; then
  exit 0
fi

# Only format known source file extensions
if echo "$FILE_PATH" | grep -qE '\.(ts|tsx|js|jsx|json|css|scss|html|md|yaml|yml)$'; then
  {{format_command}} "$FILE_PATH" 2>/dev/null || true
fi

exit 0
