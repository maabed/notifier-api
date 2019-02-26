defmodule SapienNotifier.Repo.Migrations.CreateNotifications do
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
      # add :target, {:array, :string}
      # add :devices, {:array, :map}
      timestamps(type: :utc_datetime)
    end
  end
end
