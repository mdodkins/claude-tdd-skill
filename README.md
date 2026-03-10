# TDD Skill for Claude Code

A custom skill that puts Claude into strict Test Driven Development mode, enforcing the Red-Green-Refactor cycle for every behaviour implemented.

## Prerequisites

You must be authenticated with the GitHub CLI and have git configured to use it for HTTPS credentials:

```bash
gh auth login
gh auth setup-git
```

If you're already logged in but using SSH, switch to HTTPS and configure the credential helper:

```bash
gh auth login --hostname github.com --git-protocol https
gh auth setup-git
```

## Installation

### From the Claude Code command line (recommended)

Register this repo as a plugin marketplace, then install:

```
/plugin marketplace add mdodkins/claude-tdd-skill
/plugin install tdd@mdodkins-tdd
```

### Manual installation

Copy the skill file into your personal skills folder:

```bash
mkdir -p ~/.claude/skills/tdd
cp skills/tdd/SKILL.md ~/.claude/skills/tdd/SKILL.md
```

Or for a specific project, copy it into the project's `.claude` directory and commit it:

```bash
mkdir -p .claude/skills/tdd
cp /path/to/tdd-skill/skills/tdd/SKILL.md .claude/skills/tdd/SKILL.md
```

### Verifying installation

In any Claude Code session, ask:

```
What skills are available?
```

You should see `tdd` in the list. You can also invoke it directly with `/tdd`.

## What It Does

When triggered, this skill instructs Claude to:
- Maintain a test list of behaviours to implement
- Follow the Red-Green-Refactor cycle for each behaviour
- Actually run tests at every phase transition (no simulating or assuming)
- Write the minimum production code demanded by failing tests
- Refactor both production and test code

## Trigger Behaviour

The skill auto-triggers when you ask Claude to implement, build, create, fix, refactor, or write code.

It does **not** trigger for debugging, questions about code, exploratory/spike work, or writing tests for already-existing code.

## Design Decisions & Optimisation

This skill was developed with reference to Anthropic's official skill authoring guidance. Key decisions:

### Imperative voice, not second person

The official best practices state: *"Write using verb-first instructions, not second person."*

- **Before:** "You MUST actually run the test and see it fail before proceeding to Green."
- **After:** "Run the test and confirm the failure before moving to Green."

This isn't just style — the skill-creator skill notes that imperative form is clearer for AI consumption and maintains consistency.

### Reasoning over commands

The skill-creator skill advises: *"Try hard to explain the why behind everything... If you find yourself writing ALWAYS or NEVER in all caps, that's a yellow flag — reframe and explain the reasoning so that the model understands why the thing you're asking for is important."*

- **Before:** "You MUST actually run the test and see it fail before proceeding to Green."
- **After:** "Skipping this step defeats the purpose of TDD — an unverified red phase means there's no proof the test can catch a regression."

Claude has good theory of mind. Understanding *why* a rule exists leads to better adherence than being commanded to follow it.

### Concise by default

The official docs emphasise: *"Claude is already very smart. Only add context Claude doesn't already have."* Explanations of well-known concepts (like Arrange-Act-Assert) were removed because they consume tokens without adding value.

### Description optimisation

Skill descriptions are the primary triggering mechanism and share a combined character budget (~2% of context window, ~16K chars fallback) across all installed skills. A bloated description is more costly than a longer body, because descriptions are always loaded while the body only loads on trigger.

The description was written to be:
- **Specific** — includes exact trigger phrases users would say
- **Pushy** — the skill-creator advises making descriptions "a little bit pushy" to combat under-triggering

### Size is fine as-is

The skill body is ~150 lines / ~1,000 words. The recommended limit is <500 lines. Progressive disclosure (splitting into reference files) is unnecessary at this size. If the skill grows significantly, detailed content should move to a `references/` directory.

## Token Budget & Length Guidelines

| Metric | Limit | This Skill |
|--------|-------|-----------|
| SKILL.md body | <500 lines | ~150 lines |
| Description field | Max 1024 chars | ~500 chars |
| All skill descriptions combined | ~2% of context window (~16K chars) | N/A |

The body is only loaded into context when the skill triggers. The description is always in context. This means description brevity matters more than body brevity for overall context efficiency.

## References

- [Skill authoring best practices — Claude API Docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Extend Claude with skills — Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Claude Code Skills Structure and Usage Guide (GitHub Gist)](https://gist.github.com/mellanon/50816550ecb5f3b239aa77eef7b8ed8d)
- [Claude Agent Skills: A First Principles Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)
