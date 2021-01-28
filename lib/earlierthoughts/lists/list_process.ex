defmodule EarlierThoughts.Lists.ListProcess do
  use GenServer, restart: :transient
  require Logger
  alias EarlierThoughts.Lists.List

  @default_config [push_delay_seconds: 3600]

  defmodule State do
    defstruct [:uuid, :thoughts, :scheduled_push, :push_delay_seconds]
  end

  def start_link(%List{uuid: uuid}) do
    [push_delay_seconds: delay_for_push] =
      Application.get_env(:earlierthoughts, __MODULE__, @default_config)

    Logger.notice("Waiting this many seconds for a push: #{delay_for_push}")

    GenServer.start_link(
      __MODULE__,
      %State{
        uuid: uuid,
        thoughts: [],
        scheduled_push: nil,
        push_delay_seconds: delay_for_push
      },
      name: {:via, Registry, {EarlierThoughts.Lists.Registry, uuid}}
    )
  end

  @impl true
  def init(%State{} = state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:read, _from, %State{} = state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(
        {:new_thought, msg},
        _from,
        %State{
          thoughts: thoughts,
          scheduled_push: nil,
          push_delay_seconds: delay_seconds
        } = state
      ) do
    next_push = Process.send_after(self(), :push, delay_seconds * 1000)
    new_state = %{state | thoughts: [msg | thoughts], scheduled_push: next_push}
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call(
        {:new_thought, msg},
        _from,
        %State{
          thoughts: thoughts,
          scheduled_push: next_push,
          push_delay_seconds: delay_seconds
        } = state
      ) do
    time_remaining = Process.cancel_timer(next_push)

    Logger.notice("Old timer had #{time_remaining} ms left.")
    new_push = Process.send_after(self(), :push, delay_seconds * 1000)
    new_state = %{state | thoughts: [msg | thoughts], scheduled_push: new_push}
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_info(
        :push,
        %State{
          thoughts: thoughts,
          scheduled_push: _next_push
        } = state
      ) do
    new_state = %{state | scheduled_push: nil}
    Logger.notice("Send a push token! here are the thoughts: #{thoughts}")
    {:noreply, new_state}
  end
end
