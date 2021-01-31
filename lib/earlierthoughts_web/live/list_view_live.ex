defmodule EarlierThoughtsWeb.ListViewLive do
  use EarlierThoughtsWeb, :live_view

  @styling %{
    h1: "text-xxl underline",
    p: "text-l m-5",
    button: "p-2 mt-5 text-white bg-indigo-500"
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(style: @styling)}
  end
end
