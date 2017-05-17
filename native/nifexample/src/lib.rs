#[macro_use] extern crate rustler;
#[macro_use] extern crate rustler_codegen;
#[macro_use] extern crate lazy_static;

use rustler::{NifEnv, NifTerm, NifResult, NifDecoder, NifEncoder};
use rustler::types::map::NifMapIterator;
use rustler::types::atom::NifAtom;

mod atoms {
    rustler_atoms! {
        atom ok;
        //atom error;
        //atom __true__ = "true";
        //atom __false__ = "false";
    }
}

rustler_export_nifs! {
    "Elixir.NifExample",
    [("add", 2, add),
     ("printTuple", 1, print_tuple),
     ("printMap",1, print_map)],
    None
}

fn add<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    let num1: i64 = try!(args[0].decode());
    let num2: i64 = try!(args[1].decode());

    Ok((atoms::ok(), num1 + num2).encode(env))
}

fn print_tuple<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    //The types must be known beforehand to decode a tuple. The Turbofish is used here to set the types
    let tuple = (args[0]).decode::<(NifAtom, f64, i64, String)>()?; //Note that "?" is used here instead of "try!"
    println!("Atom: {:?}, Float: {}, Integer: {}, String: {}", tuple.0, tuple.1, tuple.2, tuple.3);
    Ok((atoms::ok().encode(env)))
}

fn print_map<'a>(env: NifEnv<'a>, args: &[NifTerm<'a>]) -> NifResult<NifTerm<'a>> {
    //Maps can use the built-in NifMapIterator which makes iterating over the entries simple
    let mut map = NifMapIterator::new(args[0]).expect("Should be a map in the argument");
    for x in map {
        println!("{:?}", x); //Doing more here will likely require matching and knowledge of types in the map
    }
    Ok((atoms::ok().encode(env)))
}