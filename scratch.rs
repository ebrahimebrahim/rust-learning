use std::fmt;

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
    let grid = create_world(0, 10);
    match grid {
        Ok(grid) => {
            println!("{:?}", grid);
        }
        Err(e) => {
            eprintln!("Error creating world: {}", e);
        }
    }
}

fn create_world(width: usize, height: usize) -> Result<Vec<char>, WorldError> {
    let num_tiles = validate_dimensions(width, height)?;
    let mut grid = Vec::with_capacity(num_tiles);
    for y in 0..height {
        for x in 0..width {
            grid.push('.');
        }
    }
    Ok(grid)
}

fn validate_dimensions(width: usize, height: usize) -> Result<usize, WorldError> {
    if width == 0 || height == 0 {
        Err(WorldError::ZeroDimensions)
    } else {
        let num_tiles = width * height;
        if num_tiles > 10000 {
            Err(WorldError::TooManyTiles { total: num_tiles })
        } else {
            Ok(num_tiles)
        }
    }
}