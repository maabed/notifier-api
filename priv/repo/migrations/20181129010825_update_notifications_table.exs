defmodule SapienNotifier.Repo.Migrations.UpdateNotificationsTable do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      remove :devices
    end
  end
end
