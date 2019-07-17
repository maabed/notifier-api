defmodule Notifier.Repo.Migrations.CleanupRecordsInNotifications do
  @moduledoc false
  use Ecto.Migration

  def up do
    execute "DELETE FROM notifications WHERE sender_profile_id = 'undefined'"
  end

  def down do
  end
end
