defmodule SapienNotifierWeb.Type.Notifications do
  @moduledoc """
  Notifications type
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: SapienNotifier.Repo
  import_types Absinthe.Type.Custom

  object :notification do
    field :id, non_null :id
    field :user_id, non_null :id
    field :action, :string
    field :payload, :payload
    field :source, :string
    field :inserted_at, :naive_datetime
  end

  object :payload do
    field :title, :string
    field :body, :string
    field :url, :string
  end
end
