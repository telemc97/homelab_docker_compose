#!/bin/bash

# scripts/backup_stack.sh: Backup all persistent data paths defined in homelab .env files

# Get the absolute path of the repository root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Default settings
BACKUP_DEST="${REPO_ROOT}/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
VERBOSE=false

# Allowed prefixes for backup paths (security boundary check)
ALLOWED_PREFIXES=("/opt/" "/mnt/" "${REPO_ROOT}")

# Function to display usage
usage() {
    echo "Usage: $0 [-d <destination_dir>] [-v] [-h]"
    echo "  -d <destination_dir>  Directory to store backups (default: $REPO_ROOT/backups)"
    echo "  -v                   Enable verbose output for tar"
    echo "  -h                   Show this help message"
    echo ""
    echo "Note: This script may require 'sudo' if the target paths have restricted permissions (e.g., in /opt/)."
    exit 1
}

# Function to validate if a path is safe (no path traversal)
is_safe_path() {
    local path="$1"
    if [[ "$path" == *".."* ]]; then
        return 1
    fi
    return 0
}

# Function to check if a path starts with an allowed prefix
is_allowed_path() {
    local path="$1"
    for prefix in "${ALLOWED_PREFIXES[@]}"; do
        if [[ "$path" == "$prefix"* ]]; then
            return 0
        fi
    done
    return 1
}

# Parse command-line arguments
while getopts ":d:vh" opt; do
  case $opt in
    d)
      if ! is_safe_path "$OPTARG"; then
          echo "Error: Unsafe backup destination path '$OPTARG' (path traversal detected)."
          exit 1
      fi
      BACKUP_DEST="$OPTARG"
      ;;
    v)
      VERBOSE=true
      ;;
    h)
      usage
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      ;;
  esac
done

mkdir -p "$BACKUP_DEST"

echo "Starting homelab backup process..."
echo "Backup Destination: $BACKUP_DEST"
echo "Timestamp: $TIMESTAMP"
echo "=================================="

# Keep track of processed paths to avoid duplicate backups of the same directory
declare -A PROCESSED_PATHS

# Find all .env files in service directories
find "$REPO_ROOT" -maxdepth 2 -name ".env" | while read -r env_file; do
    service_dir=$(dirname "$env_file")
    service_name=$(basename "$service_dir")
    
    echo ">>> Checking service directory: $service_name"
    
    # Read the .env file and look for BASE_PATH_ variables
    while IFS='=' read -r var_name var_value || [ -n "$var_name" ]; do
        # Ignore comments and empty lines
        [[ "$var_name" =~ ^#.*$ ]] && continue
        [[ -z "$var_name" ]] && continue
        
        if [[ "$var_name" == BASE_PATH_* ]]; then
            # Strip potential quotes and whitespace from the value
            path=$(echo "$var_value" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
            
            if [ -z "$path" ]; then
                echo "    [SKIP] $var_name is empty."
                continue
            fi
            
            if ! is_safe_path "$path"; then
                echo "    [ERROR] Unsafe path detected in $var_name: $path"
                continue
            fi

            if ! is_allowed_path "$path"; then
                echo "    [ERROR] Path '$path' in $var_name is outside allowed backup boundaries."
                continue
            fi
            
            if [ ! -d "$path" ]; then
                echo "    [SKIP] Path '$path' (from $var_name) does not exist."
                continue
            fi

            # Avoid backing up the same path twice
            if [[ ${PROCESSED_PATHS["$path"]} ]]; then
                echo "    [SKIP] Path '$path' already backed up (found in $var_name)."
                continue
            fi

            PROCESSED_PATHS["$path"]=1
            app_label=$(echo "$var_name" | sed 's/BASE_PATH_//' | tr '[:upper:]' '[:lower:]')
            backup_file="${BACKUP_DEST}/${app_label}_${TIMESTAMP}.tar.gz"
            
            echo "    [BACKUP] $var_name -> $path"
            
            TAR_OPTS="-czf"
            [ "$VERBOSE" = true ] && TAR_OPTS="-cvzf"
            
            # Create the tarball
            if tar $TAR_OPTS "$backup_file" -C "$(dirname "$path")" "$(basename "$path")"; then
                echo "    [SUCCESS] Created: $(basename "$backup_file")"
            else
                echo "    [ERROR] Failed to backup '$path'"
            fi
        fi
    done < "$env_file"
    echo "----------------------------------"
done

echo "=================================="
echo "Backup process complete."
