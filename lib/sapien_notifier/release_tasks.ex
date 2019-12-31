defmodule SapienNotifier.ReleaseTasks do
  require Logger
  import Ecto.Query, warn: false
  alias SapienNotifier.{Repo, SapienRepo}
  alias SapienNotifier.Notifier.{Notification, Receiver}
  alias Ecto.Adapters.SQL
  use Ecto.Migration

  @repo_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto_sql
  ]

  @repos Application.get_env(:sapien_notifier, :ecto_repos, [])

  def migrate(args \\ []) do
    {:ok, _} = Application.ensure_all_started(:logger)
    Logger.info("[task] running migrate")
    start_repos()

    run_migrations(args)

    Logger.info("[task] finished migrate")
    stop()
  end

  def rollback(args \\ []) do
    {:ok, _} = Application.ensure_all_started(:logger)
    Logger.info("[task] running rollback")
    start_repos()

    run_rollback(args)

    Logger.info("[task] finished rollback")
    stop()
  end

  def seed(args \\ []) do
    {:ok, _} = Application.ensure_all_started(:logger)
    Logger.info("[task] running seed")
    start_repos()

    run_migrations(args)
    run_seeds()

    Logger.info("[task] finished seed")
    stop()
  end

  def restart() do
    Logger.info("[task] Stopping Notifier...")
    :ok = Application.stop(:sapien_notifier)
    Logger.info("[task] Notifier stopped. Restarting...")
    {:ok, _}  =  Application.ensure_all_started(:sapien_notifier)
    Logger.info("[task] Notifier restarted.")
  end

  def start_app() do
    IO.puts("Starting app...")
    {:ok, _} = Application.ensure_all_started(:sapien_notifier)
  end

  defp start_repos() do
    IO.puts("Starting dependencies...")
    Enum.each(@repo_apps, fn app ->
      {:ok, _} = Application.ensure_all_started(app)
    end)

    IO.puts("Starting repos...")
    :ok = Application.load(:sapien_notifier)

    Enum.each(@repos, fn repo ->
      {:ok, _} = repo.start_link(pool_size: 2)
    end)
  end

  def start_sapien_repo() do
    IO.puts("Starting dependencies...")
    Enum.each(@repo_apps, fn app ->
      {:ok, _} = Application.ensure_all_started(app)
    end)

    IO.puts("Starting repos...")
    Application.load(:sapien_notifier)

    SapienRepo.start_link(pool_size: 20)
    Repo.start_link(pool_size: 20)
  end

  defp stop() do
    IO.puts("Stopping...")
    :init.stop()
  end

  defp run_migrations(args) do
    Enum.each(@repos, fn repo ->
      app = Keyword.get(repo.config(), :otp_app)
      IO.puts("Running migrations for #{app}")

      case args do
        ["--step", n] -> migrate(repo, :up, step: String.to_integer(n))
        ["-n", n] -> migrate(repo, :up, step: String.to_integer(n))
        ["--to", to] -> migrate(repo, :up, to: to)
        ["--all"] -> migrate(repo, :up, all: true)
        [] -> migrate(repo, :up, all: true)
      end
    end)
  end

  defp run_rollback(args) do
    Enum.each(@repos, fn repo ->
      app = Keyword.get(repo.config(), :otp_app)
      IO.puts("Running rollback for #{app}")

      case args do
        ["--step", n] -> migrate(repo, :down, step: String.to_integer(n))
        ["-n", n] -> migrate(repo, :down, step: String.to_integer(n))
        ["--to", to] -> migrate(repo, :down, to: to)
        ["--all"] -> migrate(repo, :down, all: true)
        [] -> migrate(repo, :down, step: 1)
      end
    end)
  end

  defp migrate(repo, direction, opts) do
    migrations_path = priv_path_for(repo, "migrations")
    Ecto.Migrator.run(repo, migrations_path, direction, opts)
  end

  def run_seeds() do
    Enum.each(@repos, &run_seeds_for/1)
  end

  defp run_seeds_for(repo) do
    # Run the seed script if it exists
    seed_script = priv_path_for(repo, "seeds.exs")

    if File.exists?(seed_script) do
      IO.puts("Running seed script...")
      Code.eval_file(seed_script)
    end
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config(), :otp_app)
    priv_dir = Application.app_dir(app, "priv")

    Path.join([priv_dir, "repo", filename])
  end

  def sapien_db_migration() do
    start_sapien_repo()

    case migration_status() do
      :ok ->
        {:ok, pid} = point_and_restart_repo()
        Logger.info("Repo pid: #{inspect pid}")
        Logger.warn("Database schema is up-to-date")
        :ok
      {:error, _, _} ->
        Logger.info "Stars Sapien DB migration ......"

        # count notifications, receiver records on notifier db
        check_data(Repo, "[Notifier db] before migration")

        # run the sapien_repo migration
        Logger.info("Transfering data .....")
        run_sapien_migrate()
        check_data(SapienRepo, "[Sapien db] after migration")
        # Point Repo to sapien_db so new records goes to sapien db this done by retrieves the runtime repo configs and pass it to init as :supervisor context
        {:ok, pid} = point_and_restart_repo()
        Logger.info("Repo pid: #{inspect pid}")
        # confirm notifications, receiver records count on sapien db
        check_data(Repo, "[Sapien db] after point and restart repo")
    end
  end

  defp run_sapien_migrate() do
    path = Application.app_dir(:sapien_notifier, "priv/sapien_repo/migrations")
    Logger.info("Migration path: #{inspect path}")
    versions = Ecto.Migrator.run(SapienRepo, path, :up, all: true)
    :timer.sleep(1000)
    transfer_table("notifications")
    :timer.sleep(1000)
    transfer_table("receivers")
    :timer.sleep(1000)
    Logger.info("Migration versions: #{inspect versions}")
    :timer.sleep(1000)
    :ok
  end

  def transfer_table(targeted_table) do
    started = System.monotonic_time()
    max_concurrency = System.schedulers_online * 2
    query = "SELECT * FROM #{targeted_table}"
    results =
      Repo.transaction(fn ->
        SQL.stream(Repo, query)
        |> Stream.map(fn %Postgrex.Result{columns: columns, rows: rows} ->
          rows
          |> Enum.map(fn row ->
            columns
            |> Enum.zip(row)
            |> Enum.into(%{})
          end)
        end)
        |> Task.async_stream(fn rows ->
          case rows do
            rows when is_list(rows) ->
              {count, _} = insert_all_rows(targeted_table, rows)
              Logger.warn("Insterted count: #{inspect count}")
              {:ok, count}
              _ -> Logger.warn("NOT A LIST")
          end
        end,
        max_concurrency: max_concurrency, timeout: :infinity, log: false)
        |> Stream.run()
      end)

    Logger.info("Transfer Stream results: #{inspect results}")
    ended = System.monotonic_time()
    time = System.convert_time_unit(ended - started, :native, :millisecond)
    Logger.info "#{targeted_table} transferred in #{time} millisecond(s)"
    results
  end


  defp insert_all_rows(table, rows) do
    SapienRepo.insert_all(table, rows, on_conflict: :nothing, log: false)
  end

  def migration_status() do
    latest_migration = Application.app_dir(:sapien_notifier, "priv/sapien_repo/migrations")
    |> File.ls!
    |> Enum.max
    |> String.split("_", parts: 2)
    |> List.first
    |> String.to_integer

    Logger.info("latest_migration #{inspect latest_migration}")

    # Perform similar logic to see what's latest in the database
    latest_applied_migration = Enum.max(Ecto.Migrator.migrated_versions(SapienRepo), fn -> :not_found end)
    Logger.info("latest_applied_migration #{inspect latest_applied_migration}")


    if latest_applied_migration == latest_migration do
      :ok
    else
      {:error, latest_applied_migration, latest_migration}
    end
  end

  def point_and_restart_repo() do
    sapien_db_url = System.get_env("SAPIEN_DATABASE_URL")
    # switch DATABASE_URL <== SAPIEN_DATABASE_URL
    System.put_env("DATABASE_URL", sapien_db_url)

    opts = Repo.config
    Supervisor.stop(Repo, :normal)
    :timer.sleep(1000)
    Repo.init(:supervisor, opts)

    case Repo.start_link(opts) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> {:ok, pid}
      error ->
        Logger.warn("Error on start_link: #{inspect error}")
        error
    end
  end

  def check_data(repo, stage) do
    notifications = repo.one(from n in Notification, select: count(n.id))
    receivers = repo.one(from r in Receiver, select: count(r.id))
    Logger.info("Counts #{stage}: [Notifications: #{inspect notifications} Receivers: #{inspect receivers}]")
    :ok
  end
end
