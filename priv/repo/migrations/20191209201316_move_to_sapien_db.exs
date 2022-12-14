defmodule SapienNotifier.Repo.Migrations.MoveDataToSapienDb do

  use Ecto.Migration
  import Ecto.Query, warn: false
  require Logger

  alias SapienNotifier.Repo
  alias Ecto.Adapters.SQL

  @chunk_size 10_000

  def change do
    # old migration process using pg copy, the new version available on ReleaseTasks
    # but we still need this file to put update migrations version on notifier_migrations
    # table on sapien db, so it didn't call on app restart.
    Logger.warn("20191209201316 migration done")
    # Repo.start_link()
    # SapienRepo.start_link()
    # migrate()
  end

  # defp migrate do
  #   migrate_notifications()
  #   migrate_receivers()
  # end

  # defp migrate_notifications do
  #   columns = [:id, :sender_id, :sender_name, :sender_thumb, :sender_profile_id, :source, :payload, :inserted_at, :updated_at]
  #   query =
  #   """
  #     COPY (SELECT
  #       id,
  #       sender_id,
  #       sender_name,
  #       sender_thumb,
  #       sender_profile_id,
  #       source,
  #       payload->>'url' AS url,
  #       payload->>'body' AS body,
  #       payload->>'title' AS title,
  #       payload->>'action' AS action,
  #       payload->>'action_id' AS action_id,
  #       payload->>'vote_type' AS vote_type,
  #       inserted_at,
  #       updated_at
  #     FROM notifications)
  #     TO '#{System.tmp_dir!() |> Path.join("notifications.csv")}' WITH (FORMAT CSV, HEADER TRUE, DELIMITER '|', NULL '', quote E'\x01')
  #   """
  #   build_and_export("notifications", columns, query)
  # end

  # defp migrate_receivers do
  #   columns = [:id, :user_id, :read, :status, :notification_id, :inserted_at, :updated_at]
  #   query =  """
  #   COPY (SELECT
  #       id,
  #       user_id,
  #       CASE WHEN read = TRUE THEN 'TRUE' ELSE 'FALSE' END AS read,
  #       status,
  #       notification_id,
  #       inserted_at,
  #       updated_at
  #     FROM receivers)
  #     TO '#{System.tmp_dir!() |> Path.join("receivers.csv")}' WITH (FORMAT CSV, HEADER TRUE, DELIMITER '|', NULL '', quote E'\x01')
  #   """

  #   build_and_export("receivers", columns, query)
  # end

  # defp build_and_export(table, columns, query) do
  #   Logger.warn("Repo.config => #{inspect Repo.config}")

  #   path = System.tmp_dir!() |> Path.join("#{table}.csv")
  #   Logger.warn("export #{table} csv file to => #{path}")
  #   started = System.monotonic_time()

  #   Repo.transaction( fn ->
  #     SQL.stream(Repo, query)
  #     |> Stream.drop(1)
  #     |> Stream.map(fn row -> Enum.map(columns, &Map.get(&1, row)) end)
  #     |> CSV.encode(separator: ?|, headers: columns)
  #     |> Enum.into(File.stream!(path, [:write, :utf8]))
  #     end,
  #    timeout: :infinity, log: true
  #   )

  #   ended = System.monotonic_time()
  #   time = System.convert_time_unit(ended - started, :native, :millisecond)

  #   Logger.info "#{table} exported in #{time} millisecond(s)"

  #   transfer(path, table)
  # end

  # defp transfer(path, table) do
  #   Logger.debug "Start importing"
  #   started = System.monotonic_time()
  #   Logger.warn("SapienRepo.config => #{inspect SapienRepo.config}")

  #   path
  #   |> File.stream!()
  #   |> CSV.decode(separator: ?|, headers: true)
  #   |> Stream.reject(fn
  #     {:ok, _map} -> false
  #     {:error, _reason} -> true
  #   end)
  #   |> Stream.map(fn {:ok, map} ->
  #     map
  #     |> Enum.into(%{}, fn {k, v} ->
  #       {String.to_atom(k), v}
  #     end)
  #     |> normalize(table)
  #   end)
  #   |> Stream.chunk_every(@chunk_size)
  #   |> Task.async_stream((fn rows ->
  #     insert_rows(table, rows)
  #   end), max_concurrency: 4, timeout: :infinity)
  #   |> Stream.run()

  #   ended = System.monotonic_time()
  #   time = System.convert_time_unit(ended - started, :native, :millisecond)
  #   Logger.info "#{table} imported in #{time} millisecond(s)"
  # end

  # defp normalize(entry, table) do
  #   case table do
  #     "notifications" ->
  #       %{
  #         id: uuid_to_bin(entry.id),
  #         sender_id: entry.sender_id,
  #         sender_name: entry.sender_name,
  #         sender_thumb: entry.sender_thumb,
  #         sender_profile_id: entry.sender_profile_id,
  #         source: entry.source,
  #         payload: %{
  #           url: entry.url,
  #           body: entry.body,
  #           title: entry.title,
  #           action: entry.action,
  #           action_id: entry.action_id,
  #           vote_type: entry.vote_type,
  #         },
  #         inserted_at: parse_ts(entry.inserted_at),
  #         updated_at: parse_ts(entry.updated_at)
  #       }

  #     "receivers" ->
  #       %{
  #         id: uuid_to_bin(entry.id),
  #         user_id: entry.user_id,
  #         read: entry.read == "true",
  #         status: entry.status,
  #         notification_id: uuid_to_bin(entry.notification_id),
  #         inserted_at: parse_ts(entry.inserted_at),
  #         updated_at: parse_ts(entry.updated_at)
  #       }
  #   end
  # end

  # defp insert_rows(table, rows) do
  #   Logger.warn "Patch length => #{inspect length(rows) * 4}"
  #   SapienRepo.insert_all(table, rows, on_conflict: :nothing)
  # end

  # def get_path(table) do
  #   path = Path.join(Application.app_dir(:sapien_notifier, "priv/db_csv"), "#{table}.csv")

  #   case File.read(path) do
  #     {:ok, _} -> path
  #     {:error, _reason} ->
  #       :code.priv_dir(:sapien_notifier)
  #       |> Path.join("db_csv/#{table}.csv")
  #       |> String.replace_leading("/", "")
  #   end
  # end

  # defp uuid_to_bin(uuid) do
  #   {:ok, bin} = Ecto.UUID.dump(uuid)
  #   bin
  # end

  # defp parse_ts(time) do
  #   time
  #   |> NaiveDateTime.from_iso8601!()
  #   |> DateTime.from_naive!("Etc/UTC")
  # end
end
