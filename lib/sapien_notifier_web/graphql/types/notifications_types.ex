defmodule SapienNotifierWeb.Type.Notifications do
  @moduledoc """
  Notifications type
  """
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: SapienNotifier.Repo

  object :notification do
    field :id, non_null(:id)
    field :user_ids, non_null(list_of(:id))
    field :action, :string
    field :payload, :payload
    field :source, :string
    field :target, :string
  end

  object :payload do
    field :title, :string
    field :body, :string
    field :url, :string
  end
end
