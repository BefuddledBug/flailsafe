# flailsafe purge <file>
# Remove all saved versions of a monitored file from the vault.
# Logs the purge both globally and in the vault log.

flailsafe_purge() {
    require_root

    # Read file argument
    local target="${1:-}"
    [[ -n "$target" ]] || { echo "Usage: flailsafe purge <absolute_file_path>"; return 1; }

    # Require absolute path
    if [[ "$target" != /* ]]; then
        echo "Error: file path must be absolute"
        return 1
    fi

    # Compute file ID and vault directory
    local file_id="${target#/}"
    file_id="${file_id//\//__}"
    local vault_dir="$VAULT_DIR/$file_id"

    # Check if vault exists
    if [[ ! -d "$vault_dir" ]]; then
        echo "Error: no vault found for $target"
        return 1
    fi

    # Confirm with user before deleting
    echo "WARNING: This will permanently delete all versions of $target in the vault."
    read -p "Are you sure? [y/N]: " answer
    case "$answer" in
        [Yy]*) ;;
        *) echo "Purge cancelled."; return 0 ;;
    esac

    # Timestamp for logging
    local timestamp
    timestamp="$(date '+%F'T'%H-%M-%S%:z')"

    # Log in vault
    echo "${timestamp} | PURGED | all snapshots removed" >> "$vault_dir/log"

    # Log globally
    echo "${timestamp} | ${target} | PURGED | all snapshots removed" >> "$LOG_FILE"

    # Remove vault directory and all files
    rm -rf "$vault_dir"

    echo "Purged all snapshots for: $target"
}

