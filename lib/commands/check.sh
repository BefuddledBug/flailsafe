flailsafe_check() {
    require_root

    # Nothing to do if database does not exist
    [[ -f "$DB_FILE" ]] || exit 0

    # Temporary database for atomic update
    local tmp_db
    tmp_db="$(mktemp)"

    while IFS='|' read -r filepath old_md5; do

        # If file no longer exists, keep old entry and log event
        if [[ ! -f "$filepath" ]]; then
            echo "$(date -Iseconds) | $filepath | missing | file not found" >> "$LOG_FILE"
            echo "$filepath|$old_md5" >> "$tmp_db"
            continue
        fi

        # Compute current MD5
        local new_md5
        new_md5="$(md5_of "$filepath")"

        # If unchanged, keep existing entry
        if [[ "$new_md5" == "$old_md5" ]]; then
            echo "$filepath|$old_md5" >> "$tmp_db"
            continue
        fi

        # File has changed → store new snapshot
        local file_id
        file_id="${filepath#/}"
        file_id="${file_id//\//__}"

        local file_vault_dir="$VAULT_DIR/$file_id"
        mkdir -p "$file_vault_dir"

        local timestamp
        timestamp="$(date '+%F'T'%H-%M-%S')"

        local snapshot="$file_vault_dir/${file_id}__${timestamp}"

        cp --preserve=mode,ownership,timestamps "$filepath" "$snapshot"

        # Write global log entry
        echo "$(date -Iseconds) | $filepath | modified | new snapshot stored" >> "$LOG_FILE"

        # Update database with new MD5
        echo "$filepath|$new_md5" >> "$tmp_db"

    done < "$DB_FILE"

    # Atomically replace database
    mv "$tmp_db" "$DB_FILE"
}

