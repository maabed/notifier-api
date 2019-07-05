defmodule NotifierWeb.Resolvers.Unseens do
  @moduledoc """
  Unseens resolvers
  """
  alias Notifier.{Unseens}
  require Logger

  def get_unseen(_, args, %{context: %{user_id: user_id}}) do
    attrs = Map.merge(args, %{user_id: user_id})
    {:ok, Unseens.get_unseen(attrs)}
  end

  def update_unseen(_, args, _) do
    with {:ok, unseens} <- Unseens.update_unseen(args) do
      Enum.each(unseens, fn u -> publish(u, unseen_updated: u.user_id) end)
      {:ok, true}
    end
  end

  def mark_as_seen(_, args, %{context: %{user_id: user_id}}) do
    attrs = Map.merge(args, %{user_id: user_id})
    with {:ok, true} <- Unseens.mark_as_seen(attrs) do
      data = %{tribe_id: args.tribe_id, unseen_count: 0}
      publish(data, unseen_updated: user_id)
      {:ok, true}
    end
  end

  # @TODO: make global for all notifier pubs events
  defp publish(payload, topics) do
    Absinthe.Subscription.publish(NotifierWeb.Endpoint, payload, topics)
  end
end
