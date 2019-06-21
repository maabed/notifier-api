defmodule SapienNotifier.Repo.Migrations.AlterTimestampsTypes do
  use Ecto.Migration

  def change do
    alter table(:notifications) do
      modify :inserted_at, :utc_datetime_usec
      modify :updated_at, :utc_datetime_usec
    end

    alter table(:receivers) do
      modify :inserted_at, :utc_datetime_usec
      modify :updated_at, :utc_datetime_usec
    end
  end
end
