defmodule Notifier.Repo.Migrations.CreateUnseen do
  @moduledoc """
    Create Unseena tabel
  """
  use Ecto.Migration

  def change do
    create table(:unseens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, :string
      add :tribe_id, :string
      add :count, :integer, default: 0

      timestamps(type: :utc_datetime_usec)
    end
  end
end
