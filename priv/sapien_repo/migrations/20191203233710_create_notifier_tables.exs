defmodule SapienNotifier.SapienRepo.Migrations.CreateNotifierTables do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :sender_id, :string
      add :sender_name, :string
      add :sender_thumb, :string
      add :sender_profile_id, :string
      add :source, :string, default: "Sapien"
      add :payload, :map
      timestamps(type: :utc_datetime_usec)
    end

    create table(:receivers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :read, :boolean, default: false, null: false
      add :status, :string
      add :notification_id, references(:notifications, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime_usec)
    end

    flush()

    create index(:receivers, [:notification_id, :user_id])

    flush()

    alter table(:notifications) do
      modify :inserted_at, :utc_datetime_usec, default: fragment("NOW()")
      modify :updated_at, :utc_datetime_usec, default: fragment("NOW()")
    end

    alter table(:receivers) do
      modify :inserted_at, :utc_datetime_usec, default: fragment("NOW()")
      modify :updated_at, :utc_datetime_usec, default: fragment("NOW()")
    end

  end
end
