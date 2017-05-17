
use std::env;

pub fn main() {
    for argument in env::args() {
        println!("argument: {:?}", argument)
    }
}