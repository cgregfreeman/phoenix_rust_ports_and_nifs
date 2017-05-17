defmodule PortExample do

  def test() do
    port = Port.open({:spawn, "_build/dev/rustler_crates/portexample/debug/portexample"}, [:binary])
    Port.info(port)

  end

end