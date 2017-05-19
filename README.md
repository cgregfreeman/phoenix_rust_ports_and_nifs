## This is an example project to show Elixir/Rust integration with NIFs and Ports. 
## This also takes place within the Phoenix Framework

This file has been created by doing the following:

```Shell
mix phoenix.new phoenix_rustler_integration
cd phoenix_rustler_integration
```

Modify the web/mix.exs file so that rustler is a dependency:
```Elixir
  defp deps do
    [
     {:rustler, "~> 0.9.0"},
     {:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"}
     ]
  end
```

Get rustler as a dependency and create an example project

```Shell
mix deps.get
mix rustler.new
Example
```
Create the elixir file in lib/ that will interface with the rustler Nif. Note that the @on_load line is commented out as it currently causes an elixir compilation error.

```Elixir
defmodule Example do
    use Rustler, otp_app: :phoenix_rustler_integration, crate: :example

#    @on_load :load_nif
    def load_nif do
        Rustler.load_nif("example")
    end

    # When your NIF is loaded, it will override this function.
    def add(_a, _b), do: throw :nif_not_loaded
end
```

Modify the web/mix.exs so that the :rustler term is included in the compilers list and the rustler crates are identified.
```Elixir
  def project do
    [app: :phoenix_rustler_integration,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:rustler, :phoenix, :gettext] ++ Mix.compilers,
     rustler_crates: rustler_crates(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PhoenixRustlerIntegration, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex]]
  end

  defp rustler_crates() do
    [example: [
      path: "native/example",
      mode: (if Mix.env == :prod, do: :release, else: :debug),
      ]]

  end
```
You should then be able to run iex -S mix and perform the following:
```Elixir
iex(1)> Example.add(1,1)
{:ok, 2}

```
More examples were added to show the basics of how to get information from Elixir in the form of Tuples and Maps.
These are the testTuple() and testMap() functions: 
```Elixir
def printTuple(_tuple), do: throw :nif_not_loaded
def testTuple() do
  tuple = {:im_an_atom, 1.0, 1, "string"}
  printTuple(tuple)
end

def printMap(_map), do: throw :nif_not_loaded

def testMap() do
  map = %{"firstEntry" => 1,
  "secondEntry" => :second,
  :third => 3.0,
  4 => "fourthEntry",
  "fifthEntry" => "five"}
  printMap(map)
end
```
These are a basic collection of several different types in the Tuple and Map.

This code is needed in Rust to access these with Rustler:
```Rust
use rustler::types::map::NifMapIterator;
use rustler::types::atom::NifAtom;

rustler_export_nifs! {
    "Elixir.Example",
    [("add", 2, add),
     ("printTuple", 1, print_tuple),
     ("printMap",1, print_map)],
    None
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

```

These functions can be called by iex -S mix after modifying the Example.ex and the rust lib.rs as shown above. This results in: 
```Elixir
iex(1)> Example.testTuple()
Atom: im_an_atom, Float: 1, Integer: 1, String: string
                                                      :ok
iex(2)> Example.testMap()
(4, <<"fourthEntry">>)
                      (third, 3.000000e+00)
                                           (<<"fifthEntry">>, <<"five">>)
                                                                         (<<"firstEntry">>, 1)
                                                                                              (<<"secondEntry">>, second)
      :ok

```
Notice also that the map entries are ordered differently than how they were put in Elixir. So building your interface will require match terms to properly pull data from the maps if this is how you want to use Rustler.


## Port Example

This is a very basic port example. Pay close attention to both the Elixir and Rust code. Newlines are necessary for the read_line command in rust to work properly. So, Elixir must send a newline command for Rust to respond in this case.

So there's a gap following a printout of what was sent by elixir to Rust. There's not a newline in the rust output because the print! command is used instead of the println! command.
```Elixir
iex(1)> PortExample.test()
Input sent to rust: Hello World!

"Received in Rust: Hello World!"
true
iex(2)> 

```