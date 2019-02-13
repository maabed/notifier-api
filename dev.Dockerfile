FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed port and env
ENV PORT=9000 MIX_ENV=dev

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

RUN mix do compile

CMD ["mix", "do", "ecto.migrate,", "phx.server"]