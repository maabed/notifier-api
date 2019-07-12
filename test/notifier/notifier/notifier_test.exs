defmodule Notifier.NotifierTest do
  use Notifier.DataCase

  alias Notifier

  describe "notifications" do
    alias Notifier.Notification

    @valid_attrs %{
      action: "some action",
      devices: [],
      payload: %{},
      source: "some source",
      target: [],
      user_ids: []
    }
    @update_attrs %{
      action: "some updated action",
      devices: [],
      payload: %{},
      source: "some updated source",
      target: [],
      user_ids: []
    }
    @invalid_attrs %{
      action: nil,
      devices: nil,
      payload: nil,
      source: nil,
      target: nil,
      user_ids: nil
    }

    def notification_fixture(attrs \\ %{}) do
      {:ok, notification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Notifier.create_notification()

      notification
    end

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Notifier.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Notifier.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      assert {:ok, %Notification{} = notification} = Notifier.create_notification(@valid_attrs)
      assert notification.action == "some action"
      assert notification.devices == []
      assert notification.payload == %{}
      assert notification.source == "some source"
      assert notification.target == []
      assert notification.user_ids == []
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notifier.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()

      assert {:ok, %Notification{} = notification} =
               Notifier.update_notification(notification, @update_attrs)

      assert notification.action == "some updated action"
      assert notification.devices == []
      assert notification.payload == %{}
      assert notification.source == "some updated source"
      assert notification.target == []
      assert notification.user_ids == []
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Notifier.update_notification(notification, @invalid_attrs)

      assert notification == Notifier.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Notifier.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Notifier.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Notifier.change_notification(notification)
    end
  end
end
