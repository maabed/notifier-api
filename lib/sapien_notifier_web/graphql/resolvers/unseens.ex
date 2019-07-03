defmodule NotifierWeb.Resolvers.Unseens do
  @moduledoc """
  Unseens resolvers
  """
  alias Notifier.{Unseens}
  require Logger

  def get_unseen(_, args, %{context: %{current_user: current_user}}) do
    attrs = Map.merge(args, %{user_id: current_user})
    Logger.info "get_unseen attrs: #{inspect attrs}"
    {:ok, Unseens.get_unseen(attrs)}
  end

  def update_unseen(_, args, _) do
    Logger.info "update_unseen1 args: #{inspect args}"
    with {:ok, unseen} <- Unseens.update_unseen(args) do
      data = %{
        user_id: unseen.user_id,
        tribe_id: unseen.tribe_id,
        count: unseen.count,
      }

      publish(data, unseen_updated: unseen.user_id)

      {:ok, data}
    end
  end

  def mark_as_seen(_, args, %{context: %{current_user: current_user}}) do
    attrs = Map.merge(args, %{user_id: current_user})
    with {:ok, true} <- Unseens.mark_as_seen(attrs) do
      data = %{
        tribe_id: args.tribe_id,
        count: 0,
      }

      publish(data, unseen_updated: current_user)

      {:ok, true}
    end
  end

  # @TODO: make global for all notifier pubs events
  defp publish(payload, topics) do
    Absinthe.Subscription.publish(NotifierWeb.Endpoint, payload, topics)
  end
end
