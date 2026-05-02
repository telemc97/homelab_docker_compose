#!/bin/bash

# manage_stack.sh: Pull and start all docker-compose services in the homelab

# Get the absolute path of the repository root
# Assuming the script is in REPO_ROOT/scripts/
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Initialize exclusion list
EXCLUDES=()

# Function to display usage
usage() {
    echo "Usage: $0 [-e <exclude_dir>] [-h]"
    echo "  -e <exclude_dir>  Exclude a specific service directory (can be used multiple times)"
    echo "  -h                Show this help message"
    exit 1
}

# Parse command-line arguments
while getopts ":e:h" opt; do
  case $opt in
    e)
      EXCLUDES+=("$OPTARG")
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      ;;
  esac
done

echo "Starting homelab update process..."
echo "=================================="

if [ ${#EXCLUDES[@]} -gt 0 ]; then
    echo "Excluding services: ${EXCLUDES[*]}"
    echo "----------------------------------"
fi

# Find all docker-compose.yaml files in subdirectories
# Using -maxdepth 2 to target <service>/docker-compose.yaml
# Exclude the 'scripts' directory from the find
find "$REPO_ROOT" -maxdepth 2 -name "docker-compose.yaml" | while read -r compose_file; do
    service_dir=$(dirname "$compose_file")
    compose_filename=$(basename "$compose_file")
    service_name=$(basename "$service_dir")

    # Check if the service_name is in the exclude list
    skip=false
    for exclude in "${EXCLUDES[@]}"; do
        if [ "$service_name" == "$exclude" ]; then
            skip=true
            break
        fi
    done

    if [ "$skip" == "true" ]; then
        echo ">>> Skipping excluded service: $service_name"
        echo "----------------------------------"
        continue
    fi

    echo ">>> Processing service: $service_name"
    echo "    File: $compose_filename"
    
    # Change to service directory to ensure .env files are correctly loaded
    pushd "$service_dir" > /dev/null || { echo "Error: Could not enter $service_dir"; continue; }

    # Pull latest images as defined in the compose file
    echo "    Pulling images..."
    docker-compose -f "$compose_filename" pull

    # Start or update the containers in detached mode
    echo "    Starting containers..."
    docker-compose -f "$compose_filename" up -d

    popd > /dev/null
    echo ">>> Done with $service_name"
    echo "----------------------------------"
done

echo "=================================="
echo "All services have been processed."
