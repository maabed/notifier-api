defmodule SapienNotifier.Notifier.Notification do
  @moduledoc """
  Notifications model
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :user_id, :string
    field :action, :string
    field :payload, :map
    field :source, :string
    # field :target, {:array :string} # once mobile app ready
    # field :devices, {:array, :map} # once mobile app ready

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:user_id, :source, :action, :payload])
    |> validate_required([:user_id, :source, :action, :payload])
  end
end
