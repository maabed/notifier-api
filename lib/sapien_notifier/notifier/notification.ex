defmodule SapienNotifier.Notifier.Notification do
  @moduledoc """
  Notifications model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias SapienNotifier.Notifier.{Notification, Receiver}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @timestamps_opts [type: :utc_datetime_usec]
  schema "notifications" do
    field :sender_id, :string
    field :sender_name, :string
    field :sender_thumb, :string
    field :sender_profile_id, :string
    field :source, :string, default: "Sapien"
    field :payload, :map
    # field :target, {:array :string} # once mobile app ready
    # field :devices, {:array, :map} # once mobile app ready

    has_many :receivers, Receiver, on_delete: :delete_all
    # holds read status for specific user_id when loaded via a join
    field :read, :boolean, virtual: true
    # holds notification status for specific user_id when loaded via a join
    field :status, :string, virtual: true

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(%Notification{} = notification, attrs) do
    notification
    |> cast(attrs, [:sender_id, :sender_name, :sender_thumb, :sender_profile_id, :source, :payload])
    |> validate_required([:sender_id, :sender_name, :sender_thumb, :sender_profile_id, :payload])
  end

  def update_inserted_at_changeset(notification, attrs \\ %{}) do
    notification
    |> cast(attrs, [:inserted_at])
    |> put_change(:inserted_at, attrs.inserted_at)
    |> validate_required([:inserted_at])
  end
end
