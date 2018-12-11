defmodule SapienNotifier.Notifier do
  @moduledoc """
  The Notifier context.
  """

  import Ecto.Query, warn: false
  alias SapienNotifier.Notifier.Notification
  alias SapienNotifier.Repo
  require Logger

  def list_notifications do
    Repo.all(Notification)
  end

  def get_notification!(id), do: Repo.get!(Notification, id)

  def get_user_notifications(user_id) do
    Logger.info(inspect(user_id))
    query = from n in Notification, where: ^user_id in n.user_ids, order_by: [desc: :inserted_at]
    Repo.all(query)
  end

  def create_notification(attrs \\ %{}) do
    %Notification{}
    |> Notification.changeset(attrs)
    |> Repo.insert()
  end

  def update_notification(%Notification{} = notification, attrs) do
    notification
    |> Notification.changeset(attrs)
    |> Repo.update()
  end

  def delete_notification(%Notification{} = notification) do
    Repo.delete(notification)
  end

  def change_notification(%Notification{} = notification) do
    Notification.changeset(notification, %{})
  end
end
