# flailsafe remove <file>
# Remove a file from the monitoring list, keep vault copies intact

flailsafe_remove() {
    require_root

    # Read file argument
    local target="${1:-}"
    [[ -n "$target" ]] || { echo "Usage: flailsafe remove <absolute_file_path>"; return 1; }

    # Require absolute path
    if [[ "$target" != /* ]]; then
        echo "Error: file path must be absolute"
        return 1
    fi

    # Check if DB exists
    if [[ ! -f "$DB_FILE" ]]; then
        echo "Error: no monitored files found"
        return 1
    fi

    # Check if file is monitored
    if ! awk -F'|' -v f="$target" '$1 == f {found=1} END {exit !found}' "$DB_FILE"; then
        echo "Error: file not found in monitoring list: $target"
        return 1
    fi

    # Create temporary DB for atomic replacement
    local tmp_db
    tmp_db="$(mktemp)"

    # Copy all entries except the target file
    grep -v -F "$target|" "$DB_FILE" > "$tmp_db" || true

    # Replace DB atomically
    mv "$tmp_db" "$DB_FILE"

    # Log the removal in global log
    local timestamp
    timestamp="$(date '+%F'T'%H-%M-%S%:z')"
    echo "${timestamp} | ${target} | REMOVED | monitoring disabled" >> "$LOG_FILE"

    # Log inside vault (if it exists)
    local file_id="${target#/}"
    file_id="${file_id//\//__}"
    local vault_dir="$VAULT_DIR/$file_id"
    if [[ -d "$vault_dir" ]]; then
        echo "${timestamp} | REMOVED | monitoring disabled" >> "$vault_dir/log"
    fi

    echo "File removed from monitoring: $target"
}

