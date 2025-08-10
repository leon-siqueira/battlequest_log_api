#!/bin/sh

echo "Starting entrypoint script..."

cd /app || exit 1

# Wait for database to be ready
until pg_isready -h db -p 5400; do
  echo "Waiting for database..."
  sleep 1
done

# Check if database has tables (more reliable than a flag file)
if ! bundle exec rails runner 'exit ActiveRecord::Base.connection.tables.any?'; then
  echo "Database appears empty. Running setup..."
  bundle exec rails db:reset
else
  echo "Database already contains tables. Skipping initialization."
fi

# Run migrations in any case to handle schema changes
bundle exec rails db:migrate

# Execute the original command
exec "$@"
