#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header(
  [impl, derive, and Traits],
  module: "1.2/1.3",
  date: "Session 4 — 2026-03-15",
)

= `impl` Blocks — Two Forms

#code-block("// Inherent impl: functions that belong to a type
impl Terrain {
    fn symbol(&self) -> char { ... }  // method
    fn new() -> Terrain { ... }       // associated function
}

// Trait impl: this type satisfies a contract
impl Symbol for Terrain {
    fn symbol(&self) -> char { ... }
}")

- *Methods* take `self` / `&self` / `&mut self` -- called with dot syntax: `tile.symbol()`
- *Associated functions* have no `self` -- called with `::` syntax: `Tile::new()`
- `&self` is sugar for `self: &Self`, where `Self` = the type being impl'd

= Auto-referencing (Dot Operator)

When you call `x.method()`, the compiler automatically inserts `&`, `&mut`, or dereferences `x` to match the method signature. So `grid[index].symbol()` works even though `symbol` expects `&self`.

This *only* applies to the dot operator -- free function calls require explicit `&`.

#callout(title: "Why only dot?")[
  The dot operator has a single receiver type to anchor resolution on. Free functions don't have that anchor, so auto-ref would require speculatively checking multiple signatures with no clear priority.
]

= Match Ergonomics

When matching a reference (`&T`) against a value pattern (`T`), the compiler auto-dereferences. So `match self { Terrain::Rock => ... }` works even when `self: &Terrain`.

= `\#[derive]` -- Compiler-Generated Trait Impls

`#[derive(Trait)]` generates `impl Trait for Type` mechanically, applying the trait to each field.

#table(
  columns: (1fr, 2fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Trait*], [*What it gives you*],
  [`Debug`], [`{:?}` formatting -- near-universal],
  [`Clone`], [`.clone()` deep copy],
  [`Copy`], [Implicit bitwise copy on assignment (requires `Clone`)],
  [`PartialEq`], [`==` and `!=` operators],
)

#insight[
  Derive is recursive: all fields must implement the trait. `String` implements `Debug` but not `Copy` (heap-allocated), so `#[derive(Copy)]` on a type containing `String` fails.
]

= Traits

A trait is a contract: "any type implementing this must provide these functions."

#code-block("trait Symbol {
    fn symbol(&self) -> char;
}

impl Symbol for Terrain {
    fn symbol(&self) -> char {
        match self {
            Terrain::Rock => '#',
            // ...
        }
    }
}")

- Analogous to Haskell typeclasses, but *nominal* (must explicitly write `impl Trait for Type` -- having matching methods isn't enough)
- The trait signature is a strict contract -- impls must match exactly

= Generics and Trait Bounds

#code-block("// These two are equivalent:
fn print_symbol(item: &impl Symbol) { ... }
fn print_symbol<T: Symbol>(item: &T) { ... }")

*Monomorphization:* the compiler generates a specialized copy for each concrete type. Static dispatch, zero runtime cost. (Contrast: Haskell uses dictionary passing by default.)

= Blanket Impls and the Orphan Rule

#code-block("// Blanket impl: implement TraitB for all types that have TraitA
impl<T: Display> ToString for T { ... }  // in std")

You can write blanket impls when *your crate owns the trait being implemented*. The *orphan rule* prevents implementing a foreign trait for a generic type:

#code-block("// Rejected: Display is foreign, T could be anything
impl<T: Symbol> fmt::Display for T { ... }")

#callout(title: "Orphan Rule")[
  You can write `impl Trait for Type` only if your crate defines either `Trait` or `Type`. This prevents conflicting implementations across crates -- Rust's answer to Haskell's orphan instance problem.
]

= `Display` vs `Debug`

- `Debug` (`{:?}`) -- derivable, for developer/diagnostic output
- `Display` (`{}`) -- must be hand-written, for user-facing output

#code-block("use std::fmt;

impl fmt::Display for Terrain {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, \"{}\", match self {
            Terrain::Rock => \"Rock\",
            Terrain::Water => \"Water\",
            Terrain::Grass => \"Grass\",
        })
    }
}")

= Still Ahead

- Default methods in traits (methods with a body that impls can override)
- Supertraits: `trait A: B` -- A requires B
- `dyn Trait` -- dynamic dispatch (trait objects, vtables)
- Operator overloading via std traits (`Add`, `Index`, etc.)
