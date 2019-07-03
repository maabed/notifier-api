defmodule Notifier.Receiver do
  @moduledoc """
  Receivers schema
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Notifier.Notification


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @timestamps_opts [type: :utc_datetime_usec]
  schema "receivers" do
    field :user_id, :string
    field :read, :boolean, default: false
    field :status, :string

    belongs_to :notification, Notification

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(receiver, attrs) do
    receiver
    |> cast(attrs, [:user_id, :read, :status, :notification_id])
    |> validate_required([:user_id, :read, :status, :notification_id])
  end
end
