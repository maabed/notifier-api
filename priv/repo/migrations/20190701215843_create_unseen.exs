defmodule Notifier.Repo.Migrations.CreateUnseen do
  @moduledoc """
    Create Unseena tabel
  """
  use Ecto.Migration

  def up do
    create table(:unseens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :tribe_id, :string
      add :unseen_count, :integer, default: 1
      add :inserted_at, :utc_datetime_usec, default: fragment("NOW()")
      add :updated_at, :utc_datetime_usec, default: fragment("NOW()")
    end

    create unique_index(:unseens, [:user_id, :tribe_id])
  end

  def down do
    drop table(:unseens)
  end
end
