import Ecto.Query, warn: false
require Logger
alias SapienNotifier.Notifier.{Notification, Receiver}
alias SapienNotifier.Repo

names = [
  "Sabbir_Ahmed_Siddiquee",
  "Cristian_Dascalu",
  "Roman_Butusov",
  "Marco_Tabasco",
  "Katya_de_la_Rosa",
  "Ethaanpump",
  "Hasan_Tekin",
  "Mahmoud_Abed",
  "Lynn_Connolly",
  "Robert_Giometti",
  "Ankit_Bhatia",
  "Javier_Ocanas"
]

actions = [
  "mention",
  "reply",
  "post",
  "comment",
  "echo",
  "selected",
  "moderatorInvite",
  "tribeInvite",
  "follow",
  "requested"
]

Enum.each(0..1_000, fn _ ->
  alphabet = Enum.to_list(?a..?z) ++ Enum.to_list(?0..?9)
  sender_name = Enum.random(names)
  action = Enum.random(actions)
  action_id = alphabet |> Enum.take_random(33) |> to_string

  {:ok, notification} =
    %Notification{}
    |> Notification.changeset(%{
      sender_id: alphabet |> Enum.take_random(33) |> to_string,
      sender_name: sender_name,
      sender_thumb: "http://sapien.network/@#{sender_name}",
      sender_profile_id: alphabet |> Enum.take_random(33) |> to_string,
      payload: %{
        url: "http://sapien.network/@#{sender_name}/#{action_id}",
        body: action,
        title: action,
        action: action,
        action_id: action_id,
        vote_type: "up"
      }
    })
    |> Repo.insert(log: false)

    Enum.each(0..5, fn _n ->
      %Receiver{}
      |> Receiver.changeset(%{
          notification_id: notification.id,
          user_id: alphabet |> Enum.take_random(33) |> to_string,
          read: false,
          status: "UNREAD"
      })
      |> Repo.insert(log: false)
  end)
end)
