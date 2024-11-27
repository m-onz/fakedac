
defmodule Fakedac.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Bandit, plug: Fakedac.MyPlug, scheme: :http, port: 4000}
    ]

    opts = [strategy: :one_for_one, name: Fakedac.Supervisor]
    Logger.info("Starting Bandit server on port 4000...")
    Supervisor.start_link(children, opts)
  end
end
