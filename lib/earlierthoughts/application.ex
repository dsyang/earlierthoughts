defmodule EarlierThoughts.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      [
        # Start the Ecto repository
        EarlierThoughts.Repo,
        # Start the Telemetry supervisor
        EarlierThoughtsWeb.StarterCode.Telemetry,
        # Start the PubSub system
        {Phoenix.PubSub, name: EarlierThoughts.PubSub},
        # Start the Endpoint (http/https)
        EarlierThoughtsWeb.Endpoint
        # Start a worker by calling: EarlierThoughts.Worker.start_link(arg)
        # {EarlierThoughts.Worker, arg}
      ] ++ EarlierThoughts.Lists.application_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EarlierThoughts.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EarlierThoughtsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
