defmodule SapienNotifier.Notifier do
  @moduledoc """
  The Notifier context.
  """

  import Ecto.Query, warn: false
  alias SapienNotifier.Notifier.{Notification, Receiver}
  alias SapienNotifier.Repo

  def list_notifications, do: Repo.all(Notification)

  def get_notification!(id), do: Repo.get!(Notification, id)
  def get_notification_receiver!(id), do: Repo.get!(Receiver, id)

  def base_query(user_id, filters) do
    from n in Notification,
      join: r in assoc(n, :receivers),
      on: r.user_id == ^user_id,
      where: fragment("payload->>'action' = ANY(?)", ^filters)
  end

  def get_notification_by_id(id, user_id) do
    Repo.all from n in Notification,
      join: r in assoc(n, :receivers),
      where: r.notification_id == ^id and r.user_id == ^user_id,
      preload: [receivers: r]
  end

  def get_user_notifications(user_id, limit, offset, filters) do
    query =
      from [n, r] in base_query(user_id, filters),
      select: %{n | read: r.read, status: r.status },
      limit: ^limit,
      offset: ^offset,
      order_by: [desc: n.inserted_at]
      # preload: [receivers: r] # use this to load all receivers data

    Repo.all(query)
  end

  def get_user_unread_notifications_count(user_id, filters) do
    Repo.one from [n, r] in base_query(user_id, filters),
      where: r.read == false,
      select: count(r.id)
  end

  def get_user_notifications_count(user_id, filters) do
    Repo.one from [_n, r] in base_query(user_id, filters),
      select: count(r.id)
  end

  def create_notification(params \\ %{}) do
    %Notification{}
    |> Notification.changeset(params)
    |> Repo.insert()
    |> parse_and_insert_receivers(params.receivers)
  end

  def parse_and_insert_receivers({:ok, notification}, receivers) do
    receivers
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.each(fn receiver ->
      params_with_relation = %{
        notification_id: notification.id,
        user_id: receiver,
        read: false,
        status: "UNREAD",
      }

      %Receiver{}
      |> Receiver.changeset(params_with_relation)
      |> Repo.insert()
    end)

  {:ok, notification}
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

  def delete_receivers(id, user_ids) do
    query =
      from r in Receiver,
        where: r.notification_id == ^id and r.user_id in ^user_ids

    Repo.delete_all(query)
    {:ok, true}
  end
end
