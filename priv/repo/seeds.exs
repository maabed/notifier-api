
defmodule SapienNotifier.Seed do
  @moduledoc false

  import Ecto.Query, warn: false
  require Logger
  alias SapienNotifier.Notifier.{Notification, Receiver}
  alias SapienNotifier.Repo

  defp random_hex_bytes(num \\ 8) do
    :crypto.strong_rand_bytes(num) |> Base.encode16
  end

  def run do
    Enum.each(0..200_000, fn _ ->
      random_id = random_hex_bytes(12)

      {:ok, notification} =
        Repo.insert(%Notification{
          sender_id: random_id,
          sender_name: "tester",
          sender_thumb: "http://sapien.network/@tester",
          sender_profile_id: random_id,
          payload: %{
            url: "http://sapien.network/@tester/#{random_id}",
            body: "post",
            title: "post",
            action: "post",
            action_id: random_id,
            vote_type: "up"
          }
        }, log: false)

        Enum.each(0..5, fn _n ->
          Repo.insert(%Receiver{
            notification_id: notification.id,
            user_id: random_id,
            read: false,
            status: "UNREAD"
          }, log: false)
      end)
    end)
  end
end

SapienNotifier.Seed.run()
