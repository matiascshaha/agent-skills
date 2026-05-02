# Router Quality Bar

## Current Source Signals

- OpenAI Codex uses `AGENTS.md` as layered project guidance. Global guidance
  lives in Codex home, project guidance layers from repo root to current working
  directory, and closer files override earlier guidance because they appear later.
- Codex skills are reusable workflow packages with `SKILL.md`, optional
  `references/`, optional `scripts/`, and optional `assets/`. The description is
  the trigger surface, so it must say exactly when to use the skill.
- Anthropic's skill guidance emphasizes concise instructions, progressive
  disclosure, concrete workflows, validation loops, and tested real usage.
- Claude Code reads `CLAUDE.md`, not `AGENTS.md`; if a repo wants one shared
  source, `CLAUDE.md` can import `AGENTS.md`.
- Gstack-style workflows are useful because they route by task, ask real
  decisions, and avoid ad-hoc answers when a better workflow exists.

## Router Principles

1. A router is not a style guide. It points to style guides.
2. A route is trusted only when the target exists and has a clear task boundary.
3. Tables beat prose for routing because agents can scan trigger, target, and
   guardrail together.
4. Weak routes should be listed as improvement candidates, not promoted into the
   router.
5. Prefer exact commands and paths over abstract advice.
6. Keep risk rules close to the router: secrets, deploys, live writes, public
   contracts, merge conflicts, and destructive commands.
7. Make gaps explicit. Do not fill them with generic best-practice language.

## Recommended Route Table

| Task type | Route first | Use when | Validation / guardrail |
|---|---|---|---|
| `<domain task>` | `<skill/doc/script path>` | `<clear trigger>` | `<command or stop rule>` |

Use "Route first" rather than "Read" so the table can point to skills, docs,
scripts, or issue templates without changing column meaning.

## Route Rejection Tests

Reject or defer a route when:

- The file does not exist.
- The skill description is vague.
- The workflow says what to value but not what to do.
- The route target duplicates another route with no boundary.
- The command is time-sensitive and was not verified.
- The route requires private credentials or production access without a stop rule.

## Question Quality Bar

Ask the user only for decisions that affect behavior, risk, or long-term
maintenance. Good questions include a recommendation and concrete tradeoffs.

Bad question: "Should I add more routes?"

Good question: "Should deploy routing point only to `docs/runbook.md`, or should
it also route to a repo-local deploy skill after we create one?"
