use rand::RngExt;
use std::fmt;

#[derive(Clone, Copy, Debug)]
enum Terrain {
    Water,
    Grass,
    Rock,
}

#[derive(Clone, Copy, Debug)]
enum ResourceKind {
    Apple,
    Berry,
}

#[derive(Debug)]
enum Entity {
    Creature {name:String, hunger: u32},
    Resource {kind: ResourceKind, amount: u32},
}

#[derive(Debug)]
struct Tile {
    terrain: Terrain,
    entity: Option<Entity>,
}

trait Symbol {
    fn symbol(&self) -> char;
}

#[derive(Debug)]
enum WorldError {
    ZeroDimensions,
    TooManyTiles {total: usize},
}

impl fmt::Display for WorldError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match self {
            WorldError::ZeroDimensions => {
                write!(f, "World dimensions cannot be zero.")
            }
            WorldError::TooManyTiles { total } => {
                write!(f, "World has too many tiles: {}. Maximum allowed is 10000.", total)
            }
        }
    }
}

fn main() {
    let width = 10;
    let height = 8;

    let grid = create_world(width, height).expect("Hard coded dimensions should be valid");

    display_world(&grid, width, height);

    println!("\nPond world: {width}x{height}, {} tiles", grid.len());

    println!("Example tile (debug): {:?}", grid[12]);

    println!("Example terrain (display): {}", grid[12].terrain);
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

impl Symbol for Terrain {
    fn symbol(&self) -> char {
        match self {
            Terrain::Rock => '#',
            Terrain::Water => '~',
            Terrain::Grass => '.',
        }
    }
}

impl Symbol for ResourceKind {
    fn symbol(&self) -> char {
        match self {
            ResourceKind::Apple => 'a',
            ResourceKind::Berry => 'b',
        }
    }
}

impl Symbol for Entity {
    fn symbol(&self) -> char {
        match self {
            Entity::Creature {..} => '@', 
            Entity::Resource { kind, .. } => kind.symbol(),
        }
    }
}

impl Symbol for Tile {
    fn symbol(&self) -> char {
        match &self.entity {
            None => self.terrain.symbol(),
            Some(entity) => entity.symbol(),
        }
    }
}

impl fmt::Display for Terrain {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{}", self.symbol())
    }
}

fn create_world(width: usize, height: usize) -> Result<Vec<Tile>, WorldError> {
    if width == 0 || height == 0 {
        return Err(WorldError::ZeroDimensions);
    }
    let total_tiles = width * height;
    if total_tiles > 10000 {
        return Err(WorldError::TooManyTiles { total: total_tiles });
    }
    
    let mut grid = Vec::with_capacity(total_tiles);

    for y in 0..height {
        for x in 0..width {
            let tile = populate_tile(make_terrain(x, y));
            grid.push(tile);
        }
    }
    Ok(grid)
}

fn display_world(grid: &[Tile], width: usize, height: usize) {
    for y in 0..height {
        for x in 0..width {
            let index = y * width + x;
            let symbol = grid[index].symbol();
            print!("{symbol}");
        }
        println!();
    }
}