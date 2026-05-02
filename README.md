# agents-md-builder

Reusable Codex skill for building evidence-backed `AGENTS.md` router files.

The skill helps an agent inspect a repository, identify only trustworthy route
targets, score route confidence, ask decision questions when needed, and patch a
small `AGENTS.md` instead of inventing a giant stale rulebook.

## Install

```bash
git clone https://github.com/matiascshaha/agents-md-builder.git
cd agents-md-builder
./scripts/install.sh
```

By default the installer copies skills into:

```text
~/.codex/skills
```

Override the destination when needed:

```bash
CODEX_SKILLS_DIR="$HOME/.codex/skills" ./scripts/install.sh
```

## Use

Start a new Codex session after installing, then ask for the skill by name:

```text
Use agents-md-builder to create an AGENTS.md router for this repo.
```

The skill is intentionally conservative. It should not add routes to docs,
skills, scripts, or runbooks it has not inspected.

## What Gets Installed

```text
skills/
  agents-md-builder/
    SKILL.md
    agents/openai.yaml
    references/router-quality-bar.md
```

## Design Notes

- `AGENTS.md` should be a router, not the whole rulebook.
- Route tables should point to trusted docs, skills, scripts, and runbooks.
- Weak or missing route targets should be listed as improvement candidates, not
  promoted into the router.
- The skill asks questions only when a real decision changes behavior, risk, or
  long-term maintenance.
