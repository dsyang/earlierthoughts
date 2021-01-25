defmodule EarlierThoughts.Lists.DynamicSupervisor do
  @moduledoc """
  Manages the starting/stopping/restarting of list processes
  """
  use DynamicSupervisor

  alias EarlierThoughts.Lists.{List, ListProcess}

  def start_link(opts) do
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_list_process(%List{} = list) do
    child_spec = %{
      id: ListProcess,
      start: {ListProcess, :start_link, [list]},
      # restart if crashed
      restart: :transient
    }

    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def all_list_pids do
    __MODULE__
    |> DynamicSupervisor.which_children()
    |> Enum.reduce([], fn {_, pid, _, _}, acc -> [pid | acc] end)
  end
end
