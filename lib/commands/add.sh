flailsafe_add() {
    require_root

    # Safely read input argument (set -u compatible)
    local input_path="${1:-}"
    [[ -n "$input_path" ]] || die "You must specify a file to add"

    # Resolve absolute path
    local filepath
    filepath="$(readlink -f "$input_path")" || die "Unable to resolve file path"

    # Ensure file exists
    [[ -f "$filepath" ]] || die "File does not exist: $filepath"

    # Check if file is already monitored
    if [[ -f "$DB_FILE" ]] && grep -q "^$filepath|" "$DB_FILE"; then
        die "File already monitored: $filepath"
    fi

    # Compute MD5 checksum
    local md5
    md5="$(md5_of "$filepath")"

    # Compute FILE_ID used in the vault
    local file_id
    file_id="${filepath#/}"
    file_id="${file_id//\//__}"

    # Prepare vault directory
    local file_vault_dir="$VAULT_DIR/$file_id"
    mkdir -p "$file_vault_dir"

    # Generate timestamp
    local timestamp
    timestamp="$(date '+%F'T'%H-%M-%S')"

    # Snapshot filename
    local snapshot="$file_vault_dir/${file_id}__${timestamp}"

    # Copy file preserving metadata
    cp --preserve=mode,ownership,timestamps "$filepath" "$snapshot"

    # Register file in database
    echo "$filepath|$md5" >> "$DB_FILE"

    # Write global log entry
    echo "$(date -Iseconds) | $filepath | snapshot | initial" >> "$LOG_FILE"

    echo "Added: $filepath"
}

