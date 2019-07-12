defmodule Notifier.Repo.Migrations.UpdateTimestampsMicrosecond do
  use Ecto.Migration
  require Logger

  alias Notifier.Repo
  alias Notifier.Notification

  def change do
    alter table(:notifications) do
      modify :inserted_at, :utc_datetime_usec
      modify :updated_at, :utc_datetime_usec
    end

    alter table(:receivers) do
      modify :inserted_at, :utc_datetime_usec
      modify :updated_at, :utc_datetime_usec
    end

    flush()

    Repo.all(Notification)
    |> Enum.map(fn n ->
      ts = n.inserted_at |> get_microsecond()

      Logger.info "inserted_at AFTER: #{inspect DateTime.to_string ts}"
      case n do
        %Notification{} = n ->
          n
          |> Notification.update_inserted_at_changeset(%{inserted_at: ts})
          |> Repo.update()

          Logger.warn "[[[[[ inserted_at UPDATED ]]]]]"
        nil ->
          {:error, :not_found}
      end
    end)

  end

  defp get_microsecond(date) do
    {us, precision} = date.microsecond
    if {us, precision} == {0, 0} or {us, precision} == {0, 6} do
      Logger.info "New inserted_at generated => #{inspect DateTime.to_string date}"
      random_micro = Enum.random(100_000..999_999)
      %DateTime{date | microsecond: {random_micro, 6}}
    else
      Logger.warn "Same inserted_at used => #{inspect DateTime.to_string date}"
      date
    end
  end
end
