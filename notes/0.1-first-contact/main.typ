#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header("First Contact — What to Notice", module: "0.1", date: "2026-03-01")

Review notes for `pond/src/main.rs`. Five things that distinguish Rust from
what you already know.

= 1. Immutable by default: `let` vs `let mut`

```rust
let width = 10;       // immutable — cannot reassign
let mut grid = Vec::new();  // mutable — can push, reassign, etc.
```

Variables are immutable unless you opt into mutability with `mut`. This is the
opposite default from C/C++ and the same default as Haskell's `let`. The
compiler will error if you mutate something without `mut`, or if you declare
`mut` and never actually mutate (a warning, not an error — but Rust is chatty
about unused things).

= 2. Ranges are objects, not syntax

```rust
for y in 0..height { ... }
```

`0..height` is a half-open range $[0, "height")$. Also available:
`0..=height` for closed $[0, "height"]$. These aren't special syntax — they're
actual structs (`Range<usize>`, `RangeInclusive<usize>`) that implement the
`Iterator` trait. You can call `.map()`, `.filter()`, etc. on them directly.

= 3. Expression-based returns

```rust
fn make_tile(x: usize, y: usize) -> u8 {
    if x == 0 || x == 9 || y == 0 || y == 7 {
        2   // <-- no semicolon: this is the return value
    } else if (x + y) % 3 == 0 {
        0
    } else {
        1
    }
}
```

#insight[
  The last expression in a block is its value. No `return` keyword needed.
  Adding a semicolon turns an expression into a statement (returning `()`,
  Rust's unit type). This is a common gotcha early on — if the compiler
  complains about a type mismatch involving `()`, check for a stray semicolon.
]

`if`/`else` is an expression, not a statement — just like in Haskell.
You can write `let x = if cond { a } else { b };` and it works.
Both branches must have the same type — the compiler enforces this.

= 4. `usize` — the indexing type

`usize` is an unsigned integer the size of a pointer (64 bits on your
machine). Rust requires it for all collection indexing — you can't index a
`Vec` with `i32` or `u32`. This is deliberate: no accidental negative
indexing, no truncation on 64-bit systems. You'll see `usize` everywhere.

= 5. `match` is exhaustive

```rust
match tile {
    0 => '~',
    1 => '.',
    2 => '#',
    _ => '?',  // wildcard — must handle every possible u8 value
}
```

Like Haskell's `case`, the compiler forces you to cover every possible value.
The `_` wildcard is the catch-all. If you match on an enum instead of a `u8`,
the compiler knows exactly which variants exist and will error if you miss
one — no wildcard needed. We'll see this in Module 1.2 when we replace these
magic integers with proper types.

= Bonus: `println!` is a macro

The `!` in `println!` means it's a macro invocation, not a function call.
Rust doesn't have variadic functions (no `...` args like C's `printf`), so
format strings are handled by macros that expand at compile time. The compiler
actually type-checks your format strings — `println!("{}", x)` where `x`
doesn't implement `Display` is a compile error, not a runtime one.

The inline syntax `{symbol}` inside the string is a recent convenience
(captured identifiers in format strings). Older Rust code uses positional
style: `println!("{}", symbol)`.
