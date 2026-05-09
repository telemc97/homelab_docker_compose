#!/bin/bash
# scripts/restart_gluetun.sh: Restart Gluetun and dependent services

# Get the absolute path of the repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEDIA_STACK_DIR="${REPO_ROOT}/media_stack"

echo "Restarting the entire media_stack..."
pushd "$MEDIA_STACK_DIR" > /dev/null || { echo "Error: Could not enter $MEDIA_STACK_DIR"; exit 1; }

# Restarting the entire stack to ensure all services are refreshed.
docker compose restart

popd > /dev/null
echo "Media stack restart command issued successfully."
