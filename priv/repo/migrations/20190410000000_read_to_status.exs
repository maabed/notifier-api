defmodule Notifier.Repo.Migrations.CreateReceivers do
  use Ecto.Migration

  def change do
    alter table(:receivers) do
      add :status, :string
    end
  end
end
