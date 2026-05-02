# AGENTS.md

## Mission

Maintain a small public collection of reusable agent skills that can be cloned
and installed into a user's global Codex or Claude Code skills directory.

## Trusted Routing

| Task type | Route first | Use when | Validation / guardrail |
|---|---|---|---|
| Agent harness infrastructure | `skills/agentic-engineering-taste/SKILL.md` | Working on AGENTS.md, CLAUDE.md, routing files, skills, eval harnesses, agent docs, or install workflows | Use this as the taste bar, then route to the specific skill/doc below |
| New skill | `skills/<skill-name>/SKILL.md` | Adding a reusable workflow to this collection | Keep each skill self-contained and validate with `quick_validate.py` |
| Agents.md builder skill changes | `skills/agents-md-builder/SKILL.md` | Updating the AGENTS.md workflow, trigger description, question format, or route scoring | Keep the skill concise and workflow-shaped; do not add repo-specific private paths |
| Quality-bar changes | `skills/agents-md-builder/references/router-quality-bar.md` | Updating standards for route confidence, table format, or question quality | Keep references general enough for public reuse |
| Installer changes | `scripts/install.sh` | Changing how cloned skills are copied into local Codex or Claude skills directories | Test Codex and Claude targets with temporary directories before publishing |
| Distribution docs | `README.md` | Changing clone, install, or usage instructions | Keep commands copy-pasteable |

## Workflow

1. Inspect the target file before editing.
2. Keep changes scoped to the requested skill, installer, or docs behavior.
3. Validate changed skills with `quick_validate.py` when `SKILL.md` changes.
4. Test installer changes against a temporary directory.
5. Do not include private repo names, secrets, tokens, or machine-specific paths
   in public skill content.
