defmodule Notifier.Repo.Migrations.RemoveDuplicateRecordsInReveivers do
  @moduledoc """
  remove duplicate records in receivers due to a bug on sapien BE,
  where it was duplicates receiverIds
  """
  use Ecto.Migration

  def up do
    execute """
    WITH "unique" AS (SELECT DISTINCT ON (notification_id, user_id) * FROM receivers)
    DELETE FROM receivers WHERE receivers.id NOT IN (SELECT id FROM "unique")
    """

    flush()
    drop_if_exists index(:receivers, [:notification_id, :user_id])
    create unique_index(:receivers, [:notification_id, :user_id])
  end

  def down do
    drop_if_exists unique_index(:receivers, [:notification_id, :user_id])
    create_if_not_exists index(:receivers, [:notification_id, :user_id])
  end
end
