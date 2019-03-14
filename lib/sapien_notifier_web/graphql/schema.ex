defmodule SapienNotifierWeb.Schema do
  @moduledoc """
  graphql schema
  """
  use Absinthe.Schema

  alias SapienNotifierWeb.Resolvers
  require Logger
  import_types SapienNotifierWeb.Type.Notifications

  alias SapienNotifierWeb.Schema.Middleware

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  query do
    @desc "Get all notifications"
    field :all_notifications, list_of :query_notification do
      resolve &Resolvers.Notifications.all_notifications/3
    end

    @desc "Get user notification"
    field :user_notification, list_of :query_notification do
      arg :user_id, non_null(:id)
      arg :limit, :integer
      arg :offset, :integer
      resolve &Resolvers.Notifications.user_notification/3
    end

    @desc "Get notification by id"
    field :notification, :query_notification do
      arg :id, non_null(:id)
      resolve &Resolvers.Notifications.notification/3
    end
  end

  mutation do
    @desc "Create a notification"
    field :create_notification, :notification do
      arg :receivers, list_of(non_null(:string))
      arg :sender_id, :string
      arg :sender_name, :string
      arg :sender_thumb, :string
      arg :sender_profile_id, :string
      arg :source, :string, default_value: "Sapien"
      arg :payload, :payload_params
      resolve &Resolvers.Notifications.create_notification/3
    end

    @desc "mark notification as read"
    field :mark_as_read, :boolean do
      arg :id, non_null(:id)
      resolve &Resolvers.Notifications.mark_as_read/3
    end

    @desc "mark notification as read"
    field :mark_all_as_read, :boolean do
      resolve &Resolvers.Notifications.mark_all_as_read/3
    end
  end

  subscription do
    @desc "When notification created"
    field :notification_added, :notification do
      arg :user_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.user_id}
      end
    end
  end
end
