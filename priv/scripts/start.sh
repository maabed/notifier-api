#!/usr/bin/env bash
set -e

while ! pg_isready -q -h $PG_HOST -p "5432" -U $PG_USER
do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done

echo "Postgres is available: Running Notifir db migrations..."
/opt/notifier/bin/sapien_notifier eval 'SapienNotifier.ReleaseTasks.migrate()'

if [[ "$SEED_DATA" == 1 ]]; then
	echo "Seeding..."
  /opt/notifier/bin/sapien_notifier eval 'SapienNotifier.ReleaseTasks.seed()'
	echo "Notifier db seed run successfully"
fi

# Launch the OTP release and replace the caller as Process #1 in the container
echo "Launching Notifier OTP release..."
exec /opt/notifier/bin/sapien_notifier  "$@"
