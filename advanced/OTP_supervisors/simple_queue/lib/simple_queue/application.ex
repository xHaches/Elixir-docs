defmodule SimpleQueue.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # SimpleQueue
      {SimpleQueue, [1, 2, 3]}
      # Starts a worker by calling: SimpleQueue.Worker.start_link(arg)
      # {SimpleQueue.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SimpleQueue.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def child_spec(opts) do
    %{
      id: SimpleQueue,
      start: {__MODULE__, :start_link, [opts]},
      shutdown: 5_000,
      restart: :permanent,
      type: :worker
    }
  end
end
