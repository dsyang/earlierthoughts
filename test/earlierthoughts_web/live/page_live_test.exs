defmodule EarlierthoughtsWeb.PageLiveTest do
  use EarlierthoughtsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/startercode")
    assert disconnected_html =~ "Welcome to PETAL!"
    assert render(page_live) =~ "Welcome to PETAL!"
  end
end
