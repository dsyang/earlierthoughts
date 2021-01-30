defmodule EarlierThoughtsWeb.StarterCode.PageLive do
  use EarlierThoughtsWeb, :live_view

  @default_config [enable_startercode_search: false]

  @styling %{
    button: "p-2 mt-5 text-white bg-indigo-500",
    link: "font-medium text-indigo-600 hover:text-indigo-500 hover:underline",
    h2: "text-xl underline"
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{}, style: @styling)}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    [enable_startercode_search: enable_search] =
      Application.get_env(:earlierthoughts, __MODULE__, @default_config)

    if not enable_search do
      # coveralls-ignore-start
      raise "action disabled when not in development"
      # coveralls-ignore-end
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
