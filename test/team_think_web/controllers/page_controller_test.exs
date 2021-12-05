defmodule TeamThinkWeb.PageControllerTest do
  use TeamThinkWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "TeamThink"
  end
end
