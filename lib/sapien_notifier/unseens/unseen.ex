defmodule Notifier.Unseen do
  @moduledoc """
  Unseens schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @timestamps_opts [type: :utc_datetime_usec]
  schema "unseens" do
    field :user_id, :string
    field :tribe_id, :string, read_after_writes: true
    field :count, :integer, default: 0, read_after_writes: true

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(unseen, attrs) do
    unseen
    |> cast(attrs, [:user_id, :tribe_id, :count])
    |> validate_required([:user_id, :tribe_id, :count])
  end
end
