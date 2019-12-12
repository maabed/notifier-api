#!/bin/sh
# Adapted from Alex Kleissner's post, Running a Phoenix 1.3 project with docker-compose
# https://medium.com/@hex337/running-a-phoenix-1-3-project-with-docker-compose-d82ab55e43cf

set -e

# Ensure the app's dependencies are installed
#mix deps.get

# Wait for Postgres to become available.
until psql -h $PG_HOST -p "5432" -d $PG_DATABASE -U $PG_USER -w -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "\nPostgres is available: continuing with database setup..."

# Potentially Set up the database
# mix ecto.create
# mix ecto.migrate

# echo "\nTesting the installation..."
# "Proove" that install was successful by running the tests
# mix test

echo "\n Launching Phoenix web server..."
# Start the phoenix web server
mix phx.server
