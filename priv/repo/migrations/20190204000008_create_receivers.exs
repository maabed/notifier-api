defmodule SapienNotifier.Repo.Migrations.CreateReceivers do
  use Ecto.Migration

  def change do
    create table(:receivers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :read, :boolean, default: false, null: false
      add :notification_id, references(:notifications, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    create index(:receivers, [:notification_id, :user_id])
  end
end
