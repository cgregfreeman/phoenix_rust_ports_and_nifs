defmodule PortExample do


  def test() do
    port = Port.open({:spawn, "priv/native/libportexample.so"}, [:binary])
    Port.info(port)



    driver = :erl_ddll.load("priv/native/", :libportexample)

  end

end