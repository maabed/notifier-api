defmodule SapienNotifierWeb.Resolvers.Notifications do
  @moduledoc """
  Notifications resolvers
  """
  alias SapienNotifier.Notifier
  require Logger

  def all_notifications(_, _, _) do
    {:ok, Notifier.list_notifications()}
  end

  def user_notification(_, %{user_id: user_id}, _) do
    {:ok, Notifier.get_user_notifications(user_id)}
  end

  def notification(_, %{id: id}, _) do
    {:ok, Notifier.get_notification!(id)}
  end

  def mark_as_read(_, %{id: id}, _) do
    with {:ok, true} <- Notifier.mark_as_read(id) do
      {:ok, true}
    end
  end

  def create_notification(_, args, %{context: %{current_user: current_user}}) do
    with {:ok, notification} <- Notifier.create_notification(args) do
      Logger.warn "current_user on create_notification context #{inspect current_user}"
      Logger.warn "user_ids length #{inspect length(notification.user_ids)}"
      Enum.each(notification.user_ids, fn user_id ->
        Absinthe.Subscription.publish(SapienNotifierWeb.Endpoint, notification, notification_added: user_id)
      end)

      {:ok,
      %{id: notification.id,
        user_ids: notification.user_ids,
        source: notification.source,
        sender_name: notification.sender_name,
        sender_id: notification.sender_id,
        read: notification.read,
        inserted_at: notification.inserted_at,
        payload: notification.payload}
      }
    end
  end
end
