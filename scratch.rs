fn main() {
    let mut a : String = String::from("Hello");
    let r1 = &mut a;
    let r2 = &mut a;
    add_world(r2);
    println!("{a}");
}

fn add_world(s : &mut String) {
    s.push_str(", world!");
}

