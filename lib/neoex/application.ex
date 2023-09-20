defmodule Neoex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NeoexWeb.Telemetry,
      # Start the Ecto repository
      Neoex.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Neoex.PubSub},
      # Start Finch
      {Finch, name: Neoex.Finch},
      # Start the Endpoint (http/https)
      NeoexWeb.Endpoint,
      # Start a worker by calling: Neoex.Worker.start_link(arg)
      # {Neoex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Neoex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NeoexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
