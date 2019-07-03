defmodule NotifierWeb.Type.Unseens do
  @moduledoc """
  Unseens type
  """

  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Notifier.Repo

  object :unseen do
    field :id, non_null(:id)
    field :user_id, non_null(:string)
    field :tribe_id, non_null(:boolean)
    field :count, non_null(:integer)
    field :inserted_at, :time
  end
end
