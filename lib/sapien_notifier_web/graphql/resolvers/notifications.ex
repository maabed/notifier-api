defmodule SapienNotifierWeb.Resolvers.Notifications do
  @moduledoc """
  Notifications resolvers
  """
  alias SapienNotifier.Notifier
  @defaults_pagination %{limit: 10, offset: 0}

  def all_notifications(_, _, _) do
    {:ok, Notifier.list_notifications()}
  end

  def user_notification(_, %{user_id: user_id} = args, _) do
    %{limit: limit, offset: offset} = Map.merge(@defaults_pagination, args)
    {:ok, Notifier.get_user_notifications(user_id, limit, offset)}
  end

  def user_unread_notification_count(_, %{user_id: user_id}, _) do
    {:ok, Notifier.get_user_unread_notifications_count(user_id)}
  end

  def user_notification_count(_, %{user_id: user_id}, _) do
    {:ok, Notifier.get_user_notifications_count(user_id)}
  end

  def notification(_, %{id: id}, _) do
    {:ok, Notifier.get_notification!(id)}
  end

  def update_status(_, %{id: id, status: status}, %{context: %{current_user: current_user}}) do
    with {:ok, true} <- Notifier.update_status(id, current_user, status) do
      {:ok, true}
    end
  end

  def mark_as_read(_, %{id: id}, %{context: %{current_user: current_user}}) do
    with {:ok, true} <- Notifier.mark_as_read(id, current_user) do
      {:ok, true}
    end
  end

  def mark_all_as_read(_, _, %{context: %{current_user: current_user}}) do
    with {:ok, true} <- Notifier.mark_all_as_read(current_user) do
      {:ok, true}
    end
  end

  def create_notification(_, args, _) do
    with {:ok, notification} <- Notifier.create_notification(args) do
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

      Enum.each(args.receivers, fn user_id ->
        Absinthe.Subscription.publish(SapienNotifierWeb.Endpoint, data, notification_added: user_id)
      end)

      {:ok, data}
    end
  end
end
