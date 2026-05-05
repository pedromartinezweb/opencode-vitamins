#!/usr/bin/env bash
set -euo pipefail

REPO="${OPENCODE_VITAMINS_REPO:-pedromartinezweb/opencode-vitamins}"
REF="${OPENCODE_VITAMINS_REF:-main}"
TMP_DIR="$(mktemp -d)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

copy_file() {
  local source="$1"
  local target="$2"

  if [[ -e "$target" && "${FORCE:-0}" != "1" ]]; then
    echo "Skip existing $target"
    return
  fi

  mkdir -p "$(dirname "$target")"
  cp "$source" "$target"
  echo "Write $target"
}

need curl
need tar

if [[ -f "$SCRIPT_DIR/AGENTS.md" && -f "$SCRIPT_DIR/opencode.jsonc" ]]; then
  ROOT="$SCRIPT_DIR"
else
  ARCHIVE_URL="https://github.com/${REPO}/archive/refs/heads/${REF}.tar.gz"
  curl -fsSL "$ARCHIVE_URL" | tar -xz -C "$TMP_DIR"
  ROOT="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
fi

copy_file "$ROOT/AGENTS.md" "AGENTS.md"
copy_file "$ROOT/opencode.jsonc" "opencode.jsonc"
copy_file "$ROOT/docs/agents/workflow.md" "docs/agents/workflow.md"

if [[ -f "$ROOT/docs/tasks/example-task.md" ]]; then
  copy_file "$ROOT/docs/tasks/example-task.md" "docs/tasks/example-task.md"
fi

mkdir -p ".opencode/agents"
for agent in backend-coder frontend-coder lead planner reviewer tester; do
  copy_file "$ROOT/.opencode/agents/${agent}.md" ".opencode/agents/${agent}.md"
done

if [[ -f "$ROOT/.opencode/.gitignore" ]]; then
  if [[ ! -e ".opencode/.gitignore" || "${FORCE:-0}" == "1" ]]; then
    copy_file "$ROOT/.opencode/.gitignore" ".opencode/.gitignore"
  fi
elif [[ ! -e ".opencode/.gitignore" ]]; then
  printf '%s\n' "node_modules" "package.json" "package-lock.json" "bun.lock" ".gitignore" > ".opencode/.gitignore"
  echo "Write .opencode/.gitignore"
fi

touch ".gitignore"
for entry in ".DS_Store" "node_modules/" "dist/" "build/" ".next/" "coverage/"; do
  if ! grep -qxF "$entry" ".gitignore"; then
    printf '%s\n' "$entry" >> ".gitignore"
  fi
done

echo
echo "OpenCode Vitamins installed."
echo "Run: opencode"
