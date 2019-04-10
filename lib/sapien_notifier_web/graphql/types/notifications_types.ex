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
    field :status, non_null(:string)
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
    field :status, :string, default_value: "UNREAD"
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
    field :status, non_null(:string)
  end

  object :payload do
    field :action_id, :string
    field :action, :string
    field :title, :string
    field :body, :string
    field :url, :string
    field :vote_type, :string
  end

  @desc """
  ISOz datetime formatISO 8601
  """
  scalar :time do
    parse(&Timex.parse(&1.value, "{ISO:Extended}"))
    serialize(&Timex.format!(&1, "{ISO:Extended}"))
  end

  @desc """
  Unix timestamp (in milliseconds).
  """
  scalar :timestamp do
    parse(&Timex.from_unix(&1.value, :millisecond))

    serialize(fn time ->
      DateTime.to_unix(Timex.to_datetime(time), :millisecond)
    end)
  end

  def key(k) do
    fn m, _, _ -> {:ok, m[k]} end
  end
end
