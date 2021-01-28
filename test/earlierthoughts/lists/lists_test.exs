defmodule ListsTest do
  @moduledoc """
  Tests the public API of the Lists context (lists.ex)
  """
  use ExUnit.Case
  alias EarlierThoughts.Lists

  @initial_uuid "initial_uuid"

  setup do
    initial_pid = Lists.get_or_create_list(@initial_uuid)
    %{initial_pid: initial_pid}
  end

  test "call get or create always returns a process", %{initial_pid: existing_pid} do
    pid = Lists.get_or_create_list("lol")
    assert is_pid(pid)

    another = Lists.get_or_create_list(@initial_uuid)
    assert another == existing_pid
  end

  import Mock

  test_with_mock "calling thoughts reads process state",
                 %{initial_pid: pid},
                 GenServer,
                 [:passthrough],
                 call: fn pid, msg -> [pid, msg] end do
    [process_called, msg] = Lists.thoughts(@initial_uuid)
    assert process_called == pid
    assert msg == :read
  end

  test_with_mock "calling new_thoughts sends message to process",
                 %{initial_pid: pid},
                 GenServer,
                 [:passthrough],
                 call: fn pid, msg -> [pid, msg] end do
    [process_called, msg] = Lists.new_thought(@initial_uuid, "something new")
    assert process_called == pid
    assert msg == {:new_thought, "something new"}
  end

  test "all lists finds all processes", %{initial_pid: existing_pid} do
    pid1 = Lists.get_or_create_list("another one")
    pid2 = Lists.get_or_create_list("one more")

    all_list_pids = Lists.all_lists()
    assert all_list_pids |> Enum.find(fn x -> x == existing_pid end) == existing_pid
    assert all_list_pids |> Enum.find(fn x -> x == pid1 end) == pid1
    assert all_list_pids |> Enum.find(fn x -> x == pid2 end) == pid2
  end
end
