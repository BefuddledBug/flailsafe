# flailsafe status <file>
# Show detailed status for a monitored file
# Safe with `set -u` and ignores non-snapshot files (e.g. log)

flailsafe_status() {
    require_root

    # Safely read positional argument (set -u compatible)
    local target="${1:-}"

    if [[ -z "$target" ]]; then
        echo "Usage: flailsafe status <absolute_file_path>
Use the command 'flailsafe list' to see what files are being monitored "
        return 1
    fi

    # Require absolute path
    if [[ "$target" != /* ]]; then
        echo "Error: file path must be absolute"
        return 1
    fi

    # Database must exist
    if [[ ! -f "$DB_FILE" ]]; then
        echo "No monitored files database found"
        return 1
    fi

    # File must be monitored
    if ! grep -q "^$target|" "$DB_FILE"; then
        echo "File not monitored: $target"
        return 1
    fi

    # Compute FILE_ID
    local file_id
    file_id="${target#/}"
    file_id="${file_id//\//__}"

    local vault_dir="$VAULT_DIR/$file_id"

    if [[ ! -d "$vault_dir" ]]; then
        echo "Vault directory missing"
        echo "Expected: $vault_dir"
        return 1
    fi

    echo "File: $target"
    echo "Vault directory: $vault_dir"

    # Collect only valid snapshot files (ignore log and anything else)
    local snapshots
    snapshots=$(ls -1 "$vault_dir" 2>/dev/null | grep "^${file_id}__" | sort)

    if [[ -z "$snapshots" ]]; then
        echo "No snapshots found"
        return 0
    fi

    local count
    count=$(echo "$snapshots" | wc -l)

    local last_snapshot
    last_snapshot=$(echo "$snapshots" | tail -n1)

    local last_ts
    last_ts=${last_snapshot##*__}

    echo "Versions stored: $count"
    echo "Last modified: $last_ts"

    echo
    echo "Available versions:"
    echo "$snapshots"
}

