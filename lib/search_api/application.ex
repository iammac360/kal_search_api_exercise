defmodule SearchApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    port = Application.fetch_env!(:search_api, :port) || 4001

    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: SearchApi.Worker.start_link(arg)
      # {SearchApi.Worker, arg},

      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: SearchApi.Router, options: [port: port]),
      worker(Cachex, [:search_api, []])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SearchApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
