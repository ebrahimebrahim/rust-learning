#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header(
  [impl, derive, and Traits],
  module: "1.2/1.3",
  date: "Sessions 4–5 — 2026-03-15/16",
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

= Default Methods

A trait can provide a method body -- impls get it for free, can override.

#code-block("trait Symbol {
    fn symbol(&self) -> char;

    fn label(&self) -> String {        // default method
        format!(\"[{}]\", self.symbol())  // can call other trait methods
    }
}")

Unlike Haskell, there's no `MINIMAL` pragma -- no formal way to declare which subset of methods constitutes a minimal complete definition.

= Supertraits

`trait A: B` means implementing `A` requires also implementing `B`. Inside `A`'s methods, you can call `B`'s methods on `self`.

#code-block("trait Describable: Symbol {
    fn describe(&self) -> String;
    // can call self.symbol() here -- compiler knows Symbol is implemented
}")

Stack with `+`: `trait A: B + C + Debug`. Same `+` syntax appears in trait bounds: `fn foo<T: Display + Clone>(x: &T)`.

This is interface inheritance only -- no data, no diamond problem.

= `dyn Trait` -- Dynamic Dispatch

Static dispatch (monomorphization) requires the compiler to know the concrete type. For heterogeneous collections, you need *type erasure*.

#code-block("let things: Vec<Box<dyn Symbol>> = vec![
    Box::new(Terrain::Water),
    Box::new(Entity::Creature { name: String::from(\"Bob\"), hunger: 0 }),
];
for thing in &things {
    println!(\"{}\", thing.symbol());  // dispatched via vtable
}")

`Box` and `dyn` solve two different problems:
- `Box` #sym.arrow.r uniform pointer size in the `Vec` (indirection to heap)
- `dyn` #sym.arrow.r type erasure (which implementation to call is resolved at runtime)

`Box<dyn Symbol>` is a *fat pointer*: `[ptr to data] + [ptr to vtable]`.

== Vtables

One vtable per (type, trait) pair. Each is a table of function pointers with a *fixed layout* per trait:

#code-block("vtable for \"Terrain as Symbol\":     vtable for \"Entity as Symbol\":
  symbol() -> ptr to Terrain::symbol   symbol() -> ptr to Entity::symbol")

Calling `thing.symbol()` = dereference vtable pointer, read function pointer at offset 0, call it. No type information needed at runtime -- the vtable pointer (set at construction time when the concrete type was known) is the only thing that selects the implementation.

Compared to C++: same mechanism as virtual methods, but opt-in (`dyn`) rather than default (`virtual`).

== Object Safety

A trait can be used with `dyn` only if the compiler can build a vtable. Things that break it:

#table(
  columns: (1fr, 2fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Violation*], [*Why*],
  [Method returns `Self`], [Caller can't allocate unknown-size return value],
  [Generic methods], [Would need infinite vtable entries (one per monomorphization)],
  [`Self: Sized` bound], [`dyn Trait` is unsized -- direct contradiction],
)

Rule of thumb: if every method takes `self` behind a reference and returns concrete types, it's object-safe.

= Operator Overloading

Operators desugar to trait method calls:

#table(
  columns: (1fr, 1fr, 1fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Syntax*], [*Desugars to*], [*Trait*],
  [`a + b`], [`a.add(b)`], [`std::ops::Add`],
  [`a == b`], [`a.eq(&b)`], [`std::cmp::PartialEq`],
  [`a[i]`], [`a.index(i)`], [`std::ops::Index`],
)

#code-block("use std::ops::Add;

impl Add for MyType {
    type Output = MyType;  // associated type: fixed per impl
    fn add(self, rhs: MyType) -> MyType { ... }
}")

`Add` is generic over the RHS: `impl Add<Vector> for Point` defines what `point + vector` means. Rust splits arithmetic into fine-grained traits (`Add`, `Sub`, `Mul`, ...) vs Haskell's bundled `Num`.
