# pond — Rust Learning Plan

> **Living document.** Claude is expected to actively search for new resources,
> adapt the curriculum, reorder modules, and evolve this plan as sessions
> progress. The plan is a scaffold, not a cage.

**Project:** pond — a simulation ecosystem where agents inhabit, act within,
and emerge from a living world. Think Dwarf Fortress meets Caves of Qud meets
an AI research sandbox.

**Language:** Rust (learning from zero, targeting deep mastery)

---

## 1. Learner Profile

### Background
- **Math:** PhD in ring/representation theory. Comfortable with abstract
  algebra, category-theoretic thinking, formal reasoning. Will naturally seek
  algebraic structure in type systems and API design.
- **Physics:** Undergraduate in physics (experimental focus, heavy software
  component). Comfortable with simulation, numerical methods, physical
  modeling.
- **Programming:** Strong polyglot background:
  - **C/C++:** Manual memory management, pointers, systems thinking. This is
    the bridge to Rust's ownership model — but Rust's approach is different
    enough to warrant careful treatment, not "just like C++ but..."
  - **Python/JS:** Scripting, rapid prototyping, ML workflows. Useful for
    comparison but may create expectations about dynamism that Rust resists.
  - **Haskell/OCaml:** Pattern matching, algebraic data types, type classes /
    modules. This is the bridge to Rust's trait system and enums — but again,
    Rust's flavor is distinct (no HKTs, coherence rules, object safety).
- **ML:** Has trained models, understands backprop, loss functions,
  architectures. Practical hands-on experience. Relevant for the agent AI
  portion of pond.
- **Current career:** Medical computing (software-heavy role). Career switcher
  from math/physics into software.

### Motivations
- **Systems mastery:** Wants deep understanding of systems programming,
  memory, concurrency — not just "enough to get by."
- **Intellectual curiosity:** Genuinely interested in Rust's design decisions
  and the "why" behind the language.
- **Build something real:** pond is the vehicle — a simulation/game that
  exercises real Rust patterns at scale.
- **Deep mastery goal:** Wants to understand ownership, the trait system,
  async, unsafe — the full language, not a subset.

### Learning Style
- **Adaptive theory-practice balance:** When chasing a project idea → let the
  project drive. When not actively chasing something → theory-first is the
  default. Claude should read the room.
- **When stuck:** Targeted explanation. Don't let them flounder, but don't
  hand them the answer either. Explain the concept they're missing so they can
  apply it themselves.
- **Exposition style:** Rigorous but motivated. This learner has a
  mathematician's taste — they want to understand *why* something is true, not
  just *that* it is. But they also want to see the payoff. Connect concepts to
  the project or to real problems.
- **No framework worship:** Understand fundamentals before adopting
  frameworks. Build ECS from scratch before using bevy_ecs. Understand what a
  trait object is before using `dyn`.
- **No busywork:** Every exercise should teach something. No padding.
- **Pace:** Variable schedule — some weeks heavy, some weeks light. Sessions
  must survive week-long gaps with good recaps, but should build continuity
  when sessions are close together.
- **Deep-dive tendency:** Likely. A math PhD who chose "deep mastery" will
  probably want to chase interesting tangents. The curriculum should
  accommodate this — mark optional deep-dives and let the learner choose.

### Technical Environment
- **OS:** Linux (Ubuntu-based, kernel 6.8)
- **Rust:** Not yet installed (install in session 0)
- **Typst:** 0.14.2 installed via snap, compiles successfully from project dir
- **PDF viewer:** xdg-open available
- **Editor:** Using Claude Code (CLI) — code is written and edited through
  Claude sessions

### Anti-Preferences
- Don't over-explain things inferable from their C++/Haskell background
- Don't use toy/contrived examples disconnected from real problems
- Don't teach framework APIs before the underlying concepts
- Don't pad with exercises that don't teach something new
- Don't be condescending about their ability level — calibrate for a
  sharp, experienced programmer who just hasn't seen Rust before

---

## 2. Program Structure

The curriculum is organized into three phases. The project (pond) is
introduced early and grows alongside concept mastery. Modules within a phase
can be reordered based on what the learner is building at the time.

### Phase 0: Setup & Orientation (1 session)

**Module 0.1 — Environment & First Contact**
- Objectives: Rust toolchain installed, cargo understood, first program runs,
  basic language tour
