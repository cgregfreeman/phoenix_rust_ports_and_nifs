defmodule PortExample do


  def test() do
#    path = "native/rustyports/target/debug/rustports"
    port = Port.open({:spawn, "priv/native/libeetfport.so"}, [:binary])
    Port.info(port)

  end

end