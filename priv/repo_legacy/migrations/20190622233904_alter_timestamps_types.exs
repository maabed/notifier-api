defmodule SapienNotifier.Repo.Migrations.AlterTimestampsTypes do
  use Ecto.Migration

  def change do
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
