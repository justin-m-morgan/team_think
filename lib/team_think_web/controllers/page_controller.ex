defmodule TeamThinkWeb.PageController do
  use TeamThinkWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
