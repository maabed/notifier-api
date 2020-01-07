defmodule SapienNotifier.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias SapienNotifier.ReleaseTasks

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(SapienNotifier.Repo, []),
      supervisor(SapienNotifier.SapienRepo, []),
      # Start the endpoint when the application starts
      supervisor(SapienNotifierWeb.Endpoint, []),
      supervisor(Absinthe.Subscription, [SapienNotifierWeb.Endpoint])
      # Starts a worker by calling: SapienNotifier.Worker.start_link(arg)
      # {SapienNotifier.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SapienNotifier.Supervisor]
    # Supervisor.start_link(children, opts)

    case Supervisor.start_link(children, opts) do
      {:ok, top_sup} ->
        # Verify the latest schema migration after starting the database worker
        #
        # Consider doing this in a process that runs after the Repo
        # comes up, but before anything else is done
        :ok = ReleaseTasks.sapien_db_migration()
        {:ok, top_sup}
      error ->
        error
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SapienNotifierWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
