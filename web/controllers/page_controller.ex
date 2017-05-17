defmodule PhoenixRustPortsAndNifs.PageController do
  use PhoenixRustPortsAndNifs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
