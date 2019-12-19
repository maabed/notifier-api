# Step 1 - Build the OTP binary
FROM elixir:1.9.4-alpine AS builder

ARG SECRET_KEY_BASE=123
ENV MIX_ENV=prod

WORKDIR /build

RUN apk update && \
    apk upgrade && \
    apk add -U git

RUN mix local.rebar --force && \
    mix local.hex --force

COPY mix.* ./
COPY lib lib
COPY priv priv
COPY config config
COPY rel rel
COPY mix.exs .
COPY mix.lock .

RUN mix deps.get --only prod
RUN mix deps.compile --only prod
RUN mix compile --only prod

RUN mkdir -p /opt/build && \
    mix release && \
    cp -R _build/prod/rel/sapien_notifier/* /opt/build

# Step 2 - Build a lean runtime container
FROM alpine:3.9

RUN apk update && \
    apk upgrade && \
    apk add -U bash openssl postgresql-client

# -no-cache

WORKDIR /opt/notifier

# Copy the OTP binary and assets deps from the build step
COPY --from=builder /opt/build .

# Copy the entrypoint script
COPY priv/scripts/start.sh /usr/local/bin
RUN chmod a+x /usr/local/bin/start.sh

# Create a non-root user
RUN adduser -D notifier && chown -R notifier: /opt/notifier

USER notifier

EXPOSE 443 80 9000

ENTRYPOINT ["start.sh"]
CMD ["start"]
