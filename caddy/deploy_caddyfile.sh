#!/bin/bash

# Default values
DEFAULT_SOURCE="Caddyfile"
DEFAULT_DESTINATION="${BASE_PATH_CADDY:-/opt/caddy}/Caddyfile"

# Authorized destination (security boundary)
AUTHORIZED_DEST_ROOT="${BASE_PATH_CADDY:-/opt/caddy}"

# Function to check for path traversal
is_safe_path() {
    local path="$1"
    if [[ "$path" == *".."* ]]; then
        return 1
    fi
    return 0
}

# Use arguments if provided, otherwise use defaults
SOURCE="${1:-$DEFAULT_SOURCE}"
DESTINATION="${2:-$DEFAULT_DESTINATION}"

# Path Safety Checks
if ! is_safe_path "$SOURCE"; then
    echo "Error: Unsafe source path '$SOURCE' (path traversal detected)."
    exit 1
fi

if ! is_safe_path "$DESTINATION"; then
    echo "Error: Unsafe destination path '$DESTINATION' (path traversal detected)."
    exit 1
fi

# Ensure destination is within authorized root
if [[ "$DESTINATION" != "$AUTHORIZED_DEST_ROOT"* ]]; then
    echo "Error: Unauthorized destination '$DESTINATION'. Backups must be within '$AUTHORIZED_DEST_ROOT'."
    exit 1
fi

# Check if the source file exists
if [ ! -f "$SOURCE" ]; then
    echo "Error: Source file '$SOURCE' not found."
    exit 1
fi

# Ensure the destination directory exists and has correct permissions
DEST_DIR=$(dirname "$DESTINATION")
if [ ! -d "$DEST_DIR" ]; then
    echo "Creating destination directory: $DEST_DIR"
    sudo mkdir -p "$DEST_DIR"
    sudo chmod 755 "$DEST_DIR"
fi

# Copy the file
echo "Copying '$SOURCE' to '$DESTINATION'..."
sudo cp "$SOURCE" "$DESTINATION"

# Set correct permissions (644: rw-r--r--)
echo "Setting permissions to 644 on '$DESTINATION'..."
sudo chmod 644 "$DESTINATION"
sudo chown root:root "$DESTINATION"

# Verify the copy
if [ $? -eq 0 ]; then
    echo "Successfully deployed Caddyfile with correct permissions."
    echo "Remember to reload Caddy: docker exec -w /etc/caddy caddy caddy reload"
else
    echo "Error: Failed to deploy Caddyfile."
    exit 1
fi
