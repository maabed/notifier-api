# Sapien Notifier
Sapien microservice to handle sapien in-App notifications, emails and push notifications, This microservice used in combination with main sapien backend and frontend.

### Developer Setup

You'll need to install the following dependencies first:
* [Elixir](https://elixir-lang.org/install.html) 1.8.2
* [PostgreSQL](https://postgresapp.com/) 10

To start notification server:
* Create `.env` file and add `JWT_PUBLIC_KEY` value from 1password
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server`

Graphql endpoint at [`localhost:9000/api/graphql`](http://localhost:9000/api/graphql)
GraphiQL playground at [`localhost:9000/api/graphiql`](http://localhost:9000/api/graphiql)

### Notification schema

Notification object:

```elixir

notification {
  id: id
  sender_id: string # sender userId
  sender_name: string # sender user name
  sender_thumb: string # sender thumbnail
  sender_profile_id: string # sender profileId
  source: string # sapien platform, wallet, chat
  payload: {
    action: string # comment, post, reply, echo ... etc
    action_id: string # commentId, postId, ... etc
    title: string
    content: string
    url: string
    vote_type: string # comment or post
  }
}
```

Receivers userIds stored on another table: notification `has_many` receivers

```elixir
receivers {
  userId: string
  read: boolean
  status: string
}

```

`devices`and `target` will be added once email, SMS and push notifications implemented.

#### Docker local setup

Note: Make sure your .env contents are the same as the ones from https://sapien.1password.com/vaults/ajcgx3zogtvg6xo7qkzou5jjd4/allitems/42y5t5dptknkepktfslvffv3q4

Run following commands

* Build docker image `docker build -t sapien-notifier .`
* Start notifier container and database `docker-compose -f docker-compose-local.yaml up -d`

Debugging

* Check if all containers are running `docker-compose -f docker-compose-local.yaml ps`
* Check the healthcheck endpoint `curl http://localhost/api/health`
* Check the notifier logs  `docker logs -f local-notifier`
* Enter the running notifier container `docker exec -it local-notifier bash`

GraphiQL playground at [`localhost/api/graphiql`](http://localhost/api/graphiql)

### Production

[deployment guides](https://hexdocs.pm/phoenix/deployment.html).

The following environment variables must be set in production:

<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  <thead>
  <tbody>
    <tr>
      <td><code>PORT</code></td>
      <td>The port on which to host the application: 80.</td>
    </tr>
    <tr>
      <td><code>HOST</code></td>
      <td>The domain on which you are serving the app.</td>
    </tr>
    <tr>
      <td><code>DATABASE_URL</code></td>
      <td>The URL for the PostgreSQL database.</td>
    </tr>
    <tr>
      <td><code>POOL_SIZE</code></td>
      <td>The maximum number of database connections each process may consume.</td>
    </tr>
    <tr>
      <td><code>GUARDIAN_SECRET_KEY</code></td>
      <td>A secret key for guardian library used for <code>HS512</code> algos, use <code>mix guardian.gen.secret</code> to get one.</td>
    </tr>
    <tr>
      <td><code>JWT_PUBLIC_KEY</code></td>
      <td>JWT public key to verify JWT sends from sapien backend, should be the same as <code>public.pem</code> on sapien backend.</td>
    </tr>
    <tr>
      <td><code>SECRET_KEY_BASE</code></td>
      <td>A secret key for verifying the integrity of signed cookies, use <code>mix phx.gen.secret</code> to get one.</td>
    </tr>
  </tbody>
</table>
