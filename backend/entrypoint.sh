#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails
rm -f /app/tmp/pids/server.pid

# Wait for DB if needed (Docker Compose ensures DB is ready)
# Run database migrations
rails db:migrate

# Start the Rails server
exec rails server -b 0.0.0.0
