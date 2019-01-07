defmodule SapienNotifier.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :user_id, :string
      add :source, :string
      add :action, :string
      add :payload, :map
      # add :target, {:array, :string}
      # add :devices, {:array, :map}

      timestamps()
    end
  end
end
