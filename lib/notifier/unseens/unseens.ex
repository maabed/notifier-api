defmodule Notifier.Unseens do
  @moduledoc """
  Unseens context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias Notifier.{Unseen}
  alias Notifier.Repo

  def get_unseen(%{user_id: user_id, tribe_ids: tribe_ids}) do
    query = from u in Unseen,
      where: u.tribe_id in ^tribe_ids and u.user_id == ^user_id

    Repo.all(query)
  end

  def update_unseen(%{receivers: receivers, tribe_id: tribe_id}) do
    receivers
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.uniq()
    |> upsert_unseens(tribe_id)
  end

  defp upsert_unseens(receiver_ids, tribe_id) do
    now = DateTime.utc_now()
    entries =
      receiver_ids
      |> Enum.map(fn id ->
        %{
          user_id: id,
          tribe_id: tribe_id
        }
      end)

    opts = [returning: true,
      on_conflict: [inc: [unseen_count: 1], set: [updated_at: now, inserted_at: now]],
      conflict_target: [:user_id, :tribe_id]]

    result =
      Unseen
      |> Repo.insert_all(entries, opts)

    case result do
      {0, error} -> {:error, error}
      {_count, unseens} -> {:ok, unseens}
    end
  end

  def mark_as_seen(%{user_id: user_id, tribe_id: tribe_id}) do
    query =
      from u in Unseen,
        where: u.user_id == ^user_id and u.tribe_id == ^tribe_id

    case Repo.one(query) do
      %Unseen{} = unseen ->
        unseen
        |> Repo.delete()
        {:ok, true}

      nil -> {:ok, nil}
    end
  end
end