- Content:
  - Install rustup, rustc, cargo
  - Cargo project structure, `Cargo.toml`, dependencies
  - Language tour: variables, types, functions, control flow, expressions vs
    statements
  - `println!` and basic formatting (introduce macros as "they exist, we'll
    go deep later")
  - Initialize the `pond` cargo project
- Exercises:
  - Create `pond` project, make it print a world greeting
  - Write a small function that takes arguments and returns a value
  - Modify Cargo.toml to add a dependency (e.g., `rand`), use it
- Checkpoint: Can create, build, run, and modify a Cargo project. Understands
  expressions, basic types, and function signatures.
- Bridge: "Now that we can write Rust, let's understand what makes it *Rust*
  — ownership."

### Phase 1: Core Rust (Modules 1.1–1.8)

The heart of the language. Each module introduces a Rust concept and applies
it to pond.

**Module 1.1 — Ownership, Borrowing, and Lifetimes**
- Objectives: Deeply understand ownership semantics, move vs. copy, borrowing
  rules, lifetime annotations, and *why* Rust does this
- Content:
  - The ownership model: what problem it solves (compare to C++ RAII,
    GC, manual malloc/free)
  - Move semantics (contrast with C++ move semantics — different!)
  - Copy vs. Clone — the trait-level distinction
  - References: `&T` and `&mut T`, borrowing rules
  - Lifetimes: what they are, when you need annotations, elision rules
  - The borrow checker as a static analysis tool — what it proves
  - Common patterns: returning owned values, borrowing in function args,
    lifetime in structs
- Exercises:
  - Implement a `World` struct that owns a grid of `Tile`s
  - Write functions that borrow the world immutably (query) and mutably
    (modify)
  - Deliberately trigger borrow checker errors, then fix them with
    understanding (not just appeasement)
  - Implement a function that returns a reference into the world — encounter
    lifetimes naturally
- Checkpoint: Can explain ownership in their own words. Can predict what the
  borrow checker will accept/reject and *why*. Can use lifetime annotations
  when needed.
- Bridge: "We've been using basic types. Let's build richer types for pond —
  structs and enums."

**Module 1.2 — Structs, Enums, and Pattern Matching**
- Objectives: Define custom types, use algebraic data types, pattern match
  exhaustively
- Content:
  - Structs: named, tuple, unit
  - Enums: C-style, with data (algebraic data types — connect to
    Haskell/OCaml ADTs)
  - `impl` blocks: methods, associated functions
  - Pattern matching: `match`, `if let`, `while let`, destructuring
  - `Option<T>` and `Result<T, E>` as enum exemplars
  - Newtype pattern, builder pattern
- Exercises:
  - Define pond entity types: `Creature`, `Resource`, `Terrain` as enums
    with associated data
  - Implement methods on a `Tile` struct
  - Use pattern matching to handle different terrain/entity types
  - Build a small world grid that contains different tile types
- Checkpoint: Comfortable defining types, implementing methods, and pattern
  matching. Sees enums as "Haskell sum types but in Rust."
- Bridge: "Our types work, but they're concrete. Let's make them generic and
  understand traits."

**Module 1.3 — Traits and Generics**
- Objectives: Understand traits as Rust's abstraction mechanism, write generic
  code, grasp trait bounds and coherence
- Content:
  - Traits as interfaces (compare to Haskell type classes, C++ concepts, Go
    interfaces — note key differences)
  - Implementing traits: `impl Trait for Type`
  - Derive macros: `Debug`, `Clone`, `PartialEq`, etc.
  - Generics: functions, structs, enums
  - Trait bounds: `where` clauses, multiple bounds
  - Static dispatch (monomorphization) vs. dynamic dispatch (`dyn Trait`)
  - Coherence rules and the orphan rule — why they exist
  - Associated types vs. generic parameters (when to use which)
  - Common std traits: `Display`, `From`/`Into`, `Default`, `Iterator`
- Exercises:
  - Define a `Behavior` trait for pond entities
  - Implement `Behavior` for different creature types
  - Write a generic `simulate_step` function that works over anything with
    `Behavior`
  - Explore: when does `dyn Behavior` make sense vs. generics?
  - Implement `Display` for pond types
- Checkpoint: Can define traits, implement them, write generic functions with
  bounds. Understands monomorphization vs. dynamic dispatch tradeoffs.
- Bridge: "We have types and behaviors. Let's handle errors properly and
  manage failure in our simulation."

**Module 1.4 — Error Handling**
- Objectives: Idiomatic Rust error handling, custom error types, `?` operator
- Content:
  - `Result<T, E>` in depth
  - The `?` operator and early returns
  - Custom error types: manual impl, `thiserror`
  - `anyhow` for application-level error handling
  - When to `panic!` vs. return `Result`
  - Error handling philosophy: make illegal states unrepresentable
- Exercises:
  - Add error handling to world loading/creation
  - Define a `PondError` enum for simulation errors
  - Propagate errors through the simulation tick pipeline
- Checkpoint: Uses `Result` idiomatically, defines meaningful error types.
- Bridge: "Now let's look at Rust's most powerful abstraction for sequences
  and data processing — iterators."

**Module 1.5 — Iterators and Closures**
- Objectives: Master the iterator protocol, closure types, functional
  programming patterns in Rust
- Content:
  - The `Iterator` trait: `next()`, `Item`
  - Iterator adapters: `map`, `filter`, `fold`, `collect`, `enumerate`,
    `zip`, etc.
  - Lazy evaluation — iterators don't do work until consumed
  - Closures: `Fn`, `FnMut`, `FnOnce` — connect to ownership model
  - Closure capture modes and how the compiler infers them
  - Implementing `Iterator` for custom types
  - `IntoIterator` and `for` loops
  - Performance: zero-cost abstractions, iterator fusion
- Exercises:
  - Implement an iterator over all entities in the world
  - Use iterator chains to query the world: "find all creatures within
    distance N of position P with hunger > threshold"
  - Implement a custom iterator that yields neighbors of a tile
  - Write a simulation step using iterator combinators
- Checkpoint: Comfortable with iterator chains, understands closure types,
  can implement `Iterator`.
- Bridge: "Our world is getting richer. Let's talk about how Rust manages
  data behind the scenes — smart pointers and interior mutability."

**Module 1.6 — Smart Pointers and Interior Mutability**
- Objectives: Understand heap allocation, reference counting, interior
  mutability patterns
- Content:
  - `Box<T>`: heap allocation, recursive types
  - `Rc<T>` and `Arc<T>`: shared ownership
  - `RefCell<T>` and `Mutex<T>`: interior mutability
  - `Rc<RefCell<T>>` pattern — when and why
  - `Cell<T>` for Copy types
  - `Cow<T>`: clone-on-write
  - When each is appropriate (decision tree)
  - How these relate to the ownership model — they don't bypass it, they
    encode different ownership patterns
- Exercises:
  - Refactor pond's world to support entities that need shared references
    (e.g., a creature that references its current tile)
  - Implement a simple event system where multiple systems can read events
  - Use `RefCell` to allow mutation during a world query — feel the tension,
    understand the runtime borrow check
- Checkpoint: Can choose the right smart pointer for a given situation.
  Understands that `RefCell` moves borrow checking to runtime and why that's
  sometimes necessary.
- Bridge: "Let's step back and think about architecture. How should pond be
  structured to support the complex systems we want?"

---

**⟁ Synthesis Point: Core Language Foundations**

At this boundary, independently studied topics (ownership, types, traits,
error handling, iterators, smart pointers) interact to produce architectural
understanding. Synthesis content determined at runtime from session material.

---

**Module 1.7 — Modules, Crates, and Project Architecture**
- Objectives: Organize code into modules, understand visibility, design crate
  structure
- Content:
  - `mod`, `use`, `pub` — the module system
  - File-based module layout
  - Crate structure: lib vs. bin, workspaces
  - Visibility: `pub`, `pub(crate)`, `pub(super)`
  - API design principles: what to expose, what to hide
  - Re-exports and the public API surface
  - Cargo features
- Exercises:
  - Restructure pond into modules: `world`, `entity`, `behavior`, `sim`
  - Design the public API of each module
  - Create a workspace with `pond` (lib) and `pond-cli` (bin)
- Checkpoint: Pond has clean module boundaries with intentional visibility.
- Bridge: "Now let's think about how pond stores and accesses entities
  efficiently — this is where ECS comes in."

**Module 1.8 — Collections, Data Structures, and the ECS Pattern**
- Objectives: Master std collections, understand ECS architecture, build a
  simple one
- Content:
  - `Vec`, `HashMap`, `HashSet`, `BTreeMap`, `VecDeque`
  - Indexing patterns: generational indices, slot maps
  - The ECS pattern: entities as IDs, components as data, systems as logic
  - Why ECS: cache coherence, composition over inheritance, flexible queries
  - Comparison: OOP inheritance vs. ECS composition vs. trait-based
    polymorphism
  - Building a simple ECS: entity allocator, component storage (dense vs.
    sparse), system dispatch
- Exercises:
  - Implement a minimal ECS for pond from scratch
    - Entity: generational index
    - Component storage: `Vec<Option<T>>` indexed by entity
    - System: a function that iterates over entities with specific components
  - Migrate pond's world to use the ECS
  - Implement a basic simulation tick: movement system, hunger system
  - Profile: is the naive approach fast enough? Where are the bottlenecks?
- Checkpoint: Has a working hand-built ECS. Understands *why* ECS works the
  way it does at a data layout level. Pond's simulation runs on it.
- Bridge: "We have a world with entities and systems. Let's give our
  creatures brains."

---

**⟁ Synthesis Point: Architecture & Data**

Modules, ECS, collections, and smart pointers come together. How does
ownership interact with ECS? Where do lifetimes show up in system design?
Content determined at runtime.

---

### Phase 2: Intermediate Rust + Simulation Depth (Modules 2.1–2.6)

Build out pond's simulation systems while learning intermediate Rust.

**Module 2.1 — Agent Behaviors and AI Systems**
- Objectives: Implement agent decision-making using classical AI techniques
- Content:
  - Finite state machines (FSM)
  - Behavior trees: structure, tick evaluation, composability
  - Utility AI: scoring actions, weighting needs
  - Goal-oriented action planning (GOAP)
  - Comparison of approaches: when each shines
  - Implementing these in Rust: trait-based, enum-based, data-driven
- Exercises:
  - Implement a creature with an FSM: idle → forage → eat → idle
  - Refactor to a behavior tree: add priority, sequence, decorator nodes
  - Implement a utility AI system: creatures evaluate actions based on
    weighted needs
  - Run the simulation and observe emergent behavior differences between
    approaches
- Checkpoint: Multiple AI approaches implemented and compared. Creatures
  behave interestingly.
- Bridge: "Our creatures can think. Now they need to navigate."

**Module 2.2 — Procedural Generation and World Building**
- Objectives: Generate interesting worlds, implement spatial algorithms
- Content:
  - Noise functions (Perlin, Simplex) for terrain
  - Wave Function Collapse — the algorithm and its applications
  - Cellular automata for cave/biome generation
  - Graph-based map generation
  - Spatial data structures: quadtrees, spatial hashing
  - Pathfinding: A*, Dijkstra maps, flow fields
  - Rust-specific: using `rand` crate, seeded RNG for reproducibility
- Exercises:
  - Generate a world with terrain features using noise
  - Implement A* pathfinding for creatures
  - Implement Dijkstra maps for influence/navigation
  - Generate cave systems with cellular automata
  - Add resource distribution based on terrain type
- Checkpoint: Pond generates interesting, navigable worlds. Creatures
  pathfind through them.
- Bridge: "The world is getting complex. Let's add interaction between
  entities."

**Module 2.3 — Concurrency and Parallelism**
- Objectives: Understand Rust's concurrency model, parallelize simulation
- Content:
  - `Send` and `Sync` traits — what they mean and why they're special
  - Threads: `std::thread`, `spawn`, `join`
  - Shared state: `Arc<Mutex<T>>`, `RwLock`, atomic types
  - Message passing: `mpsc` channels
  - `rayon` for data parallelism: parallel iterators
  - "Fearless concurrency" — how the type system prevents data races
  - Parallelizing ECS: which systems can run in parallel?
  - Practical: parallel simulation ticks
- Exercises:
  - Parallelize the simulation tick using `rayon`
  - Implement a parallel system scheduler for the ECS
  - Use channels for a simulation-to-renderer communication pattern
  - Benchmark: how much speedup do we get from parallelism?
- Checkpoint: Simulation runs in parallel where possible. Understands `Send`,
  `Sync`, and the concurrency guarantees the type system provides.
- Bridge: "Let's make the simulation interact with the outside world — input,
  output, visualization."

**Module 2.4 — I/O, Serialization, and Persistence**
- Objectives: Save/load worlds, handle I/O idiomatically
- Content:
  - `std::io`: `Read`, `Write`, `BufReader`, `BufWriter`
  - File I/O patterns
  - `serde`: serialization framework, derive macros, format adapters
  - Saving and loading game state with `serde_json` / `bincode`
  - Configuration files with `toml` / `ron`
  - CLI argument parsing with `clap`
- Exercises:
  - Serialize/deserialize the pond world state
  - Implement save/load for a running simulation
  - Add a configuration file for simulation parameters
  - Add CLI args to `pond-cli` for world generation options
- Checkpoint: Can save/load complete simulation state. Configuration is
  externalized.
- Bridge: "Time to give pond a face. Let's add visualization."

**Module 2.5 — Visualization and User Interface**
- Objectives: Render the simulation, accept input, create a playable
  experience
- Content:
  - Terminal rendering: `crossterm` or `ratatui` for TUI
  - ASCII/tile-based rendering of the world
  - Input handling: keyboard, game loop timing
  - The game loop: fixed timestep, variable rendering
  - Simple 2D graphics options: `macroquad`, `minifb`, `pixels`
  - When to upgrade: terminal → simple window → full graphics
- Exercises:
  - Render the pond world in the terminal with colors
  - Add camera/viewport for scrolling
  - Add input: move the "camera" or a player entity
  - Display entity information (inspection)
  - Add a simple simulation speed control
- Checkpoint: Pond is visually alive and interactive. You can watch creatures
  behave.
- Bridge: "Let's make the simulation rules moddable and data-driven."

**Module 2.6 — Data-Driven Design and Scripting**
- Objectives: Make simulation rules configurable and moddable
- Content:
  - Data-driven entity definitions (RON/TOML/JSON species files)
  - Component templates: spawning entities from data
  - Scripting integration options: Lua via `mlua`/`rlua`, Rhai (Rust-native)
  - Event systems: observer pattern, event queues
  - Plugin architecture patterns
  - Mod loading: hot-reloading data, script sandboxing
- Exercises:
  - Define creature species in data files (RON)
  - Load and spawn entities from data definitions
  - Implement an event bus for simulation events
  - (Optional) Embed a scripting language for behavior definitions
- Checkpoint: Creature definitions are data-driven. New species can be added
  without recompilation.
- Bridge: "We've built a solid simulation. Now let's go deep on advanced Rust
  and give pond some cutting-edge capabilities."

---

**⟁ Synthesis Point: The Living Simulation**

All Phase 2 systems interact: AI agents navigate procedurally generated
worlds, run in parallel, persist state, render visually, and are data-driven.
Major synthesis opportunity. Content determined at runtime.

---

### Phase 3: Advanced Rust + Advanced Simulation (Modules 3.1–3.6)

Deep Rust topics and ambitious pond features. Modules here are more
independent — pick based on interest.

**Module 3.1 — Macros (Declarative and Procedural)**
- Objectives: Understand Rust's macro system, write useful macros
- Content:
  - Declarative macros: `macro_rules!`, pattern syntax, hygiene
  - When `macro_rules!` is the right tool
  - Procedural macros: derive, attribute, function-like
  - `syn` and `quote` crates
  - Macro design: when to use, when not to
- Exercises:
  - Write a `component!` derive macro for pond's ECS
  - Write a declarative macro for entity spawning DSL
  - (Optional) Write a proc macro for auto-registering systems

**Module 3.2 — Unsafe Rust and FFI**
- Objectives: Understand when and how to use unsafe, interface with C
- Content:
  - What `unsafe` means and doesn't mean
  - Unsafe superpowers: raw pointers, calling unsafe functions, `unsafe impl`
  - Invariants and safety contracts
  - FFI: calling C from Rust, calling Rust from C
  - `bindgen` and `cbindgen`
  - When unsafe is justified in safe abstractions
- Exercises:
  - Write a custom allocator-friendly data structure with unsafe internals
  - Interface with a C library (e.g., a noise generation library)
  - Audit unsafe code: identify soundness issues in example code

**Module 3.3 — Async Rust**
- Objectives: Understand the async model, futures, runtimes
- Content:
  - Futures and the `async`/`await` model
  - Runtime: `tokio` (or `smol` for simplicity)
  - `Pin`, `Unpin`, and why they exist
  - Async patterns: streams, select, join
  - Practical async: networked multiplayer, async I/O
  - When async is overkill (hint: often in games)
- Exercises:
  - Add a network layer to pond: a simple server that streams simulation
    state
  - Implement a remote viewer that connects and renders
  - Handle multiple clients concurrently

**Module 3.4 — Neural Network Agents**
- Objectives: Integrate ML models into the simulation
- Content:
  - Rust ML ecosystem overview: `burn`, `candle`, `tch-rs`
  - Defining and training simple neural nets in Rust
  - Integrating a trained model as an agent brain
  - Reinforcement learning loop: observation → action → reward → train
  - Comparison: classical AI vs. neural agent behavior
  - Hybrid approaches: neural perception + classical planning
- Exercises:
  - Train a simple neural net agent to navigate to food
  - Compare neural agent behavior vs. utility AI behavior
  - Implement a reinforcement learning training loop within pond
  - Experiment with different observation/action spaces

**Module 3.5 — Performance and Optimization**
- Objectives: Profile, benchmark, and optimize Rust code
- Content:
  - Benchmarking: `criterion`, `#[bench]`
  - Profiling: `perf`, `flamegraph`, `cargo-flamegraph`
  - Memory layout: `#[repr]`, alignment, cache lines
  - SIMD: auto-vectorization, `std::simd`
  - Allocation patterns: arena allocators, object pools
  - Data-oriented design: struct-of-arrays vs. array-of-structs
  - Compile-time optimization: `#[inline]`, LTO, PGO
- Exercises:
  - Profile the simulation with flamegraph — find the hotspot
  - Benchmark different component storage layouts
  - Implement an arena allocator for a subsystem
  - Optimize the pathfinding or behavior tick to handle 10k+ entities

**Module 3.6 — Advanced Type System Patterns**
- Objectives: Use Rust's type system for powerful static guarantees
- Content:
  - Phantom types and zero-sized types
  - Type-state pattern: encoding state machines in the type system
  - Sealed traits
  - GATs (generic associated types)
  - `const` generics
  - Trait objects: object safety, fat pointers
  - The `Any` trait and type erasure
  - Design patterns: builder, newtype, extension traits
- Exercises:
  - Use typestate to encode entity lifecycle (Spawned → Active → Dead) at
    the type level
  - Implement a generic component storage using const generics
  - Design a type-safe query API for the ECS

---

**⟁ Synthesis Point: Mastery Integration**

All advanced topics connect back to pond and to each other. How does unsafe
enable high-performance ECS? How do macros reduce boilerplate in data-driven
systems? How does async enable multiplayer? Content determined at runtime.

---

## 3. Session Protocol

### Session Flow

1. **Recap** (2-3 min): Claude reads the Progress Log and recaps where we
   left off. If there's been a gap, do a fuller recap. Reference specific
   code and concepts from the last session.

2. **Warm-up** (5 min, optional): A quick exercise that activates relevant
   prior knowledge. Skip if the learner is eager to dive in or continuing
   mid-module.

3. **Content** (bulk of session): Present concepts interleaved with
   implementation. Follow the module outline but adapt to the learner's
   energy and questions. If they're chasing an idea — let it happen and
   backfill theory later. If they're in "learn mode" — lead with theory
   then implement.

4. **Exercises**: Integrated with content, not a separate phase. When a
   concept is presented, immediately apply it to pond. Exercises should
   produce working code that advances the project.

5. **Checkpoint** (end): Verify understanding with targeted questions. Don't
   be quizzy — make it conversational. "Can you explain back to me why X
   works this way?" or "What would happen if we tried Y?"

6. **Bridge** (1 min): Set up what's next. Update the Progress Log.

### Tone and Style

- **Calibration:** This learner is a PhD mathematician who programs in C++
  and Haskell. Talk to them like a knowledgeable colleague, not a student.
  Use precise language. Don't shy from abstraction — they love it.
- **Rigor with motivation:** When explaining a concept, always connect it to
  *why* it exists (the problem it solves) and *where* it shows up in pond.
- **Mathematical analogies welcome:** If there's a natural algebraic or
  categorical analogy, use it. Monoids, functors, algebraic data types —
  these are native vocabulary.
- **Honest about tradeoffs:** Don't oversell Rust. When something is
  genuinely annoying or has rough edges, say so. The learner will respect
  honesty over advocacy.
- **Pacing:** Fast by default — this learner will absorb quickly given their
  background. But slow down on genuinely novel concepts (ownership is *not*
  like C++ RAII, even though it looks similar).

### Handling "Stuck"

- **Default:** Targeted explanation. Identify the specific concept they're
  missing and explain it clearly. Let them apply the understanding.
- **If the blocker is a misunderstanding from C++/Haskell:** Explicitly
  contrast. "In C++ you'd expect X. In Rust, Y happens instead, because Z."
- **If the blocker is a compiler error:** Read the error with them. Rust's
  error messages are excellent — teach them to read errors, not just fix them.
- **Never just give them the answer without explanation.** Always connect the
  fix to the concept.

### Checkpoint Enforcement

Suggested, not enforced. If the learner wants to push ahead, let them. If
you notice they're building on shaky foundations, gently suggest revisiting.

### Synthesis Sessions

Synthesis is distinct from cumulative assessment.

- **Assessment** asks "can you still do X?" — it's backward-looking and
  evaluative.
- **Synthesis** discovers connections between topics that weren't visible
  when studied separately — it's forward-looking and generative.

At synthesis points marked in the curriculum (⟁), Claude should:
1. Review all notes and session artifacts (not just since the last synthesis —
   reach back to any prior material)
2. Identify cross-cutting connections: "ownership + ECS creates this
   interesting tension...", "the trait system + behavior trees gives us this
   compositional pattern..."
3. Build exercises that force these connections to surface
4. Let the learner discover the connections through the exercises, then
   discuss

Synthesis content is **never pre-scripted** because sessions regularly
produce valuable tangents that couldn't have been predicted.

### Directory Structure

```
pond/                       # Root project
├── CLAUDE.md               # Claude Code bootstrap
├── LEARNING_PLAN.md        # This document
├── README.md               # Human-facing guide
├── notes/                  # Typst notes (rendered during sessions)
│   ├── _preamble.typ       # Shared preamble
│   ├── 1.1-ownership/      # Module-aligned notes
│   ├── 1.3-traits/
│   └── ecs-patterns/       # Cross-cutting / tangent notes
├── pond/                   # Main library crate (created during course)
│   ├── Cargo.toml
│   └── src/
├── pond-cli/               # Binary crate (created during course)
│   ├── Cargo.toml
│   └── src/
└── exercises/              # Standalone exercises (if needed)
```

### Notes and Rendered Artifacts

- **Tool:** Typst 0.14.2 (installed, working)
- **Preamble:** `notes/_preamble.typ` — import in all note files
- **Naming:** `notes/<module-id>-<topic>/` for module notes,
  `notes/<topic>/` for tangent/cross-cutting notes
- **Compilation:** `typst compile --root . notes/<path>/main.typ notes/<path>/main.pdf`
  (the `--root .` flag is required because Typst sandboxes file access to the
  compilation root, and note files import the preamble via `../`; always run
  from the project root directory)
- **Viewing:** `xdg-open notes/<path>/main.pdf`
- **When to create notes:** When material is complex enough to warrant
  rendering (architecture diagrams, ownership visualizations, type
  relationships, algorithm diagrams). Don't force notes at session end —
  create them organically when they'd genuinely help understanding.

### Adaptivity & Resource Discovery

Claude should actively:
- **Search the web** for new resources during sessions when a topic comes up
  that could benefit from external material
- **Adapt the curriculum** based on how sessions go — add, remove, or reorder
  modules
- **Update resource lists** when better resources are discovered
- **Log all adaptations** in the Progress Log with rationale
- **Watch for project-seeding moments** — when the learner is excited about
  something, capture that energy and potentially reshape the curriculum
  around it
- **Recognize when to adopt a framework** — if the hand-built ECS is becoming
  a maintenance burden, suggest migration to hecs/bevy_ecs at the right
  moment

---

## 4. Curated Resources

### Core Rust Learning

| Resource | Type | Level | Free? | Why it's here |
|----------|------|-------|-------|---------------|
| [The Rust Programming Language](https://doc.rust-lang.org/book/) | Book | Beginner | Yes | The canonical reference. Read selectively — skim familiar concepts, slow down on ownership/lifetimes. |
| [Rust by Example](https://doc.rust-lang.org/rust-by-example/) | Interactive | Beginner | Yes | Quick reference for syntax and patterns. Good complement to the Book. |
| [Rustlings](https://github.com/rust-lang/rustlings) | Exercises | Beginner | Yes | Small exercises to practice syntax. Good for the first few sessions, then outgrown. |
| [Comprehensive Rust (Google)](https://google.github.io/comprehensive-rust/) | Course | All | Yes | Developed at Google. Fast-paced, covers the language in ~4 days. Good for accelerated learners. |
| [Rust for Rustaceans](https://rust-for-rustaceans.com/) (Jon Gjengset) | Book | Intermediate+ | No | The best "next step" after basics. Covers type layout, trait coherence, unsafe, async internals. Dense and excellent. |
| [Programming Rust, 2nd Ed](https://www.oreilly.com/library/view/programming-rust-2nd/9781492052586/) (Blandy, Orendorff, Tindall) | Book | Intermediate | No | Comprehensive, well-written. Good for C++ programmers — explains things at a systems level. |
| [Effective Rust](https://www.lurklurk.org/effective-rust/) | Book | Intermediate | Online free | Short, dense, opinionated. 35 specific recommendations for idiomatic Rust. |
| [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/) | Reference | Intermediate | Yes | How to design good Rust APIs. Useful when designing pond's public interfaces. |

### Game Development & ECS

| Resource | Type | Level | Free? | Why it's here |
|----------|------|-------|-------|---------------|
| [Roguelike Tutorial in Rust](https://bfnightly.bracketproductions.com/) | Tutorial | Beginner | Yes | Complete roguelike in Rust using bracket-lib. Directly relevant to pond's genre. |
| [Hands-on Rust](https://pragprog.com/titles/hwrust/hands-on-rust/) (Herbert Wolverson) | Book | Beginner | No | Project-based Rust learning through game development. Companion to the roguelike tutorial. |
| [Bevy Engine](https://bevyengine.org/) | Engine | All | Yes | The most active Rust game engine. ECS-first design. We'll build our own ECS first, then potentially adopt Bevy. |
| [Writing a Tiny ECS in Rust](https://ianjk.com/ecs-in-rust/) | Tutorial | Intermediate | Yes | Short, clear tutorial on building an ECS from scratch. |
| [Building an ECS — Deep Dive](https://medium.com/@jordangrilly/what-is-an-ecs-and-why-rust-a-deep-dive-into-data-oriented-game-engine-design-887680a5583a) | Article | Intermediate | Yes | Deep dive into ECS design decisions in Rust (2026). |
| [bracket-lib](https://github.com/amethyst/bracket-lib) | Library | All | Yes | Roguelike toolkit with pathfinding (A*, Dijkstra), noise, terminal rendering. |

### AI & Simulation

| Resource | Type | Level | Free? | Why it's here |
|----------|------|-------|-------|---------------|
| [krABMaga](https://github.com/krABMaga/krABMaga) | Framework | Intermediate | Yes | Agent-based model simulation engine in Rust. Reference implementation. |
| [rust-agent-based-models](https://github.com/facorread/rust-agent-based-models) | Example | Intermediate | Yes | Example ABMs in Rust. Good for patterns. |
| [rust-agent-simulation-engine](https://github.com/liana-p/rust-agent-simulation-engine) | Example | Intermediate | Yes | Agent simulation engine. Reference architecture. |
| [AI for Games](https://www.amazon.com/AI-Games-Third-Ian-Millington/dp/0367670569) (Millington) | Book | All | No | The comprehensive reference for game AI: behavior trees, FSM, utility AI, planning, steering. Language-agnostic. |
| [Burn](https://burn.dev/) | ML Framework | Intermediate | Yes | Pure Rust ML framework. Modular backends (CPU, GPU, WASM). Best for native Rust ML. |
| [Candle](https://github.com/huggingface/candle) | ML Framework | Intermediate | Yes | Hugging Face's minimalist Rust ML framework. Lightweight, good for inference. |
| [tch-rs](https://github.com/LaurentMazare/tch-rs) | ML Bindings | Intermediate | Yes | Rust bindings for PyTorch. Heaviest dependency but most mature. |

### Advanced Rust

| Resource | Type | Level | Free? | Why it's here |
|----------|------|-------|-------|---------------|
| [The Rustonomicon](https://doc.rust-lang.org/nomicon/) | Book | Advanced | Yes | The dark arts of unsafe Rust. Required reading before writing unsafe. |
| [Rust Atomics and Locks](https://marabos.nl/atomics/) (Mara Bos) | Book | Advanced | Online free | The concurrency book. Deep dive into atomics, memory ordering, lock implementations. |
| [Asynchronous Programming in Rust](https://rust-lang.github.io/async-book/) | Book | Intermediate | Yes | Official async book. Covers futures, runtimes, patterns. |
| [The Little Book of Rust Macros](https://veykril.github.io/tlborm/) | Book | Intermediate | Yes | Comprehensive macro tutorial. Both declarative and procedural. |
| [Jon Gjengset's YouTube](https://www.youtube.com/@jonhoo) | Videos | Advanced | Yes | Deep-dive Rust streams. Implementing data structures, understanding internals. |
| [Crust of Rust](https://www.youtube.com/playlist?list=PLqbS7AVVErFiWDOAVrPt7aYmnuuOLYvOa) (Jon Gjengset) | Video Series | Intermediate+ | Yes | Focused topic deep-dives: iterators, smart pointers, channels, lifetimes, etc. Excellent. |

### Tools & Ecosystem

| Resource | Type | Why it's here |
|----------|------|---------------|
| [rustup](https://rustup.rs/) | Toolchain manager | Install and manage Rust versions |
| [cargo](https://doc.rust-lang.org/cargo/) | Build system | The build system. Learn it well. |
| [clippy](https://github.com/rust-lang/rust-clippy) | Linter | Catches common mistakes, teaches idioms |
| [rust-analyzer](https://rust-analyzer.github.io/) | LSP | IDE support. Will be relevant if/when using an editor alongside Claude. |
| [criterion](https://github.com/bheisler/criterion.rs) | Benchmarking | Statistical benchmarking framework |
| [cargo-flamegraph](https://github.com/flamegraph-rs/flamegraph) | Profiling | Performance profiling |
| [serde](https://serde.rs/) | Serialization | The serialization framework. Will be used heavily. |
| [rayon](https://github.com/rayon-rs/rayon) | Parallelism | Data parallelism library. Parallel iterators. |

---

## 5. Progress Log

### Template

```
### Session N — [Date]
**Module:** [module ID and name]
**Duration:** [approximate]
**Covered:**
- [topic 1]
- [topic 2]

**Key Insights:**
- [insight or "aha" moment]

**Exercises:**
- [exercise]: [status: completed / in-progress / skipped]

**Checkpoint:** [pass / partial / deferred]

**Notes Created:**
- [path to any typst notes created]

**Code Written:**
- [key files/modules created or modified]

**Curriculum Adaptations:**
- [any changes to the plan based on this session]

**Next Session:**
- [what to pick up, any prep]
```

### Session 1 — 2026-03-01
**Module:** 0.1 — Environment & First Contact (in progress)
**Duration:** ~30 min
**Covered:**
- Installed Rust 1.93.1 via rustup
- Cargo project structure: `cargo new`, `Cargo.toml`, `src/main.rs`
- Binary vs library crates (`main.rs` vs `lib.rs`)
- Build profiles: `target/debug/` vs `target/release/`
- Wrote first real code: a grid world with `make_tile` and `tile_symbol`
- Introduced: `let`/`let mut`, `Vec`, `for`/ranges, expression-based returns,
  `match`, `usize`, `println!` macro, format string interpolation

**Key Insights:**
- Learner asks good "why" questions (target dir naming, debug symbols, binary
  vs library distinction) — confirm theory-first calibration is right
- Prefers to run generative commands themselves (`cargo new`) — let them drive
  creation, Claude can run read/inspection commands freely

**Exercises:**
- Grid world code written, not yet run by learner: in-progress

**Checkpoint:** Deferred to next session — learner reviewing code independently

**Notes Created:**
- `notes/0.1-first-contact/main.pdf` — review guide for the five key Rust
  concepts in the grid code

**Code Written:**
- `pond/src/main.rs` — 10x8 tile grid with border/water/grass generation

**Curriculum Adaptations:**
- None yet

**Next Session:**
- Run the grid code, discuss output
- Dig into the five Rust concepts from the review note
- Add a dependency (`rand`) for randomized world generation
- Potentially begin Module 1.1 (ownership) if 0.1 wraps up quickly

---

## 6. Reference Material

### Rust Concept Dependency Graph

```
Variables, Types, Functions
    │
    ▼
Ownership & Borrowing ◄──── (C++ RAII analogy, but different)
    │
    ├──► Lifetimes
    │
    ▼
Structs & Enums ◄──── (Haskell ADTs analogy)
    │
    ▼
Traits & Generics ◄──── (Haskell typeclasses analogy, but coherence)
    │
    ├──► Static vs Dynamic Dispatch
    │
    ▼
Error Handling (Result, ?)
    │
    ▼
Iterators & Closures ◄──── (Fn/FnMut/FnOnce tied to ownership)
    │
    ▼
Smart Pointers ◄──── (Interior mutability, Rc, Arc)
    │
    ├──► Concurrency (Send, Sync, Arc<Mutex<T>>)
    │
    ▼
Modules & Crate Design
    │
    ▼
Collections & Data Structures
    │
    ▼
ECS Pattern ◄──── (Combines: generics, traits, collections, ownership)
    │
    ▼
[Advanced topics branch independently]
    ├── Macros
    ├── Unsafe & FFI
    ├── Async
    └── Advanced Type Patterns
```

### ECS Architecture Overview

```
Entity:     Just an ID (u32 + generation counter)
            No data, no behavior — just identity.

Component:  Pure data. Structs with no behavior.
            Stored contiguously by type for cache efficiency.
            Examples: Position, Velocity, Health, Hunger, Brain

System:     Pure logic. Functions that operate on entities
            with specific component combinations.
            Examples: MovementSystem, HungerSystem, AISystem

World:      The container. Stores all entity-component mappings.
            Dispatches systems each tick.
```

### pond Architecture Vision

```
┌─────────────────────────────────────────────┐
│                  pond-cli                     │
│  (binary: rendering, input, game loop)       │
├─────────────────────────────────────────────┤
│                  pond (lib)                   │
│  ┌───────────┐  ┌───────────┐  ┌──────────┐ │
│  │   World   │  │  Systems  │  │    AI    │ │
│  │ - ECS     │  │ - Move    │  │ - FSM    │ │
│  │ - Tiles   │  │ - Hunger  │  │ - BTree  │ │
│  │ - Spatial │  │ - Spawn   │  │ - Utility│ │
│  │ - Events  │  │ - Death   │  │ - Neural │ │
│  └───────────┘  └───────────┘  └──────────┘ │
│  ┌───────────┐  ┌───────────┐  ┌──────────┐ │
│  │  WorldGen │  │   Data    │  │  Serial  │ │
│  │ - Noise   │  │ - Species │  │ - Save   │ │
│  │ - Caves   │  │ - Items   │  │ - Load   │ │
│  │ - Biomes  │  │ - Config  │  │ - Export │ │
│  └───────────┘  └───────────┘  └──────────┘ │
└─────────────────────────────────────────────┘
```

---

## 7. Session Starters

Copy-paste these prompts to begin different types of sessions.

### First Session
```
I'm starting my Rust learning course. Read LEARNING_PLAN.md (especially the
Session Protocol and Progress Log) and let's begin with Module 0.1 —
setting up the environment and getting our first Rust code running. The
project is called "pond."
```

### Continuing from Last Session
```
Let's continue the Rust course. Read LEARNING_PLAN.md and check the Progress
Log for where we left off. Pick up from there.
```

### Deep-Dive on a Topic
```
I want to do a deep-dive session on [TOPIC]. Read LEARNING_PLAN.md for
context on my background and preferences, then let's explore [TOPIC] in
depth. Connect it to the pond project where relevant.
```

### Exercise / Practice Session
```
I want a practice session. Read LEARNING_PLAN.md and the Progress Log, then
give me exercises on the material I've covered so far. Focus on areas where
my checkpoint results were weakest.
```

### Quick Question
```
Quick question (no need to do a full session): [QUESTION]
```

### Synthesis Session
```
Let's do a synthesis session. Read LEARNING_PLAN.md and all notes/session
artifacts, then help me discover connections between the topics I've studied
so far. Build exercises that force those connections to surface.
```
