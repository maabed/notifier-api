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
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
