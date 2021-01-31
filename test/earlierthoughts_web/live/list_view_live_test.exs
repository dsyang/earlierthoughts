defmodule EarlierThoughtsWeb.ListViewLiveTest do
  use EarlierThoughtsWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, view, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Earlier Thoughts"
    assert render(view) =~ "earlier Thoughts"
  end
end
