defmodule NotifierWeb.Schema do
  @moduledoc """
  graphql schema
  """
  use Absinthe.Schema

  alias NotifierWeb.Resolvers
  import_types NotifierWeb.Type.Notifications
  import_types NotifierWeb.Type.Unseens

  alias NotifierWeb.Schema.Middleware

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

    @desc "Get user notifications"
    field :user_notification, list_of :query_notification do
      arg :user_id, non_null(:id)
      arg :limit, :integer
      arg :offset, :integer
      resolve &Resolvers.Notifications.user_notification/3
    end

    @desc "Get user notifications count"
    field :user_notification_count, non_null(:integer) do
      arg :user_id, non_null(:id)
      resolve &Resolvers.Notifications.user_notification_count/3
    end

    @desc "Get user notifications count"
    field :user_unread_notification_count, non_null(:integer) do
      arg :user_id, non_null(:id)
      resolve &Resolvers.Notifications.user_unread_notification_count/3
    end

    @desc "Get notification by id"
    field :notification, :query_notification do
      arg :id, non_null(:id)
      resolve &Resolvers.Notifications.notification/3
    end

    @desc "Get unseen"
    field :get_unseen, list_of :unseen do
      arg :tribe_ids, list_of(non_null(:id))
      resolve &Resolvers.Unseens.get_unseen/3
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

    @desc "mark all notifications as read"
    field :mark_all_as_read, :boolean do
      resolve &Resolvers.Notifications.mark_all_as_read/3
    end

    @desc "update notification status"
    field :update_status, :boolean do
      arg :id, non_null(:id)
      arg :status, :string
      resolve &Resolvers.Notifications.update_status/3
    end

    @desc "update unseen"
    field :update_unseen, :boolean do
      arg :receivers, list_of(non_null(:string))
      arg :tribe_id, non_null(:id)
      resolve &Resolvers.Unseens.update_unseen/3
    end

    @desc "mark as seen"
    field :mark_as_seen, :boolean do
      arg :tribe_id, non_null(:id)
      resolve &Resolvers.Unseens.mark_as_seen/3
    end
  end

  subscription do
    @desc "When notification created"
    field :notification_added, :notification do
      config fn _, %{context: context} ->
        if user_id = context[:user_id] do
          {:ok, topic: user_id}
        else
          {:ok, topic: []}
        end
      end
    end

    @desc "When unseen records updated"
    field :unseen_updated, :unseen do
      config fn _, %{context: context} ->
        if user_id = context[:user_id] do
          {:ok, topic: user_id}
        else
          {:ok, topic: []}
        end
      end
    end
  end
end
