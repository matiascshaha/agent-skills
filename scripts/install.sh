#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install agent skills and shared context docs from this repository.

Usage:
  ./scripts/install.sh [--target codex|claude|both] [--skills-dir PATH] [--context-dir PATH] [--no-context] [--dry-run] [--list]

Defaults:
  target = codex
  Codex skills dir = ${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}
  Claude skills dir = ${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}
  Context dir = ${AGENT_CONTEXT_DIR:-$HOME/.agent-resources/context}

Examples:
  ./scripts/install.sh
  ./scripts/install.sh --target codex
  ./scripts/install.sh --target claude
  ./scripts/install.sh --target both
  ./scripts/install.sh --target claude --skills-dir "$HOME/.claude/skills"
  ./scripts/install.sh --context-dir "$HOME/.agent-resources/context"
USAGE
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
source_dir="$repo_root/skills"
context_source_dir="$repo_root/context"
target_host="codex"
custom_skills_dir=""
context_dir="${AGENT_CONTEXT_DIR:-$HOME/.agent-resources/context}"
install_context=1
dry_run=0
list_only=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      [[ $# -ge 2 ]] || { echo "ERROR: --target requires codex, claude, or both" >&2; exit 2; }
      case "$2" in
        codex|claude|both)
          target_host="$2"
          ;;
        *)
          echo "ERROR: --target must be codex, claude, or both" >&2
          exit 2
          ;;
      esac
      shift 2
      ;;
    --skills-dir)
      [[ $# -ge 2 ]] || { echo "ERROR: --skills-dir requires a path" >&2; exit 2; }
      custom_skills_dir="$2"
      shift 2
      ;;
    --context-dir)
      [[ $# -ge 2 ]] || { echo "ERROR: --context-dir requires a path" >&2; exit 2; }
      context_dir="$2"
      shift 2
      ;;
    --no-context)
      install_context=0
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --list)
      list_only=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [[ ! -d "$source_dir" ]]; then
  echo "ERROR: skills directory not found: $source_dir" >&2
  exit 1
fi

skill_count="$(find "$source_dir" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"

if [[ "$skill_count" -eq 0 ]]; then
  echo "ERROR: no skills found under $source_dir" >&2
  exit 1
fi

if [[ "$list_only" -eq 1 ]]; then
  echo "Skills:"
  find "$source_dir" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r skill; do
    echo "  $(basename "$skill")"
  done
  if [[ -d "$context_source_dir" ]]; then
    echo "Context:"
    find "$context_source_dir" -mindepth 1 -maxdepth 1 -type f -name '*.md' | sort | while IFS= read -r doc; do
      echo "  $(basename "$doc")"
    done
  fi
  exit 0
fi

install_to_dir() {
  local skills_dir="$1"
  local host_label="$2"

  echo "Installing $skill_count skill(s) for $host_label into: $skills_dir"

  if [[ "$dry_run" -eq 0 ]]; then
    mkdir -p "$skills_dir"
  fi

  find "$source_dir" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r skill; do
    name="$(basename "$skill")"
    target="$skills_dir/$name"
    tmp_target="${target}.tmp.$$"

    if [[ ! -f "$skill/SKILL.md" ]]; then
      echo "ERROR: missing SKILL.md for skill: $name" >&2
      exit 1
    fi

    if [[ -e "$target" && ! -d "$target" ]]; then
      echo "ERROR: target exists but is not a directory: $target" >&2
      exit 1
    fi

    if [[ "$dry_run" -eq 1 ]]; then
      echo "Would install $name -> $target"
      continue
    fi

    rm -rf "$tmp_target"
    mkdir -p "$tmp_target"
    cp -R "$skill"/. "$tmp_target"/
    rm -rf "$target"
    mv "$tmp_target" "$target"
    echo "Installed $name -> $target"
  done
}

install_context_docs() {
  if [[ "$install_context" -eq 0 ]]; then
    return
  fi

  if [[ ! -d "$context_source_dir" ]]; then
    return
  fi

  local doc_count
  doc_count="$(find "$context_source_dir" -mindepth 1 -maxdepth 1 -type f -name '*.md' | wc -l | tr -d ' ')"

  if [[ "$doc_count" -eq 0 ]]; then
    return
  fi

  echo "Installing $doc_count context doc(s) into: $context_dir"

  if [[ "$dry_run" -eq 0 ]]; then
    mkdir -p "$context_dir"
  fi

  find "$context_source_dir" -mindepth 1 -maxdepth 1 -type f -name '*.md' | sort | while IFS= read -r doc; do
    name="$(basename "$doc")"
    target="$context_dir/$name"

    if [[ "$dry_run" -eq 1 ]]; then
      echo "Would install context $name -> $target"
      continue
    fi

    cp "$doc" "$target"
    echo "Installed context $name -> $target"
  done
}

codex_dir="${custom_skills_dir:-${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}}"
claude_dir="${custom_skills_dir:-${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}}"

case "$target_host" in
  codex)
    install_to_dir "$codex_dir" "Codex"
    ;;
  claude)
    install_to_dir "$claude_dir" "Claude"
    ;;
  both)
    if [[ -n "$custom_skills_dir" ]]; then
      echo "ERROR: --skills-dir cannot be combined with --target both; use CODEX_SKILLS_DIR and CLAUDE_SKILLS_DIR instead" >&2
      exit 2
    fi
    install_to_dir "$codex_dir" "Codex"
    install_to_dir "$claude_dir" "Claude"
    ;;
esac

install_context_docs

echo "Done. Start a new session so newly installed skills are discovered."
