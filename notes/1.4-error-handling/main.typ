#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header(
  [Error Handling],
  module: "1.4",
  date: "Session 7 — 2026-03-22",
)

= `Result<T, E>` — Errors as Values

Rust has no exceptions. Fallible functions return `Result`:

#code-block("enum Result<T, E> {
    Ok(T),   // success with value
    Err(E),  // failure with error
}")

The error is in the type signature — the compiler won't let you ignore it. Analogous to Haskell's `Either a b` (`Left` = error, `Right` = success), but with explicit naming.

= The `?` Operator

Sugar for "unwrap or propagate":

#code-block("// These are equivalent:
let size = validate_dimensions(w, h)?;

let size = match validate_dimensions(w, h) {
    Ok(s) => s,
    Err(e) => return Err(e),
};")

`?` can only be used in functions that return `Result` (or `Option`). It's an early return — no hidden control flow, no stack unwinding.

`main` can return `Result<(), E>` if you want `?` at the top level. On `Err`, Rust prints the error via `Debug` and exits with code 1.

= Custom Error Types

`String` errors can't be matched programmatically. Use an enum:

#code-block("#[derive(Debug)]
enum WorldError {
    ZeroDimensions,
    TooManyTiles { total: usize },
}")

The caller can now match on specific failure modes, and the compiler checks exhaustiveness.

= `Display` and `std::error::Error`

The idiomatic error type implements three things:

#table(
  columns: (1fr, 2fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*Trait*], [*How*],
  [`Debug`], [Derive it — `#[derive(Debug)]`],
  [`Display`], [Hand-write — human-readable messages],
  [`Error`], [`impl Error for MyError {}` — requires `Display + Debug`],
)

#code-block("impl fmt::Display for WorldError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            WorldError::ZeroDimensions =>
                write!(f, \"World dimensions cannot be zero.\"),
            WorldError::TooManyTiles { total } =>
                write!(f, \"Too many tiles: {}. Max is 10000.\", total),
        }
    }
}")

Note: `main` returning `Err` prints via `Debug`, not `Display`. To get `Display` output, handle the error yourself with `eprintln!("{e}")`.

= `panic!` vs `Result`

#table(
  columns: (1fr, 1fr),
  stroke: 0.5pt + subtle,
  inset: 6pt,
  [*`panic!`*], [*`Result`*],
  [Bug — invariant violated], [Expected runtime failure],
  [Unrecoverable], [Caller decides how to handle],
  [Index out of bounds, broken logic], [Invalid input, file not found, network error],
)

= `unwrap` and `expect`

Both extract the inner value from `Ok`/`Some`, panicking on `Err`/`None`:

#code-block("let val = some_result.unwrap();        // panics with generic message
let val = some_result.expect(\"why\");   // panics with your message")

`.expect()` documents the assumption — why you believe this can't fail. Prefer it over `.unwrap()` in non-throwaway code.

#insight[
  The hierarchy for handling a `Result`:
  + *`?`* — propagate to caller
  + *match* — handle here
  + *`.expect(\"reason\")`* — assert infallibility, document why
  + *`.unwrap()`* — assert infallibility (fine in tests/prototypes)
]

= Library vs Application Code

#callout(title: "Design principle")[
  Library functions return `Result` — they report errors but never decide policy. Application code (`main`) decides: print and exit? Retry? Fall back? This separation keeps libraries composable.
]
