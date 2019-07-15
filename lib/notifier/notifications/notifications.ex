defmodule Notifier.Notifications do
  @moduledoc """
  The Notifier context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias Notifier.{Notification, Receiver}
  alias Notifier.Repo

  def list_notifications, do: Repo.all(Notification)

  def get_notification!(id), do: Repo.get!(Notification, id)
  def get_notification_receiver!(id), do: Repo.get!(Receiver, id)

  def get_notification_by_id(id, user_id) do
    Repo.all from n in Notification,
      join: r in assoc(n, :receivers),
      where: r.notification_id == ^id and r.user_id == ^user_id,
      preload: [receivers: r]
  end

  def get_user_notifications(user_id, limit, offset) do
    Repo.all from n in Notification,
      join: r in assoc(n, :receivers),
      on: r.user_id == ^user_id,
      where: n.id == r.notification_id,
      distinct: r.notification_id,
      select: %{n | read: r.read, status: r.status },
      limit: ^limit,
      offset: ^offset,
      order_by: [desc: n.inserted_at]
      # preload: [receivers: r] # use this to load all receivers data
  end

  def get_user_unread_notifications_count(user_id) do
    Repo.one from from r in Receiver,
      where: r.user_id == ^user_id and r.read == false,
      select: count(r.notification_id, :distinct)
  end

  def get_user_notifications_count(user_id) do
    Repo.one from from r in Receiver,
      where: r.user_id == ^user_id,
      select: count(r.notification_id, :distinct)
  end

  def create_notification(params \\ %{}) do
    %Notification{}
    |> Notification.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, notification} ->
        parse_and_insert_receivers(notification.id, params.receivers)
        {:ok, notification}

      error ->
        Logger.info "Error create_notification: #{inspect(error)}"
    end
  end

  def parse_and_insert_receivers(notification_id, receivers) do
    receivers
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.uniq()
    |> Enum.map(fn receiver ->
      params_with_relation = %{
        notification_id: notification_id,
        user_id: receiver,
        read: false,
        status: "UNREAD",
      }

      %Receiver{}
      |> Receiver.changeset(params_with_relation)
      |> Repo.insert(
        on_conflict: {:replace, [:status, :updated_at]},
        conflict_target: [:notification_id, :user_id])
    end)
  end

  def mark_as_read(id, user_id) do
    query =
      from r in Receiver,
        where: r.notification_id == ^id and r.user_id == ^user_id

    case Repo.one(query) do
      %Receiver{} = receiver ->
        receiver
        |> Ecto.Changeset.change(read: true)
        |> Repo.update()
        {:ok, true}
      nil ->
        {:error, :not_found}
    end
  end

  def update_status(id, user_id, status) do
    query =
      from r in Receiver,
        where: r.notification_id == ^id and r.user_id == ^user_id

    case Repo.one(query) do
      %Receiver{} = receiver ->
        receiver
        |> Ecto.Changeset.change(status: status)
        |> Repo.update()
        {:ok, true}
      nil ->
        {:error, :not_found}
    end
  end

  def mark_all_as_read(user_id) do
    Receiver
    |> where([r], r.user_id == ^user_id)
    |> update([set: [read: true]])
    |> Repo.update_all([])

    {:ok, true}
  end
end
