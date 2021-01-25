defmodule EarlierThoughts.Lists do
  @moduledoc """
  Secondary context for lists of thoughts. Contains methods for working with the List process.
   - Generates the UUID for a list
   -
  """

  def application_children do
    [EarlierThoughts.Lists.Registry.child_spec(), EarlierThoughts.Lists.DynamicSupervisor]
  end
end
