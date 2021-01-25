defmodule EarlierThoughts.Lists.ListProcess do
  use GenServer, restart: :transient
  require Logger
  alias EarlierThoughts.Lists.List

  @default_config [push_delay_seconds: 3600]

  defmodule State do
    defstruct [:uuid, :thoughts, :scheduled_push, :push_delay_seconds]
  end

  def start_link(%List{} = list) do
    [push_delay_seconds: delay_for_push] =
      Application.get_env(:earlierthoughts, __MODULE__, @default_config)

    Logger.notice("Waiting this many seconds for a push: #{delay_for_push}")

    GenServer.start_link(
      __MODULE__,
      %State{
        uuid: list.uuid,
        thoughts: [],
        scheduled_push: nil,
        push_delay_seconds: delay_for_push
      },
      name: {:via, Registry, {EarlierThoughts.Lists.Registry, list.uuid}}
    )
  end

  @impl true
  def init(%State{} = state) do
    {:ok, state}
  end

  # handle_call(:new_thought) = append to thoughts, if scheduled_push exists, cancel and reschedule,

  # handle_call(:push) = scheduled_push = nil, make push
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
    new_state = %{state | thoughts: [msg | thoughts]}
    {:reply, new_state, new_state}
  end

  @impl true
  def handle_call({:new_thought, msg}, _from, %State{
        thoughts: thoughts,
        scheduled_push: next_push,
        push_delay_seconds: delay_seconds
      }) do
  end

  @impl true
  def handle_call(:push, _from, %State{
        thoughts: thoughts,
        scheduled_push: next_push
      }) do
  end
end
