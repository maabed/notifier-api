defmodule NotifierWeb.Type.Notifications do
  @moduledoc """
  Notifications type
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Notifier.Repo
  import_types NotifierWeb.Type.Scalars

  input_object :payload_params do
    field :action_id, :string
    field :action, :string
    field :title, :string
    field :body, :string
    field :url, :string
    field :vote_type, :string
  end

  interface :notification_record do
    field :id, non_null(:id)
    field :sender_id, :id
    field :sender_name, :string
    field :sender_thumb, :string
    field :sender_profile_id, :id
    field :source, :string
    field :inserted_at, :time
    resolve_type fn _, _ -> nil end
  end

  object :query_notification do
    interface :notification_record
    field :id, non_null(:id)
    field :sender_id, :id
    field :sender_name, :string
    field :sender_thumb, :string
    field :sender_profile_id, :id
    field :read, non_null(:boolean)
    field :status, :string
    field :source, :string
    field :inserted_at, :time
    field :payload, :query_payload
  end

  object :query_payload do
    field :action_id, :string, resolve: key("action_id")
    field :action, :string, resolve: key("action")
    field :title, :string, resolve: key("title")
    field :body, :string, resolve: key("body")
    field :url, :string, resolve: key("url")
    field :vote_type, :string, resolve: key("vote_type")
  end

  object :notification do
    interface :notification_record
    field :id, non_null(:id)
    field :read, :boolean, default_value: false
    field :status, :string
    field :sender_id, :id
    field :sender_name, :string
    field :sender_thumb, :string
    field :sender_profile_id, :id
    field :source, :string
    field :inserted_at, :time
    field :payload, :payload
  end

  object :receiver do
    field :user_id, non_null(:string)
    field :read, non_null(:boolean)
    field :status, :string
  end

  object :payload do
    field :action_id, :string
    field :action, :string
    field :title, :string
    field :body, :string
    field :url, :string
    field :vote_type, :string
  end

  def key(k) do
    fn m, _, _ -> {:ok, m[k]} end
  end
end
