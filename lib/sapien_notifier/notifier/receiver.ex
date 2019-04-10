defmodule SapienNotifier.Notifier.Receiver do
  use Ecto.Schema
  import Ecto.Changeset
  alias SapienNotifier.Notifier.Notification


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "receivers" do
    field :user_id, :string
    field :status, :string, default: "UNREAD"

    belongs_to :notification, Notification

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(receiver, attrs) do
    receiver
    |> cast(attrs, [:user_id, :status, :notification_id])
    |> validate_required([:user_id, :status, :notification_id])
  end
end
