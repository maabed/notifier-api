defmodule NotifierWeb.Type.Scalars do
  @moduledoc """
  Notifications type
  """
  use Absinthe.Schema.Notation
  # import_types Absinthe.Type.Custom

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
end
