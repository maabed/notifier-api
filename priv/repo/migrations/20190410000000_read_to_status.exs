defmodule SapienNotifier.Repo.Migrations.CreateReceivers do
  use Ecto.Migration

  def change do
    alter table(:receivers) do
      add :status, :string, default: "UNREAD", null: false
      remove :read
    end
  end
end
