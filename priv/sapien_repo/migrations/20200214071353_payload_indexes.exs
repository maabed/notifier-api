defmodule SapienNotifier.SapienRepo.Migrations.PayloadIndexes do
  @doc false
  use Ecto.Migration

  def up() do
    execute("CREATE INDEX notifications_payload_action_idx ON notifications((payload->>'action'))")
  end

  def down() do
    execute("DROP INDEX IF EXISTS notifications_payload_action_idx")
  end
end
