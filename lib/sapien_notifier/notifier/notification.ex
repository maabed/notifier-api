defmodule SapienNotifier.Notifier.Notification do
  @moduledoc """
  Notifications model
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "notifications" do
    field :user_id, :string
    field :sender_id, :string
    field :sender_name, :string
    field :read, :boolean, default: false
    field :source, :string, default: "Sapien"
    field :data, :map
    # field :target, {:array :string} # once mobile app ready
    # field :devices, {:array, :map} # once mobile app ready

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:user_id, :sender_id, :sender_name, :source, :data])
    |> validate_required([:user_id, :sender_id, :sender_name, :source, :data])
  end
end
