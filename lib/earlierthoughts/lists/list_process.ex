defmodule EarlierThoughts.Lists.ListProcess do
  use GenServer, restart: :transient

  require Logger

  alias EarlierThoughts.Lists.List

  def start_link(%List{} = list) do
    GenServer.start_link(
      __MODULE__,
      list,
      name: {:via, Registry, {EarlierThoughts.Lists.Registry, list.uuid}}
    )
  end

  @impl true
  def init(%List{} = state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:read, _from, %List{} = state) do
    {:reply, state, state}
  end
end
