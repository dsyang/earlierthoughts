defmodule ListProcessTest do
  use ExUnit.Case

  alias EarlierThoughts.Lists
  alias Lists.ListProcess
  alias ListProcess.State

  test "start link gets push delay from config" do
    list_struct = %Lists.List{uuid: "something"}
    {:ok, pid} = ListProcess.start_link(list_struct)
    state = GenServer.call(pid, :read)
    assert state.uuid == "something"
    assert state.push_delay_seconds == 1
  end

  test "read call returns full state" do
    identity_state = %State{
      uuid: "anything",
      thoughts: ["somethgin", "something else"]
    }

    {:reply, state, state} =
      ListProcess.handle_call(
        :read,
        [],
        identity_state
      )

    assert state == identity_state
  end

  test "add thought schedules a push with expected delay" do
    {:reply, new_state, new_state} =
      ListProcess.handle_call(
        {:new_thought, "test thought"},
        [],
        %ListProcess.State{
          uuid: "test",
          thoughts: [],
          scheduled_push: nil,
          push_delay_seconds: 10
        }
      )

    %ListProcess.State{
      thoughts: ["test thought"],
      scheduled_push: timer
    } = new_state

    assert abs(Process.read_timer(timer) - 10 * 1000) < 100
  end

  test "adding an existing thought cancels and restarts timer" do
    dummy_timer = Process.send_after(self(), :blah, 10 * 1000)

    {:reply, new_state, new_state} =
      ListProcess.handle_call(
        {:new_thought, "new thought"},
        [],
        %ListProcess.State{
          uuid: "test",
          thoughts: ["initial"],
          scheduled_push: dummy_timer,
          push_delay_seconds: 10
        }
      )

    %ListProcess.State{
      thoughts: ["new thought", "initial"],
      scheduled_push: new_timer
    } = new_state

    assert Process.read_timer(dummy_timer) == false
    assert abs(Process.read_timer(new_timer) - 10 * 1000) < 100
  end

  test "triggered push removes scheduled push" do
    dummy_timer = Process.send_after(self(), :blah, 10 * 1000)

    {:noreply, new_state} =
      ListProcess.handle_info(
        :push,
        %ListProcess.State{
          scheduled_push: dummy_timer
        }
      )

    %ListProcess.State{scheduled_push: val} = new_state
    assert val == nil
    Process.cancel_timer(dummy_timer)
  end
end
