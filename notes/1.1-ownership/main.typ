#import "../_preamble.typ": *
#set page(..note-page)
#set text(size: 11pt)

#note-header("Ownership & Borrowing", module: "1.1", date: "2026-03-08")

The ownership system is what makes Rust genuinely different from C++, Haskell,
and Python. It's not a convention — the compiler enforces it statically.

= The One Rule

Every value has exactly one owner. When the owner goes out of scope, the value
is dropped (freed). No garbage collector, no manual `free()`.

= Move by Default

Assignment _moves_ ownership. The source becomes invalid.

```rust
let a = String::from("hello");
let b = a;       // ownership moves from a to b
println!("{a}"); // ERROR: a is no longer valid
```

This is not C++ (which copies by default) or Python (which shares a reference).
Move means the original binding is dead — the compiler tracks this statically.

#insight[
  Move prevents double-free. A `String` is a stack triple (pointer, length,
  capacity) pointing at a heap buffer. If assignment copied the bits, two
  owners would free the same buffer. C++ solves this with copy constructors.
  Rust solves it by making the old binding invalid.
]

If you want a deep copy, say so explicitly:

```rust
let a = String::from("hello");
let b = a.clone();  // explicit deep copy
println!("{a}");    // fine — a still owns its data
```

= `Copy` Types: The Exception

Small, stack-only types implement the `Copy` trait. For these, assignment
copies the bits and the original stays valid.

```rust
let a: u8 = 42;
let b = a;       // copies the bits (u8 is Copy)
println!("{a}"); // fine
```

`Copy` types: integers, floats, `bool`, `char`, tuples of `Copy` types.

Not `Copy`: `String`, `Vec`, anything that manages heap memory.

= Borrowing: Using Without Owning

References let you access data without taking ownership.

```rust
fn print_it(s: &String) {  // borrows — does not own
    println!("{s}");
}

fn main() {
    let a = String::from("hello");
    print_it(&a);   // lend a reference
    print_it(&a);   // still valid — ownership never left
    println!("{a}"); // still ours
}
```

`&T` is a _shared reference_ — read-only, multiple allowed simultaneously.

If the function took `String` instead of `&String`, the first call would
move `a` in, and the second call would fail.

= Mutable References: `&mut T`

To modify borrowed data, use `&mut`:

```rust
fn add_world(s: &mut String) {
    s.push_str(", world!");
}

fn main() {
    let mut a = String::from("hello");
    add_world(&mut a);
    println!("{a}"); // "hello, world!"
}
```

Note the three `mut`s: `let mut a` (mutable binding), `&mut a` (mutable
reference), `s: &mut String` (parameter type is a mutable reference).

= The Central Law

#callout(title: "The Borrowing Rule")[
  At any point in time, you can have _either_:
  - any number of shared references (`&T`), _or_
  - exactly one mutable reference (`&mut T`)

  but never both simultaneously. The compiler enforces this at compile time.
]

```rust
let mut a = String::from("hello");
let r1 = &mut a;
let r2 = &mut a;        // ERROR: two &mut at once
println!("{r1} {r2}");
```

This single rule prevents data races, iterator invalidation, and
use-after-free — at compile time, not runtime.

= Non-Lexical Lifetimes (NLL)

Borrows end at their _last use_, not at the end of the scope. The compiler
is smart about this:

```rust
let mut a = String::from("hello");
let r1 = &mut a;
r1.push_str("!");   // r1's last use — borrow ends here
let r2 = &mut a;    // fine — r1 is done
r2.push_str("!");
println!("{a}");    // "hello!!"
```

= Two Different `mut`s

This is subtle. There are two distinct uses of `mut`:

/ Binding-level: `let mut x` — the variable `x` can be reassigned. Not part
  of the type.
/ Reference-level: `&mut T` — a mutable reference. This _is_ a distinct type
  from `&T`.

```rust
fn f(s: &String)      // s borrows a String (read-only)
fn f(s: &mut String)  // s borrows a String (read-write)
fn f(mut s: String)   // s owns a String, binding is reassignable
```

= When to Borrow vs. Pass by Value

- *Small `Copy` types* (`u8`, `i32`, `f64`, `bool`): pass by value. A
  reference is 64 bits — larger than the data itself.
- *Large or non-`Copy` types* (`String`, `Vec`, structs): borrow with `&` or
  `&mut` unless the function needs to take ownership.

= What's Next

- *Lifetimes*: what happens when a reference tries to outlive its owner?
  (Rule 4: borrows can't outlive the owner.)
- *Structs and enums*: replace the `u8` tiles with proper types, and feel
  ownership in a richer context.
