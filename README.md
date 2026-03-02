# pond

A Rust learning workspace built around a single project: **pond** — a
simulation ecosystem where agents inhabit, act within, and emerge from a
living world.

The idea: learn Rust deeply by building something ambitious. Not toy
exercises, not framework tutorials — a real simulation engine that grows as
your understanding of Rust grows. Think Dwarf Fortress meets Caves of Qud
meets an AI research sandbox, built from scratch in Rust.

## How This Works

This workspace is designed to be used with [Claude Code](https://claude.com/claude-code).
Each session, Claude reads `LEARNING_PLAN.md` to understand where you are,
what you've covered, and how to teach you. The plan adapts as you go — it's a
living document, not a fixed syllabus.

You show up, paste a prompt, and start learning. No prep needed.

## Starting a Session

### First time
```
I'm starting my Rust learning course. Read LEARNING_PLAN.md (especially the
Session Protocol and Progress Log) and let's begin with Module 0.1 —
setting up the environment and getting our first Rust code running. The
project is called "pond."
```

### Continuing
```
Let's continue the Rust course. Read LEARNING_PLAN.md and check the Progress
Log for where we left off. Pick up from there.
```

### Deep-dive on something specific
```
I want to do a deep-dive session on [TOPIC]. Read LEARNING_PLAN.md for
context on my background and preferences, then let's explore [TOPIC] in
depth. Connect it to the pond project where relevant.
```

### Just a quick question
```
Quick question (no need to do a full session): [QUESTION]
```

See `LEARNING_PLAN.md` Section 7 for more session starters.

## What to Expect in a Session

1. **Recap** — Claude catches you up on where you left off
2. **Concept + Build** — Learn a Rust concept, then immediately apply it to
   pond. Theory and practice interleaved.
3. **Checkpoint** — A conversational check that you've got it
4. **Bridge** — Set up what's next

Sessions are adaptive. If you're chasing an idea, the session follows your
energy. If you're in "learn mode," Claude leads with theory. Push back
anytime — the pacing is yours to control.

## Curriculum Overview

**Phase 0 — Setup:** Install Rust, create the pond project, first code.

**Phase 1 — Core Rust:** Ownership, types, traits, error handling, iterators,
smart pointers, modules, collections, and the ECS pattern. By the end of this
phase, pond has a working hand-built ECS with entities, components, and
systems.

**Phase 2 — Simulation Depth:** Agent AI (behavior trees, utility AI),
procedural world generation, concurrency, serialization, visualization, and
data-driven design. By the end, pond is a living, interactive simulation with
multiple AI approaches, generated worlds, and moddable rules.

**Phase 3 — Advanced Rust:** Macros, unsafe code, async programming, neural
network agents, performance optimization, and advanced type system patterns.
Pick modules based on interest.

## Directory Structure

As the course progresses, the workspace will grow:

```
pond/                       # This directory
├── CLAUDE.md               # Claude's session bootstrap
├── LEARNING_PLAN.md        # The full curriculum and progress log
├── README.md               # You're reading this
├── notes/                  # Typst notes created during sessions
│   └── _preamble.typ       # Shared formatting
├── pond/                   # Library crate (simulation engine)
│   └── src/
├── pond-cli/               # Binary crate (rendering, input)
│   └── src/
└── exercises/              # Standalone exercises (if needed)
```

## Tips

- **Follow your curiosity.** If something fascinates you mid-session, chase
  it. The curriculum will adapt.
- **Push back on Claude.** If the pacing is wrong, the explanation isn't
  clicking, or you want to go deeper — say so.
- **No prep needed.** Just show up and paste a session starter.
- **The plan evolves.** Modules get reordered, new ones appear, some get
  dropped. This is by design.
- **Your code is your notebook.** The pond codebase itself is the primary
  artifact. Notes supplement it, not the other way around.
