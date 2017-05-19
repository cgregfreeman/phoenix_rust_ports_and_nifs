defmodule PortExample do

  def test() do
    port = Port.open({:spawn_executable, "_build/dev/rustler_crates/portexample/debug/portexample"}, [:binary])
    input = "Hello World!\n" #Notice a newline character that is needed for the rust read_line function to complete
    IO.puts("Input sent to rust: " <> input)
    Port.command(port, input)

    receive do
      {^port, {:data, result}} ->
        IO.puts(inspect result)
    end

    _ = Port.close(port)

  end



end