defmodule SapienNotifier.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :user_ids, {:array, :string}
      add :source, :string
      add :action, :string
      add :target, {:array, :string}
      add :payload, :map
      add :devices, {:array, :map}

      timestamps()
    end
  end
end
