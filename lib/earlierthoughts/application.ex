defmodule Earlierthoughts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        Earlierthoughts.Repo,
        # Start the Telemetry supervisor
        EarlierthoughtsWeb.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: Earlierthoughts.PubSub},
        # Start the Endpoint (http/https)
        EarlierthoughtsWeb.Endpoint
        # Start a worker by calling: Earlierthoughts.Worker.start_link(arg)
        # {Earlierthoughts.Worker, arg}
      ] ++ EarlierThoughts.Lists.application_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Earlierthoughts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EarlierthoughtsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
