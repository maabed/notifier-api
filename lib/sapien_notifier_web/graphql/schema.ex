defmodule SapienNotifierWeb.Schema do
  @moduledoc """
  graphql schema
  """
  use Absinthe.Schema

  alias SapienNotifierWeb.Resolvers

  import_types SapienNotifierWeb.Type.Notifications

  query do
    @desc "Get all notifications"
    field :all_notifications, list_of :notification do
      resolve &Resolvers.Notifications.all_notifications/3
    end

    @desc "Get user notification"
    field :user_notification, list_of :notification do
      arg :user_id, non_null(:id)
      resolve &Resolvers.Notifications.user_notification/3
    end

    @desc "Get notification by id"
    field :notification, :notification do
      arg :id, non_null(:id)
      resolve &Resolvers.Notifications.notification/3
    end
  end

  mutation do
    @desc "Create a notification"
    field :create_notification, :notification do
      arg :user_id, non_null(:id)
      arg :sender_id, :string
      arg :sender_name, :string
      arg :read, :boolean, default_value: false
      arg :source, :string, default_value: "Sapien"
      arg :data, :data_params
      resolve &Resolvers.Notifications.create_notification/3
    end

    @desc "mark notification as read"
    field :mark_as_read, :boolean do
      arg :id, non_null(:id)
      resolve &Resolvers.Notifications.mark_as_read/3
    end
  end

  subscription do
    @desc "When notification created"
    field :notification_added, :notification do
      arg :user_id, non_null(:id)
      trigger :create_notification,
        topic: fn args ->
          args.user_id
        end

      # replace _info with  %{context: %{ current_user: user_id }} to get current user
      # use {user_id}/create_notification on topic after activate notification channel
      config fn args, _info ->
        {:ok, topic: args.user_id}
      end
    end
  end
end
