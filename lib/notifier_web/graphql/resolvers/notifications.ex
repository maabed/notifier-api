defmodule NotifierWeb.Resolvers.Notifications do
  @moduledoc """
  Notifications resolvers
  """
  alias Notifier.{Notifications}
  @defaults_pagination %{limit: 10, offset: 0}

  def all_notifications(_, _, _) do
    {:ok, Notifications.list_notifications()}
  end

  def user_notification(_, %{user_id: user_id} = args, _) do
    %{limit: limit, offset: offset} = Map.merge(@defaults_pagination, args)
    {:ok, Notifications.get_user_notifications(user_id, limit, offset)}
  end

  def user_unread_notification_count(_, %{user_id: user_id}, _) do
    {:ok, Notifications.get_user_unread_notifications_count(user_id)}
  end

  def user_notification_count(_, %{user_id: user_id}, _) do
    {:ok, Notifications.get_user_notifications_count(user_id)}
  end

  def notification(_, %{id: id}, _) do
    {:ok, Notifications.get_notification!(id)}
  end

  def update_status(_, %{id: id, status: status}, %{context: %{user_id: user_id}}) do
    with {:ok, true} <- Notifications.update_status(id, user_id, status) do
      {:ok, true}
    end
  end

  def mark_as_read(_, %{id: id}, %{context: %{user_id: user_id}}) do
    with {:ok, true} <- Notifications.mark_as_read(id, user_id) do
      {:ok, true}
    end
  end

  def mark_all_as_read(_, _, %{context: %{user_id: user_id}}) do
    with {:ok, true} <- Notifications.mark_all_as_read(user_id) do
      {:ok, true}
    end
  end

  def create_notification(_, args, _) do
    with {:ok, notification} <- Notifications.create_notification(args) do
      data = %{
        id: notification.id,
        read: false,
        source: notification.source,
        sender_name: notification.sender_name,
        sender_thumb: notification.sender_thumb,
        sender_profile_id: notification.sender_profile_id,
        sender_id: notification.sender_id,
        inserted_at: notification.inserted_at,
        payload: notification.payload
      }

      args.receivers
      |> Enum.uniq()
      |> Enum.each(fn user_id ->
        Absinthe.Subscription.publish(NotifierWeb.Endpoint, data, notification_added: user_id)
      end)

      {:ok, data}
    end
  end
end
