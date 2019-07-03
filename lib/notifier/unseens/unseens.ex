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

  def get_unseen(%{user_id: user_id, tribe_id: tribe_id}) do
    Repo.get_by(Unseen, user_id: user_id, tribe_id: tribe_id)
  end

  def update_unseen(params) do
    Logger.info "update_unseen params: #{inspect params}"
    if params.count > 0 do
      params
      |> get()
      |> build_unseen(params)
      |> Unseen.changeset(params)
      |> Repo.insert_or_update()
    else
      {:error, "count must be greater than 0"}
    end
  end

  defp build_unseen({:ok, unseen}, _), do: unseen

  defp build_unseen({:error, :not_found},
    %{user_id: user_id, tribe_id: tribe_id, count: count}) do
    %Unseen{user_id: user_id, tribe_id: tribe_id, count: count}
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

      nil -> {:error, :not_found}
    end
  end
end
