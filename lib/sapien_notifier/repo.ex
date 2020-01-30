defmodule SapienNotifier.Repo do
  require Logger

  use Ecto.Repo,
    otp_app: :sapien_notifier,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    Logger.warn("opts => telemetry_prefix #{inspect Keyword.get(opts, :telemetry_prefix)}")
    Logger.warn("opts => migration_source #{inspect Keyword.get(opts, :migration_source)}")
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end

defmodule SapienNotifier.SapienRepo do
  use Ecto.Repo,
    otp_app: :sapien_notifier,
    adapter: Ecto.Adapters.Postgres

  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("SAPIEN_DATABASE_URL"))}
  end
end
