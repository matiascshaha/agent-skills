# agent-resources

Shared agent resources for general workflows and context I want to reuse across
repos and share with other people. Skills use the `SKILL.md` directory format
and can be installed for Codex or Claude Code. Context docs are plain Markdown
files that routers can load when the task matches.

This repository is a home for reusable skills and shared context docs.
`agents-md-builder` is one skill inside the collection, not the repo's whole
identity.

## Install

```bash
git clone https://github.com/matiascshaha/agent-resources.git
cd agent-resources
./scripts/install.sh --target codex
```

Install for Claude Code:

```bash
./scripts/install.sh --target claude
```

Install for both:

```bash
./scripts/install.sh --target both
```

Default destinations:

```text
Codex skills:   ~/.codex/skills
Claude skills:  ~/.claude/skills
Shared context: ~/.agent-resources/context
```

Override the destination when needed:

```bash
./scripts/install.sh --target codex --skills-dir "$HOME/.codex/skills"
./scripts/install.sh --target claude --skills-dir "$HOME/.claude/skills"
```

## Use

Start a new Codex or Claude Code session after installing, then ask for a skill
by name:

```text
Use agents-md-builder to create an AGENTS.md router for this repo.
```

The skill is intentionally conservative. It should not add routes to docs,
skills, scripts, or runbooks it has not inspected.

## What Gets Installed

The installer copies every skill under `skills/` into the selected agent's
skills directory. It also copies Markdown files under `context/` into the shared
context directory.

```text
context/
  agentic-engineering-taste.md
skills/
  agents-md-builder/
    SKILL.md
    agents/openai.yaml
    references/router-quality-bar.md
```

## Design Notes

- The repo is a general agent resources collection. Add new reusable skills under
  `skills/<skill-name>/` and reusable router-loadable context under `context/`.
- Keep each skill self-contained: `SKILL.md`, optional `references/`, optional
  `scripts/`, optional `assets/`, and optional `agents/openai.yaml`.
- Keep context docs as plain Markdown. They are loaded by router rules; they are
  not workflows and do not need `SKILL.md`.
- Keep private repo details, tokens, local secrets, and machine-specific paths
  out of public skills.
- Agent harness infrastructure should be judged against the taste bar in
  `context/agentic-engineering-taste.md`.
- `AGENTS.md` should be a router, not the whole rulebook.
- Route tables should point to trusted docs, skills, scripts, and runbooks.
- Weak or missing route targets should be listed as improvement candidates, not
  promoted into the router.
- The skill asks questions only when a real decision changes behavior, risk, or
  long-term maintenance.
