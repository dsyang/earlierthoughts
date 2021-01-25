defmodule EarlierThoughts.Lists.Registry do
  @moduledoc """
  Used to get to a list's process by UUID
  """
  def child_spec do
    Registry.child_spec(
      keys: :unique,
      name: __MODULE__,
      partitions: System.schedulers_online()
    )
  end

  def find_list(list_uuid) do
    case Registry.lookup(__MODULE__, list_uuid) do
      [{list_pid, _}] -> {:ok, list_pid}
      [] -> {:error, :not_found}
    end
  end
end
