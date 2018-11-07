defmodule SapienNotifier.Repo do
  use Ecto.Repo,
    otp_app: :sapien_notifier,
    adapter: Ecto.Adapters.Postgres
end
