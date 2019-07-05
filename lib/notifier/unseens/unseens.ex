defmodule Notifier.Unseens do
  @moduledoc """
  Unseens context.
  """
  require Logger
  import Ecto.Query, warn: false
  alias Notifier.{Unseen}
  alias Notifier.Repo

  def get(params) do
    case Repo.get_by(Unseen,
          user_id: Map.get(params, :user_id, ""),
          tribe_id: Map.get(params, :tribe_id, "")
         ) do
      nil -> {:error, :not_found}
      unseen -> {:ok, unseen}
    end
  end

  def get_unseen(%{user_id: user_id, tribe_ids: tribe_ids}) do
    query = from u in Unseen,
      where: u.tribe_id in ^tribe_ids and u.user_id == ^user_id

    Repo.all(query)
  end

  def update_unseen(%{receivers: receivers, tribe_id: tribe_id}) do
    receivers
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(fn r -> find_insert_unseen(r, tribe_id) end)
    |> update_all_unseen(receivers, tribe_id)
  end

  defp find_insert_unseen(r, tribe_id) do
    attrs = %{tribe_id: tribe_id, user_id: r}
    attrs
    |> get()
    |> build_unseen(attrs)
  end

  defp build_unseen({:ok, _unseen}, _), do: {:ok, nil}
  defp build_unseen({:error, :not_found}, attrs) do
    %Unseen{}
    |> Unseen.changeset(attrs)
    |> Repo.insert()
  end

  def update_all_unseen(_, receivers, tribe_id) do
    now = NaiveDateTime.utc_now()
    result =
      from(u in Unseen,
      where: u.user_id in ^receivers and u.tribe_id == ^tribe_id,
      update: [inc: [unseen_count: ^1], set: [updated_at: ^now]],
      select: %{
        user_id: u.user_id,
        tribe_id: u.tribe_id,
        unseen_count: u.unseen_count,
      })
    |> Repo.update_all([])

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
