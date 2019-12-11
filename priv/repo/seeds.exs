import Ecto.Query, warn: false
require Logger
alias SapienNotifier.Notifier.{Notification, Receiver}
alias SapienNotifier.Repo

Enum.each(0..300, fn _ ->
  {:ok, notification} =
    %Notification{}
    |> Notification.changeset(%{
      sender_id: Faker.Address.geohash,
      sender_name: Faker.Internet.user_name,
      sender_thumb: Faker.Avatar.image_url,
      sender_profile_id: Faker.Address.geohash,
      payload: %{
        url: Faker.Internet.url,
        body: Faker.Name.title,
        title: Faker.Name.title,
        action: Faker.Name.last_name,
        action_id: Faker.Address.geohash,
        vote_type: "what ever"
      }
    })
    |> Repo.insert()

    Enum.each(0..5, fn _n ->
      %Receiver{}
      |> Receiver.changeset(%{
          notification_id: notification.id,
          user_id: Faker.Address.geohash,
          read: false,
          status: "UNREAD"
      })
      |> Repo.insert()
  end)
end)
