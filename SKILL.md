---
name: tdd
description: >
  This skill should be used when the user asks to implement, build, create, fix, or write
  code using Test Driven Development. TRIGGER when the user mentions "TDD", "test driven",
  "test first", "red green refactor", "write tests first", or asks to "implement" something
  in a test-driven way. Also trigger when the user wants to develop any feature and
  emphasises writing tests before code. DO NOT TRIGGER when the user is just asking
  questions about TDD theory, wants to write tests for already-existing code, or is doing
  exploratory/spike work.
---

# Test Driven Development (TDD)

Strict TDD mode. Every line of production code must be justified by a failing test — this
constraint is what makes TDD valuable, because it guarantees that tests actually verify
behaviour rather than just existing alongside code.

## Core Cycle: Red -> Green -> Refactor

Follow this cycle for every behaviour. Never skip a phase.

### RED: Write a Failing Test

1. Choose the next behaviour from the test list.
2. Write ONE test asserting ONE new behaviour. Name it as a behaviour specification
   (e.g., `test_returns_empty_list_when_no_items_match`).
3. Run the test. It must fail.
4. Verify it fails for the RIGHT reason — a wrong value, missing method, or incorrect
   behaviour. A failure due to syntax errors, import errors, or misconfigured tests means
   the test itself needs fixing first, because those failures don't prove anything about
   the behaviour under test.
5. If the test already passes, it is not testing new behaviour — discard it and write a
   different one.

**Run the test and confirm the failure before moving to Green.** Skipping this step defeats
the purpose of TDD — an unverified red phase means there's no proof the test can catch a
regression.

### GREEN: Write the Minimum Code to Pass

1. Write the simplest, smallest amount of production code that makes the failing test pass.
2. Prefer simpler transformations (Transformation Priority Premise):
   - Return a constant before introducing a variable
   - Use a variable before adding a conditional
   - Use a conditional before introducing a loop
   - Use a loop before introducing recursion
   This ordering matters because jumping to complex transformations often introduces
   speculative code that no test demanded.
3. Do NOT write code that is not demanded by a failing test. Premature error handling,
   optimisation, or extra features undermine TDD's feedback loop — they introduce untested
   behaviour.
4. Run ALL tests. They must all pass.
5. If getting to green takes more than 1-2 attempts, the test covers too much ground.
   Delete it, write a simpler test, and try again.

**Run all tests and confirm they pass before moving to Refactor.**

### REFACTOR: Improve Structure While Green

1. Look at both production code AND test code for improvements:
   - Remove duplication (in code AND tests)
   - Improve naming
   - Extract methods, functions, or classes
   - Simplify conditionals
   - Restructure test helpers, fixtures, or setup
2. Test code deserves the same quality standards as production code. Hard-to-read tests
   become a maintenance burden that slows down future TDD cycles.
3. Make ONE refactoring change at a time. Run all tests after each change.
4. If a refactoring breaks a test, undo it immediately and take a smaller step.
5. Refactoring is optional in any given cycle — skip it if the code is already clean.

**Run tests after every refactoring change to confirm they still pass.**

## Rules

1. **No production code without a failing test.** This is TDD's core discipline. If
   there's an urge to write implementation code, channel it into writing a test first.

2. **Run real tests every time.** Use the project's actual test runner. Never simulate
   or assume test output — the whole point is to let real test results drive decisions.

3. **Minimise mocking.** Mocks lie about how the system actually works. Only mock at
   hard architectural boundaries (external HTTP APIs, databases without in-memory
   alternatives, filesystem when truly necessary, system clock/randomness). If it can
   be tested with real code, test it with real code.

4. **Keep steps small.** Each cycle should touch a small, focused behaviour. Needing
   more than ~10 lines of production code to pass a test usually means the test covers
   too much.

5. **Maintain a test list.** Before starting, brainstorm the behaviours to test and
   write them as a checklist ordered from simplest to most complex. Update the list as
   new cases are discovered or existing ones are completed. Share the list with the user.

6. **Refactor tests too.** When test setup becomes repetitive or helper functions could
   be clearer, refactor them with the same rigour as production code.

7. **Announce the phase.** Before each action, state the current phase:
   - `RED: Writing a test for [behaviour]`
   - `GREEN: Writing minimum code to pass`
   - `REFACTOR: [what is being improved]`

## Getting Started

When beginning a TDD task:

1. **Understand the goal.** Read existing code, understand the requirement. Ask
   clarifying questions if the desired behaviour is ambiguous.

2. **Detect the test framework.** Check existing test files, `package.json`,
   `pyproject.toml`, `Cargo.toml`, `go.mod`, `Gemfile`, `build.gradle`, or equivalent.
   Use whatever framework and conventions the project already uses. If no tests exist,
   ask the user which framework to use.

3. **Brainstorm the test list.** List behaviours from simplest to most complex. Start
   with degenerate cases (empty input, zero, null) and build toward core logic. Share
   the list with the user.

4. **Start the first Red-Green-Refactor cycle** with the simplest test from the list.

## Completion

The task is done when:
- All behaviours on the test list are covered and passing
- The user confirms the feature is complete
- The code is in a clean, refactored state with all tests green

Run the full test suite one final time to confirm everything passes.

## Common Pitfalls

- **Writing the whole implementation then backfilling tests** is not TDD. It loses the
  design feedback that emerges from writing tests first.
- **Skipping Red** means a passing test proves nothing — it might pass for the wrong
  reason entirely.
- **Over-mocking** (mocking three things to test one function) suggests testing through
  a higher-level interface with fewer mocks would be more effective.
- **Refactoring and adding behaviour simultaneously** conflates two concerns. Refactor
  only when green; add behaviour only through a new failing test.
- **Skipping test runs** removes the evidence that TDD is working. Every phase
  transition requires actually running tests.
