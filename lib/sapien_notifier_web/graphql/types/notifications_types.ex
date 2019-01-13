defmodule SapienNotifierWeb.Type.Notifications do
  @moduledoc """
  Notifications type
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: SapienNotifier.Repo
  import_types Absinthe.Type.Custom

  input_object :data_params do
    field :action_id, :string
    field :action, :string
    field :title, :string
    field :body, :string
    field :url, :string
  end

  object :notification do
    field :id, non_null(:id)
    field :user_id, non_null(:id)
    field :sender_id, :id
    field :sender_name, :string
    field :read, non_null(:boolean)
    field :source, :string
    field :data, :data_map
    field :inserted_at, :naive_datetime
  end

  object :data_map do
    field :action_id, :id, resolve: key("action_id")
    field :action, :string, resolve: key("action")
    field :title, :string, resolve: key("title")
    field :body, :string, resolve: key("body")
    field :url, :string, resolve: key("url")
  end

  def key(k) do
    fn m, _, _ -> {:ok, m[k]} end
  end
end
