
use std::io::{self, Write};

pub fn main() {
    let mut input = String::new();
    for i in 0..2 {
        match io::stdin().read_line(&mut input) {
            Ok(_) => {
                //note that print! instead of println! removes the newline
                print!("Received in Rust: {}", input.trim());
                let _ = io::stdout().flush();
            }
            Err(error) => {
                print!("error: {}", error);
                let _ = io::stdout().flush();
            },
        }
    }
}

