defmodule SapienNotifierWeb.Schema do
  @moduledoc """
  graphql schema
  """
  use Absinthe.Schema

  alias SapienNotifierWeb.Resolvers

  import_types(SapienNotifierWeb.Type.Notifications)

  query do
    @desc "Get all notifications"
    field :notifications, list_of(:notification) do
      resolve(&Resolvers.Notifications.all_notifications/3)
    end

    @desc "Get user notification"
    field :user_notification, list_of(:notification) do
      arg :user_id, non_null(:string)
      resolve(&Resolvers.Notifications.user_notification/3)
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
      arg :user_ids, non_null(list_of(:string))
      arg :action, :string
      arg :source, :string
      arg :target, :string
      arg :payload, :payload_params
      resolve(&Resolvers.Notifications.create_notification/3)
    end
  end

  subscription do
    @desc "When notification created"
    field :notification_added, :notification do
      trigger(:create_notification,
        topic: fn _ ->
          "*"
        end
      )

      config(fn _, _info ->
        {:ok, topic: "*"}
      end)
    end
  end
end
