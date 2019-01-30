defmodule SapienNotifier.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_ids, {:array, :text}
      add :sender_id, :string
      add :sender_name, :string
      add :read, :boolean, null: false, default: false
      add :source, :string, default: "Sapien"
      add :payload, :map
      # add :target, {:array, :string}
      # add :devices, {:array, :map}

      timestamps()
    end
  end
end
