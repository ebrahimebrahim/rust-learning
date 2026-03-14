#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header("Structs, Enums & Pattern Matching", module: "1.2", date: "2026-03-14")

Rust has no classes or inheritance. Data is built from two primitives:
- *Structs* — product types (this AND that)
- *Enums* — sum types (this OR that)

This is closer to Haskell than C++. Where C++ would use an inheritance
hierarchy, Rust uses enums.

= Enums (Sum Types)

```rust
enum Terrain { Water, Grass, Rock }
```

This is `data Terrain = Water | Grass | Rock`. Each alternative is called a
_variant_. Variants are `PascalCase`, accessed via `Enum::Variant`.

Fieldless enums like `Terrain` are small (integer tag internally) and can be
`Copy`:

```rust
#[derive(Clone, Copy)]
enum Terrain { Water, Grass, Rock }
```

== Enums with Data

Variants can carry fields — inline anonymous structs:

```rust
enum Entity {
    Creature { name: String, hunger: u32 },
    Resource { kind: ResourceKind, amount: u32 },
}
```

The fields inside `Creature { ... }` are _not_ a standalone type — you can't
write `let c: Entity::Creature`. If you need the inner data as its own type
(to pass around, add methods to), extract it into a named struct:

```rust
struct Creature { name: String, hunger: u32 }
enum Entity {
    Creature(Creature),  // variant wrapping a named type
}
```

= Structs (Product Types)

```rust
struct Tile {
    terrain: Terrain,
    entity: Option<Entity>,
}
```

Fields are accessed with dot syntax: `tile.terrain`. No pattern matching
needed — a struct is always the same shape.

Construction uses `Type { field: value }` syntax:

```rust
let t = Tile { terrain: Terrain::Water, entity: None };
```

= `Option<T>` — Rust's `Maybe`

```rust
enum Option<T> {
    Some(T),
    None,
}
```

No null pointers in Rust. A value that might not exist is `Option<T>`.

#callout(title: "Gotcha")[
  `None` is capital-N. Lowercase `none` is treated as a variable name
  by the compiler.
]

= Pattern Matching

Exhaustive, like Haskell's `case`. The compiler forces you to handle every
variant — no missing cases.

```rust
match terrain {
    Terrain::Water => '~',
    Terrain::Grass => '.',
    Terrain::Rock => '#',
}
```

With a fieldless enum, no wildcard `_` is needed — three variants, three arms.
If you later add `Terrain::Sand`, the compiler errors everywhere you didn't
handle it.

== Ignoring Fields

When matching an enum with data but you don't need the fields, use `{ .. }`:

```rust
match entity {
    Entity::Creature { .. } => '@',
    Entity::Resource { .. } => ',',
}
```

Without `{ .. }`, the compiler thinks you're matching a fieldless variant.

== Nested Matching

You can match on inner variant fields directly:

```rust
Entity::Resource { kind: ResourceKind::Apple, .. } => 'a',
Entity::Resource { kind: ResourceKind::Berry, .. } => 'b',
```

== Matching `Option`

```rust
match &tile.entity {
    None => terrain_symbol(tile.terrain),
    Some(entity) => entity_symbol(entity),
}
```

Or when you only care about one case: `if let Some(e) = &tile.entity { ... }`

= `String` vs `&str`

#callout(title: "Gotcha")[
  `"hello"` is `&str` (a reference to read-only data baked into the binary).
  `String` is an owned, heap-allocated string. They are different types.

  To create a `String` from a literal: `String::from("hello")` or
  `"hello".to_string()`.

  This is ownership applied to strings: `String` owns its bytes, `&str`
  borrows them. Analogous to C++ `std::string` vs `const char*`.
]

= Can't Move Out of a Reference

#callout(title: "Gotcha")[
  If `tile` is `&Tile`, then `match tile.entity` tries to _move_ the entity
  out of borrowed data — the compiler rejects this.

  Fix: `match &tile.entity` — now you're matching on a reference, and
  `Some(entity)` binds `entity` as `&Entity`.
]

A shared reference gives read access, not ownership. You can look at the data
but can't take it.

= Slices: `&[T]`

A slice is a fat pointer: `(pointer, length)`. It refers to some contiguous
sequence of `T`s without knowing where they live.

`&[T]` is more general than `&Vec<T>` — any contiguous data, not just a
`Vec`. Prefer `&[T]` in function signatures. `Vec<T>` auto-coerces to `&[T]`
via `Deref` coercion.

= Item Declarations Don't Need Semicolons

`enum`, `struct`, `fn`, `impl` — anything with a `{}` body — no trailing
semicolon. Semicolons go on statements (`let` bindings, expression
statements).

= What's Next

- *`impl` blocks*: adding methods to types (`tile.symbol()` instead of
  `tile_symbol(&tile)`)
- *`#[derive(...)]`*: `Debug`, `PartialEq`, and when you can/can't derive
- *Traits*: shared behavior across different types
