#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Install Codex skills from this repository.

Usage:
  ./scripts/install.sh [--skills-dir PATH] [--dry-run] [--list]

Defaults:
  skills dir = ${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}

Examples:
  ./scripts/install.sh
  ./scripts/install.sh --skills-dir "$HOME/.codex/skills"
  CODEX_SKILLS_DIR="$HOME/.codex/skills" ./scripts/install.sh
USAGE
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
source_dir="$repo_root/skills"
skills_dir="${CODEX_SKILLS_DIR:-${CODEX_HOME:-$HOME/.codex}/skills}"
dry_run=0
list_only=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skills-dir)
      [[ $# -ge 2 ]] || { echo "ERROR: --skills-dir requires a path" >&2; exit 2; }
      skills_dir="$2"
      shift 2
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
  find "$source_dir" -mindepth 1 -maxdepth 1 -type d | sort | while IFS= read -r skill; do
    basename "$skill"
  done
  exit 0
fi

echo "Installing $skill_count skill(s) into: $skills_dir"

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

echo "Done. Restart Codex or start a new session so newly installed skills are discovered."
