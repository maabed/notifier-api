defmodule SapienNotifier.Notifier.Notification do
  @moduledoc """
  Notifications model
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :user_ids, {:array, :string}
    field :action, :string
    field :payload, :map
    field :source, :string
    field :target, :string
    # field :devices, {:array, :map} # once mobile app ready

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:user_ids, :source, :action, :target, :payload])
    |> validate_required([:user_ids, :source, :action, :target, :payload])
  end
end
