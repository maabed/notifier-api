defmodule SapienNotifier.Repo do
  use Ecto.Repo,
    otp_app: :sapien_notifier,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end

defmodule SapienNotifier.SapienRepo do
  use Ecto.Repo,
    otp_app: :sapien_notifier,
    adapter: Ecto.Adapters.Postgres,
    read_only: true

  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("SAPIEN_DATABASE_URL"))}
  end
end
