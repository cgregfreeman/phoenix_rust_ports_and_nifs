defmodule NifExample do
 use Rustler, otp_app: :phoenix_rust_ports_and_nifs, crate: :nifexample


    def add(_a, _b), do: exit(:nif_not_loaded)
    def printTuple(_tuple), do: exit(:nif_not_loaded)
    def testTuple() do
      tuple = {:im_an_atom, 1.0, 1, "string"}
      printTuple(tuple)
    end

    def printMap(_map), do: exit(:nif_not_loaded)

    def testMap() do
        map = %{"firstEntry" => 1,
        "secondEntry" => :second,
        :third => 3.0,
        4 => "fourthEntry",
        "fifthEntry" => "five"}
        printMap(map)
    end

end