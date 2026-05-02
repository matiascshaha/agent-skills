---
name: agents-md-builder
description: Builds or improves AGENTS.md project instruction files for coding agents. Use when the user asks to create, review, refactor, or standardize AGENTS.md, agent rulebooks, repo instruction routers, skill routing tables, or reusable AGENTS.md guidance for one or more repositories.
---

# Agents.md Builder

## Purpose

Create a small, evidence-backed project router. Do not write a giant rulebook.
Route only to docs, skills, scripts, and workflows that exist and are good
enough to trust.

Read `references/router-quality-bar.md` before making recommendations or edits.

## Workflow

Track progress explicitly:

```text
Router Build
- [ ] Discover instruction files
- [ ] Inventory trusted route targets
- [ ] Score route confidence
- [ ] Ask for missing decisions
- [ ] Patch router
- [ ] Validate and report
```

### 1. Discover Instructions

Find existing instruction files and docs:

```bash
pwd
find .. -name AGENTS.md -o -name AGENTS.override.md -o -name CLAUDE.md -o -name '*.md' | sed -n '1,200p'
find . -path '*/.agents/skills/*/SKILL.md' -o -path '*/.claude/skills/*/SKILL.md' | sort
```

Prefer `rg --files` when available. Keep the scan bounded; do not read every doc.

Read:

1. Current `AGENTS.md` or `CLAUDE.md`
2. Top-level README and docs index files
3. Candidate skill `SKILL.md` files
4. Build/test/deploy runbooks
5. Architecture or conventions docs that route other docs

### 2. Inventory Route Targets

For each possible route, collect evidence:

| Candidate route | Evidence needed |
|---|---|
| Skill | `SKILL.md` exists, description has clear trigger, workflow has concrete steps, validation is named |
| Runbook | File exists, commands are current enough, task boundary is clear |
| Conventions doc | File exists, contains actionable rules, not generic taste only |
| Script | File exists, purpose is clear, invocation is documented |
| System context index | File exists, gives task-specific reading order |

Do not add routes for aspirational docs, vague skills, stale notes, or files you
have not inspected.

### 3. Score Confidence

Score each route before adding it:

| Score | Meaning | Action |
|---|---|---|
| 3 | Strong route: exists, specific trigger, concrete workflow, validation path | Add to router |
| 2 | Usable route: exists and helpful, but validation or trigger is incomplete | Add only if labeled carefully |
| 1 | Weak route: generic, stale, or ambiguous | Do not route yet; list as improvement candidate |
| 0 | Missing target | Do not route |

If fewer than three strong/usable routes exist, build a minimal router anyway.
Small and honest beats comprehensive and fake.

### 4. Ask For Decisions

Ask only when there is a real decision. Use this format:

```markdown
**Decision Needed**
Repo: `<repo path>`
Current target: `<AGENTS.md or CLAUDE.md path>`

The question: <plain-language question>

RECOMMENDATION: Choose <A/B/C> because <one concrete reason>.

| Option | What changes | Tradeoff |
|---|---|---|
| A | <specific action> | <cost/risk> |
| B | <specific action> | <cost/risk> |
| C | Defer | <what remains unresolved> |
```

Do not ask when the safe answer is obvious, such as converting an existing route
list to a table with the same content.

### 5. Patch Router

Prefer this AGENTS.md structure:

```markdown
# AGENTS.md

## Mission

<one sentence>

## Context First

<short reading order for non-trivial work>

## Trusted Routing

| Task type | Route first | Use when | Validation / guardrail |
|---|---|---|---|
| ... | ... | ... | ... |

## Workflow

<5-7 non-negotiable steps>

## Guardrails

<risk-specific stop signs>
```

Rules:

- Keep the router under 120 lines unless the repo has a proven need.
- Use tables for routing.
- Keep generic coding taste out unless tied to a repo doc or repeated failure.
- Link to maintained docs instead of duplicating them.
- Include exact commands for default validation.
- Include "stop and ask" rules for secrets, production writes, public contracts,
  conflicts, destructive commands, and unclear ownership.
- If the repo uses Claude Code, prefer a tiny `CLAUDE.md` that imports `AGENTS.md`
  with `@AGENTS.md`, then adds Claude-only instructions.

### 6. Validate

Run lightweight validation:

```bash
test -f AGENTS.md && sed -n '1,180p' AGENTS.md
```

If the repo has markdown linting, run it. Do not run the full test suite for a
docs-only router edit unless the repo requires it.

Report:

- Routes added or changed
- Routes deliberately not added
- Evidence files inspected
- Validation run
- Open questions

## GitHub Sharing Guidance

For personal reuse, a user-level skill folder is enough.

For sharing across machines or with other developers:

1. Put the skill folder in a GitHub repo after it has been used successfully on
   at least two different repositories.
2. Keep `SKILL.md`, `references/`, and optional `agents/openai.yaml`; do not add
   extra README-style clutter unless the repository itself needs installation docs.
3. Treat third-party skills as executable instructions. Keep the public version
   conservative and avoid secrets, machine-local paths, and private repo names.
4. For Codex distribution beyond a local folder, package the skill as a plugin
   once there are multiple skills or app/tool integrations to ship together.
