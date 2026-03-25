#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header(
  [Iterators and Closures],
  module: "1.5",
  date: "Session 8 — 2026-03-24",
)

= The `Iterator` Trait

One required method, everything else is built on top:

#code-block("trait Iterator {
    type Item;                          // associated type — implementor chooses
    fn next(&mut self) -> Option<Self::Item>;  // Some(item) or None (exhausted)
}")

- `&mut self` — iterators are stateful cursors, not pure values
- `Option` signals exhaustion — no separate `hasNext()`/`next()` pair
- `type Item` — associated type, fixed per implementation (not chosen by caller)

= Associated Types vs Generics

Associated types are chosen by the *implementor*, not the caller:

#code-block("impl Iterator for GridIter {
    type Item = Tile;  // fixed — GridIter always yields Tiles
}")

A generic parameter `trait Iterator<Item>` would let one type implement the trait multiple times with different items. The associated type version enforces exactly one implementation per type.

Haskell analogy: associated types = type families inside a typeclass. Generic trait parameters = multi-parameter typeclasses.

= Bounded Associated Types

Associated types can carry trait bounds — constraints on the implementor's choice:

#code-block("trait IntoIterator {
    type Item;
    type IntoIter: Iterator<Item = Self::Item>;  // must be an Iterator
    fn into_iter(self) -> Self::IntoIter;        // with matching Item
}")

`Self` in a trait definition = "the type implementing this trait." You already know it from `&self` being sugar for `self: &Self`.

= `IntoIterator` and `for` Loops

`for` loops desugar to `IntoIterator`:

#code-block("for tile in &grid { ... }

// becomes (roughly):
let mut iter = (&grid).into_iter();
while let Some(tile) = iter.next() { ... }")

`Vec<T>` implements `IntoIterator` three ways:

#table(
  columns: (1.5fr, 1.5fr, 1fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Call*], [*Yields*], [*Consumes?*],
  [`vec.into_iter()`], [owned `T`], [Yes],
  [`(&vec).into_iter()`], [`&T`], [No],
  [`(&mut vec).into_iter()`], [`&mut T`], [No],
)

Every `Iterator` automatically implements `IntoIterator` via a blanket impl (returns itself). So iterators work directly in `for` loops.

= Lazy Adapters and Consumers

Adapters (`.filter()`, `.map()`) return new iterator structs — no work happens. Consumers (`.sum()`, `.collect()`, `.count()`) drive the chain by calling `next()` repeatedly.

#code-block("let result: i32 = numbers.iter()
    .filter(|n| **n % 2 == 0)
    .map(|n| n * n)
    .sum();  // <— consumer drives everything")

= `filter`'s Double Reference

`.iter()` on `Vec<i32>` yields `&i32`. But `filter` passes `&Item` to its predicate (it needs to keep items to yield later), so the closure gets `&&i32`.

Operators don't auto-deref through multiple levels (unlike method calls, which chain arbitrarily). So `**n % 2` or pattern destructuring `|&&n| n % 2` is needed.

#insight[
  Method calls use a multi-step deref search (`T`, `&T`, `*T`, `**T`...). Operators just look for a direct trait impl — no deref chain. That's why `&&i32 % 2` fails but `(&&i32).some_method()` could work.
]

= Closures

Anonymous functions that capture variables from their environment:

#code-block("|x| x * 2            // one arg, expression body
|x, y| x + y         // two args
|x| { ...; expr }    // block body")

The name "closure" comes from lambda calculus: a lambda with free variables is "open"; capturing those variables from the environment *closes* it.

= Capture Modes

The compiler infers the *least restrictive* capture mode:

#table(
  columns: (1fr, 2fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Mode*], [*When*],
  [`&T` (immutable borrow)], [Closure only reads the variable],
  [`&mut T` (mutable borrow)], [Closure modifies the variable],
  [Move (ownership)], [Closure consumes or needs to own the variable],
)

#code-block("let mut count = 0;
let mut inc = || { count += 1; };  // captures &mut count
inc(); inc();
println!(\"{count}\");  // still works — count was borrowed, not moved")

The `move` keyword forces ownership capture regardless of what the body does:

#code-block("let name = String::from(\"Bob\");
let greet = move || println!(\"Hello, {name}\");
// name is now moved into the closure — can't use it here")

Essential when closures outlive their creating scope (e.g., thread spawning).

= The Three Closure Traits

The compiler generates a hidden struct for each closure (captured variables = fields). The trait determines how the call method receives that struct:

#table(
  columns: (1fr, 1fr, 2fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Trait*], [*Receives*], [*Meaning*],
  [`Fn`], [`&self`], [Read-only captures, call many times],
  [`FnMut`], [`&mut self`], [May mutate captures, call many times],
  [`FnOnce`], [`self`], [May consume captures, call only once],
)

Hierarchy: `Fn` #sym.subset `FnMut` #sym.subset `FnOnce` — every `Fn` is also `FnMut` is also `FnOnce`.

The compiler infers which trait a closure implements from what it does with captures:
- Only reads → `Fn`
- Mutates → `FnMut`
- Consumes (e.g., `drop`) → `FnOnce`

#callout(title: "Reading API signatures")[
  You rarely think about `Fn`/`FnMut`/`FnOnce` when *writing* closures — the compiler infers it. They matter when *reading* function signatures: `filter` takes `FnMut` (needs to call the predicate repeatedly), a one-shot callback might take `FnOnce`.
]
