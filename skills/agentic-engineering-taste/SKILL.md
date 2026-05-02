---
name: agentic-engineering-taste
description: Taste bar for agent harness infrastructure. Use when designing, reviewing, or refactoring AGENTS.md, CLAUDE.md, routing files, agent docs, skill systems, eval harnesses, install scripts, workflow automation, or other infrastructure that shapes how coding agents work.
---

# Agentic Engineering Taste

## Use

Read this first when working on agent harness infrastructure, then continue with
the concrete task. This is not a substitute for implementation, validation, or
repo-specific evidence.

Applies to:

- `AGENTS.md` and `CLAUDE.md`
- routing tables and instruction hierarchies
- skills and skill collections
- eval harnesses and test corpora for agent behavior
- installer scripts and shared workflow tooling
- agent docs, runbooks, and workflow automation

## Taste Anchors

The quality bar should be informed by builders and teams who have shaped
practical agentic engineering:

- Garry Tan and the gstack workflow style
- Andrej Karpathy's emphasis on human-in-the-loop AI, readable systems, and
  building with the model as part of the loop
- Anthropic engineers working on Claude Code, Skills, tool use, and agent safety
- OpenAI engineers working on Codex, Skills, tool use, evals, and agentic coding

Do not cosplay their style. Use them as taste anchors for what "good" should
feel like: clear workflows, inspectable behavior, explicit boundaries, and
systems that help capable humans move faster without hiding the mechanism.

## Quality Bar

Good agent infrastructure is:

- A router before it is a rulebook.
- A workflow before it is a pile of advice.
- Specific about when to use each skill, doc, script, or harness.
- Honest about confidence and gaps.
- Small enough to inspect in one pass.
- Designed for progressive disclosure: metadata first, workflow second,
  references only when needed.
- Explicit about validation, failure modes, and stop signs.
- Portable enough to share without private paths, secrets, or project-only lore.

Bad agent infrastructure:

- Adds generic "best practices" instead of concrete routes.
- Hides decisions behind confident prose.
- Promotes weak docs or vague skills into trusted routes.
- Makes giant instruction files that agents skim and humans cannot maintain.
- Treats agent autonomy as a substitute for human judgment.
- Ships scripts that cannot be tested from a fresh clone.

## Decision Standard

When improving agent infrastructure, ask:

1. What should trigger this workflow?
2. What exact file, skill, script, or doc should the agent route to?
3. Is that target good enough to trust today?
4. What validation proves the workflow works?
5. What should make the agent stop and ask?
6. Can another person clone this and use it without knowing the private context?

If the answer depends on private taste or local repo history, either document it
as a public principle or keep it out of the shared artifact.
