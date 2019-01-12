defmodule SapienNotifier.Repo.Migrations.CreateNotifications do
  use Ecto.Migration

  def change do
    create table(:notifications) do
      add :user_id, :string
      add :source, :string
      add :data, :map
      # add :target, {:array, :string}
      # add :devices, {:array, :map}

      timestamps()
    end
  end
end
