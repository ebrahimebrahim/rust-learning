use rand::RngExt;

fn main() {
    let width = 10;
    let height = 8;

    // Create a flat grid of tiles
    // Vec<T> is Rust's growable array — like std::vector<T> in C++
    let mut grid = Vec::new();

    for y in 0..height {
        for x in 0..width {
            let tile = make_tile(x, y);
            grid.push(tile);
        }
    }

    // Display the world
    for y in 0..height {
        for x in 0..width {
            let index = y * width + x;
            let symbol = tile_symbol(grid[index]);
            print!("{symbol}");
        }
        println!();
    }

    println!("\nPond world: {width}x{height}, {} tiles", grid.len());
}

// Tiles are just integers for now — we'll replace this with proper types
// in the next module. 0 = water, 1 = grass, 2 = rock
fn make_tile(x: usize, y: usize) -> u8 {
    let mut rng = rand::rng();
    // This is an expression — the last expression in a block is
    // its return value (no semicolon). No `return` keyword needed.
    if x == 0 || x == 9 || y == 0 || y == 7 {
        2 // rock border
    } else {
        rng.random_range(0..=1) // 0 for water or 1 for grass
    }
}

fn tile_symbol(tile: u8) -> char {
    // `match` is exhaustive pattern matching — like Haskell's case
    // The compiler forces you to handle every possible value.
    // The _ arm is the wildcard (catch-all).
    match tile {
        0 => '~',
        1 => '.',
        2 => '#',
        _ => '?',
    }
}
