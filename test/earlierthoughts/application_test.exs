defmodule ApplicationTest do
  use ExUnit.Case
  import Mock

  test_with_mock(
    "cascade config changes to endpoint",
    EarlierThoughtsWeb.Endpoint,
    config_change: fn changed, removed -> [changed, removed] end
  ) do
    updated = ["updated"]
    deleted = ["deleted"]
    :ok = EarlierThoughts.Application.config_change(updated, [], deleted)
    assert_called(EarlierThoughtsWeb.Endpoint.config_change(updated, deleted))
  end
end
