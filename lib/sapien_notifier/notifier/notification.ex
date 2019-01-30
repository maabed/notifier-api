defmodule SapienNotifier.Notifier.Notification do
  @moduledoc """
  Notifications model
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "notifications" do
    field :user_ids, {:array, :string}
    field :sender_id, :string
    field :sender_name, :string
    field :read, :boolean, default: false
    field :source, :string, default: "Sapien"
    field :payload, :map
    # field :target, {:array :string} # once mobile app ready
    # field :devices, {:array, :map} # once mobile app ready

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:user_ids, :sender_id, :sender_name, :source, :payload])
    |> validate_required([:user_ids, :sender_id, :sender_name, :source, :payload])
    # |> serialize_user_ids()
  end

  defp serialize_user_ids(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{user_ids: user_ids}} ->
        users = List.first(user_ids) |> String.split(",")
        put_change(changeset, :user_ids, users)
      _ -> changeset
    end
  end
end
