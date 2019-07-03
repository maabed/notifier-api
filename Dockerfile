FROM elixir:1.9.0

ARG SECRET_KEY_BASE=123

# Install debian packages
RUN apt-get update
RUN apt-get install --yes build-essential inotify-tools postgresql-client

# Install Phoenix packages
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phx_new.ez

ENV MIX_ENV=prod

COPY . .

RUN mix deps.get
RUN mix do compile

EXPOSE 443 80 9000
#HEALTHCHECK CMD wget -q -O /dev/null http://localhost:9000/api/health || exit 1

CMD ["./run.sh"]
