# Alias this container as builder:
FROM bitwalker/alpine-elixir-phoenix as builder

ARG SECRET_KEY_BASE
ARG DATABASE_URL
ARG PORT

#COPY rel ./rel
#COPY config ./config
#COPY lib ./lib
#COPY priv ./priv
#COPY mix.exs .
#COPY mix.lock .

COPY . .

RUN export MIX_ENV=prod && \
#    mix do deps.get, compile && \
    mix deps.get
#    mix release.init
#    mix ecto.setup

#RUN APP_NAME="notifier" && \
#    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
#    mkdir /export && \
#    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

ENTRYPOINT ["/bin/bash", "-c", "mix"]
CMD ["phx.server"]
