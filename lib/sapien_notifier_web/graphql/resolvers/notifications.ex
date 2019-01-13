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

  def create_notification(_, args, _) do
    with {:ok, notification} <- Notifier.create_notification(args) do
      {:ok, notification}
    end
  end
end
