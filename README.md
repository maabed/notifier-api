# Sapien Notifier
Sapien microservice to handle sapien in-App notifications, emails and push notifications, This microservice used in combination with main sapien backend and frontend.

### Developer Setup

You'll need to install the following dependencies first:
* [Elixir](https://elixir-lang.org/install.html) 1.7.4
* [PostgreSQL](https://postgresapp.com/) 10

To start notification server:
* Create `.env` file and add `JWT_PUBLIC_KEY` value from 1password
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server`

Graphql endpoint at [`localhost:9000/api/graphql`](http://localhost:9000/api/graphql)
GraphiQL playground at [`localhost:9000/api/graphiql`](http://localhost:9000/api/graphiql)

### Notification schema

```
noification {
  id: string
  user_id: string
  source: string //  sapien platform, chat, wallet
  data: {
    sender: String // user name
    senderId: String // user id
    action: String // comment, post, reply, echo ... etc
    actionId: String // commentId, postId, ... etc
    title: '....',
    content: '.....',
    url: '....'
  }
  inserted_at: date
  updated_at: date
}
```

`devices`and `target` will be added once email, SMS and push notifications implemented.

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
