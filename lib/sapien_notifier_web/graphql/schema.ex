defmodule SapienNotifierWeb.Schema do
  @moduledoc """
  graphql schema
  """
  use Absinthe.Schema

  alias SapienNotifierWeb.Resolvers

  import_types(SapienNotifierWeb.Type.Notifications)

  query do
    @desc "Get all notifications"
    field :notifications, list_of :notification do
      resolve &Resolvers.Notifications.all_notifications/3
    end

    @desc "Get user notification"
    field :user_notification, list_of :notification do
      arg :user_id, non_null :string
      resolve &Resolvers.Notifications.user_notification/3
    end
  end

  input_object :payload_params do
    field :title, :string
    field :body, :string
    field :url, :string
  end

  mutation do
    @desc "Create a notification"
    field :create_notification, :notification do
      arg :user_id, non_null :string
      arg :action, :string
      arg :source, :string
      arg :payload, :payload_params
      resolve &Resolvers.Notifications.create_notification/3
    end
  end

  subscription do
    @desc "When notification created"
    field :notification_added, :notification do
      arg :user_id, non_null :string
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
