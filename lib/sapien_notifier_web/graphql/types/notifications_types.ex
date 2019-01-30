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
end
