defmodule EarlierThoughts.Lists do
  @moduledoc """
  Secondary context for lists of thoughts. Contains methods for working with the List process.
   - Generates the UUID for a list
   -
  """
  alias EarlierThoughts.Lists

  def application_children do
    [Lists.Registry.child_spec(), Lists.DynamicSupervisor]
  end

  def get_or_create_list(list_uuid) do
    {:ok, list_pid} =
      case Lists.Registry.find_list(list_uuid) do
        {:error, :not_found} ->
          Lists.DynamicSupervisor.start_list_process(%Lists.List{uuid: list_uuid})

        {:ok, _} = ok ->
          ok
      end

    list_pid
  end

  def new_thought(list_uuid, thought) do
    get_or_create_list(list_uuid)
    |> GenServer.call({:new_thought, thought})
  end

  def thoughts(list_uuid) do
    get_or_create_list(list_uuid)
    |> GenServer.call(:read)
  end

  def all_lists() do
    Lists.DynamicSupervisor.all_list_pids()
  end
end
