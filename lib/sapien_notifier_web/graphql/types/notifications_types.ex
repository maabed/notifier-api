defmodule SapienNotifierWeb.Type.Notifications do
  @moduledoc """
  Notifications type
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: SapienNotifier.Repo
  import_types Absinthe.Type.Custom

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
    field :user_ids, list_of(non_null(:string))
    field :sender_id, :id
    field :sender_name, :string
    field :read, non_null(:boolean)
    field :source, :string
    field :inserted_at, :naive_datetime
    resolve_type fn _, _ -> nil end
  end

  object :query_notification do
    interface :notification_record
    field :id, non_null(:id)
    field :user_ids, list_of(non_null(:string))
    field :sender_id, :id
    field :sender_name, :string
    field :read, non_null(:boolean)
    field :source, :string
    field :inserted_at, :naive_datetime
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
    field :user_ids, list_of(non_null(:string))
    field :sender_id, :id
    field :sender_name, :string
    field :read, non_null(:boolean)
    field :source, :string
    field :inserted_at, :naive_datetime
    field :payload, :payload
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
