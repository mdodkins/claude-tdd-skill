# TDD Skill for Claude Code

A custom skill that puts Claude into strict Test Driven Development mode, enforcing the Red-Green-Refactor cycle for every behaviour implemented.

## Installation

There are three ways to install the skill depending on your needs.

### Option 1: Personal skill (available in all your projects)

Copy the skill into your personal skills folder:

**Linux / macOS:**
```bash
mkdir -p ~/.claude/skills/tdd
cp SKILL.md ~/.claude/skills/tdd/SKILL.md
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills\tdd"
Copy-Item SKILL.md "$env:USERPROFILE\.claude\skills\tdd\SKILL.md"
```

### Option 2: Symlink (available everywhere, editable from one place)

If you want to keep developing the skill, symlink it so edits take effect immediately across all projects:

**Linux / macOS:**
```bash
mkdir -p ~/.claude/skills
ln -s /path/to/tdd-skill ~/.claude/skills/tdd
```

**Windows (PowerShell, run as Administrator):**
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills"
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.claude\skills\tdd" -Target "C:\path\to\tdd-skill"
```

### Option 3: Project skill (for a specific repo, shareable with your team)

Copy into the project's `.claude` directory and commit it to version control:

**Linux / macOS:**
```bash
mkdir -p .claude/skills/tdd
cp /path/to/tdd-skill/SKILL.md .claude/skills/tdd/SKILL.md
```

**Windows (PowerShell):**
```powershell
New-Item -ItemType Directory -Force -Path ".claude\skills\tdd"
Copy-Item "C:\path\to\tdd-skill\SKILL.md" ".claude\skills\tdd\SKILL.md"
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

## Trigger Words

The skill activates when the user mentions TDD-related terms alongside a request to write code:
- "TDD", "test driven", "test first"
- "red green refactor", "write tests first"
- "implement" (in a test-driven context)
- Any request to build/create/fix code with an emphasis on writing tests before code

It does **not** trigger for questions about TDD theory, writing tests for existing code, or exploratory/spike work.

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
- **Third-person** ("This skill should be used when...") — required format per official docs
- **Specific** — includes exact trigger phrases users would say
- **Pushy** — the skill-creator advises making descriptions "a little bit pushy" to combat under-triggering

### Size is fine as-is

The skill body is ~118 lines / ~1,000 words. The recommended limit is <500 lines. Progressive disclosure (splitting into reference files) is unnecessary at this size. If the skill grows significantly, detailed content should move to a `references/` directory.

## Token Budget & Length Guidelines

| Metric | Limit | This Skill |
|--------|-------|-----------|
| SKILL.md body | <500 lines | ~118 lines |
| Description field | Max 1024 chars | ~500 chars |
| All skill descriptions combined | ~2% of context window (~16K chars) | N/A |

The body is only loaded into context when the skill triggers. The description is always in context. This means description brevity matters more than body brevity for overall context efficiency.

## References

- [Skill authoring best practices — Claude API Docs](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices)
- [Extend Claude with skills — Claude Code Docs](https://code.claude.com/docs/en/skills)
- [Claude Code Skills Structure and Usage Guide (GitHub Gist)](https://gist.github.com/mellanon/50816550ecb5f3b239aa77eef7b8ed8d)
- [Claude Agent Skills: A First Principles Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/)
