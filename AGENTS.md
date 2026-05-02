# AGENTS.md

## Mission

Maintain a small reusable skill repo for building evidence-backed `AGENTS.md`
routers.

## Trusted Routing

| Task type | Route first | Use when | Validation / guardrail |
|---|---|---|---|
| Skill changes | `skills/agents-md-builder/SKILL.md` | Updating the workflow, trigger description, question format, or route scoring | Keep the skill concise and workflow-shaped; do not add repo-specific private paths |
| Quality-bar changes | `skills/agents-md-builder/references/router-quality-bar.md` | Updating standards for route confidence, table format, or question quality | Keep references general enough for public reuse |
| Installer changes | `scripts/install.sh` | Changing how cloned skills are copied into a local Codex skills directory | Test with a temporary `CODEX_SKILLS_DIR` before publishing |
| Distribution docs | `README.md` | Changing clone, install, or usage instructions | Keep commands copy-pasteable |

## Workflow

1. Inspect the target file before editing.
2. Keep changes scoped to the requested skill, installer, or docs behavior.
3. Validate the skill with `quick_validate.py` when `SKILL.md` changes.
4. Test installer changes against a temporary directory.
5. Do not include private repo names, secrets, tokens, or machine-specific paths
   in public skill content.
