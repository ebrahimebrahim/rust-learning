fn main() {
    let name = String::from("Bob");
    let greet = move || println!("Hello, {name}");
    // name is now moved INTO the closure — can't use it here anymore
    greet();
    greet();
    println!("Goodbye, {name}");
}