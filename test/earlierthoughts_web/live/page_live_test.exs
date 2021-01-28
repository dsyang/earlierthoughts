defmodule EarlierThoughtsWeb.PageLiveTest do
  use EarlierThoughtsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Mock

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/startercode")
    assert disconnected_html =~ "Welcome to PETAL!"
    assert render(page_live) =~ "Welcome to PETAL!"
  end

  test "empty search has no results", %{conn: conn} do
    {:ok, view, _} = live(conn, "/startercode")

    assert view |> element("form#livesearch") |> render_submit() =~
             "No dependencies found matching"
  end

  test_with_mock(
    "seach updates with change",
    %{conn: conn},
    Application,
    [:passthrough],
    started_applications: fn -> [{"example_application", [], []}, {"nope", [], []}] end
  ) do
    {:ok, view, _} = live(conn, "/startercode")

    view_output = view |> element("form#livesearch") |> render_change(%{q: "ex"})

    assert view_output =~ "example_application"

    refute view_output =~ "nope"
  end

  test_with_mock(
    "valid query redirects",
    %{conn: conn},
    Application,
    [:passthrough],
    started_applications: fn -> [{"example_application", [], []}, {"nope", [], []}] end
  ) do
    {:ok, view, _} = live(conn, "/startercode")

    {:error, {:redirect, %{to: redirect_url}}} =
      view
      |> element("form#livesearch")
      |> render_submit(%{q: "nope"})

    assert redirect_url == "https://hexdocs.pm/nope/"
  end
end
