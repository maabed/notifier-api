defmodule SapienNotifier.Repo.Migrations.UpdatePostUrl do
  @moduledoc false

  use Ecto.Migration
  import Ecto.Query, warn: false
  require Logger

  alias SapienNotifier.Notifier.Notification
  alias SapienNotifier.{Repo, SapienRepo}
  alias Ecto.Adapters.SQL

  def change do
    SapienRepo.start_link()
    migrate_url()
  end

  defp migrate_url do
    query =
      from n in Notification,
        where: not is_nil(n.payload),
        where: fragment("""
          (payload->>'url' != 'undefined') AND
          (payload->>'action' NOT IN ('moderatorInvite', 'follow'))
        """),
        select: %{
          id: n.id,
          payload: n.payload,
          username: n.sender_name
        }

    Repo.all(query)
    |> Enum.map(fn %{id: id, payload: payload, username: username} ->
      if String.contains?(Map.get(payload, "url"), "post/") do
        post_id =
          payload
          |> Map.get("url")
          |> String.split("/", trim: true)
          |> List.last()

          update_payload(id, post_id, username, payload)
      else
        if String.contains?(Map.get(payload, "url"), "tribe/") do
          tribe_id =
            payload
            |> Map.get("url")
            |> String.split("/", trim: true)
            |> List.delete("posts")
            |> List.last()

            update_payload(id, tribe_id, payload)
        end
      end
    end)
  end

  defp update_payload(id, post_id, username, payload) when not is_nil(post_id) do
    case post_query(post_id) do
      %{"title" => title, "short_id" => short_id, "orignal_id" => orignal_id, "tribe_name" => tribe_name} ->
        if orignal_id == post_id do
          url = format_url(tribe_name, username, title, short_id)
          payload = Map.put(payload, "url", url)
          Logger.info "Found Post N post_id : #{inspect post_id}"
          perform_update(id, payload)
        else
          Logger.warn "Invalid payload [post_id]: notifier db => #{post_id} sapien db => #{orignal_id}"
        end
      nil -> :ok
    end
  end

  defp update_payload(id, tribe_id, payload) when not is_nil(tribe_id) do
    case tribe_query(tribe_id) do
      %{"name" => tribe_name, "orignal_id" => orignal_id} ->
        if orignal_id == tribe_id do
          url = format_url(tribe_name)
          payload = Map.put(payload, "url", url)
          Logger.info "Found Tribe N tribe_id : #{inspect tribe_id}"
          perform_update(id, payload)
        else
          Logger.warn "Invalid payload [tribe_id]: notifier db => #{tribe_id} sapien db => #{orignal_id}"
        end
      nil -> :ok
    end
  end

  defp post_query(post_id) do
    query = """
      SELECT
        p._id AS orignal_id,
        p.title,
        p.tribe_id,
        p."shortId" AS short_id,
        t.name AS tribe_name
      FROM posts AS p
      LEFT JOIN tribes AS t ON t._id = p.tribe_id
      WHERE p._id = '#{post_id}'
    """
    execute_query(query)
  end

  defp tribe_query(tribe_id) do
    query = """
      SELECT name, _id AS orignal_id
      FROM tribes
      WHERE _id = '#{tribe_id}'
    """
    execute_query(query)
  end

  defp execute_query(query) do
    SQL.query!(SapienRepo, query)
    |> (fn %Postgrex.Result{columns: columns, rows: rows} ->
      if is_list(rows) and length(rows) > 0 do

        rows
        |> Enum.map(fn r ->
          columns
          |> Enum.zip(r)
          |> Enum.into(%{})
        end)
        |> List.first()

      end
    end).()
  end

  defp perform_update(id, payload) do
    Logger.info "Perform update for record: #{inspect id}"
    case Repo.get!(Notification, id) do
      %Notification{} = notification ->
        notification
        |> Ecto.Changeset.change(payload: payload)
        |> Repo.update()

        :ok
      err ->
        Logger.error "migrate url error =>: #{inspect err}"
        nil
    end
  end

  defp format_url(tribe_name, username, title, short_id) do
    username =
      username
      |> String.downcase()
      |> String.replace(~r/\s+/, "-")

    post_url =
      title
      |> String.downcase()
      |> String.replace(~r/\s+/, "-")
      |> String.replace(~r/[^A-Za-z0-9\-]/, "")
      |> String.replace(~r/\-\-+/, "-")
      |> String.replace(~r/^-+/, "")
      |> String.slice(0, 30)
      |> String.replace(~r/-+$/, "")
      |> Kernel.<>("-#{short_id}")

    "/t/#{tribe_name}/@#{username}/#{post_url}"
  end

  defp format_url(tribe_name) do
    "/t/#{tribe_name}/posts"
  end
end
