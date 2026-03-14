use rand::RngExt;

#[derive(Clone, Copy)]
enum Terrain {
    Water,
    Grass,
    Rock,
}

enum ResourceKind {
    Apple,
    Berry,
}

enum Entity {
    Creature {name:String, hunger: u32},
    Resource {kind: ResourceKind, amount: u32},
}

struct Tile {
    terrain: Terrain,
    entity: Option<Entity>,
}



fn main() {
    let width = 10;
    let height = 8;

    let grid = create_world(width, height);

    display_world(&grid, width, height);

    println!("\nPond world: {width}x{height}, {} tiles", grid.len());
}

fn make_terrain(x: usize, y: usize) -> Terrain {
    let mut rng = rand::rng();
    if x == 0 || x == 9 || y == 0 || y == 7 {
        Terrain::Rock
    } else {
        if rng.random_bool(0.15) {Terrain::Water} else {Terrain::Grass}
    }
}

fn populate_tile(terrain : Terrain) -> Tile {
    let mut rng = rand::rng();
    match terrain {
        Terrain::Rock => Tile { terrain:terrain, entity: None },
        Terrain::Water => Tile { terrain:terrain, entity: None },
        Terrain::Grass => Tile {
            terrain:terrain,
            entity: if rng.random_bool(0.9) {None} else {
                Some(
                    if rng.random_bool(0.5) {
                        Entity::Creature { name: String::from("Bob"), hunger: 0 }
                    } else {
                        Entity::Resource {
                            kind: if rng.random_bool(0.5) {ResourceKind::Apple} else {ResourceKind::Berry},
                            amount: rng.random_range(1..=5),
                        }
                    }
                )
            }
        },
    }
}

fn terrain_symbol(terrain: Terrain) -> char {
    match terrain {
        Terrain::Rock => '#',
        Terrain::Water => '~',
        Terrain::Grass => '.',
    }
}

fn entity_symbol(entity : &Entity) -> char {
    match entity {
        Entity::Creature {..} => '@', 
        Entity::Resource { kind:ResourceKind::Apple, .. } => 'a',
        Entity::Resource { kind:ResourceKind::Berry, .. } => 'b',
    }
}

fn tile_symbol(tile:&Tile) -> char {
    match &tile.entity {
        None => terrain_symbol(tile.terrain),
        Some(entity) => entity_symbol(entity)
    }
}

fn create_world(width: usize, height: usize) -> Vec<Tile> {
    let mut grid = Vec::new();

    for y in 0..height {
        for x in 0..width {
            let tile = populate_tile(make_terrain(x, y));
            grid.push(tile);
        }
    }
    grid
}

fn display_world(grid: &[Tile], width: usize, height: usize) {
    for y in 0..height {
        for x in 0..width {
            let index = y * width + x;
            let symbol = tile_symbol(&grid[index]);
            print!("{symbol}");
        }
        println!();
    }
}