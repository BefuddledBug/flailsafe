#!/usr/bin/env bash

# flailsafe_list.sh
# Command to list monitored files and their last modification timestamp in the vault

flailsafe_list() {
    # Require root privileges
    require_root

    # Check if database exists
    [[ -f "$DB_FILE" ]] || { echo "No monitored files found."; return 0; }

    # Loop over all files in files.db
    while IFS='|' read -r filepath md5; do
        # Compute FILE_ID for vault directory
        local file_id
        file_id="${filepath#/}"
        file_id="${file_id//\//__}"

        local file_vault_dir="$VAULT_DIR/$file_id"

        # Check if vault directory exists
        if [[ -d "$file_vault_dir" ]]; then
            # Find the latest snapshot by timestamp in the filename
            local last_snapshot
            last_snapshot=$(ls -1 "$file_vault_dir" | grep "$file_id" | sort | tail -n1)

            if [[ -n "$last_snapshot" ]]; then
                # Extract timestamp from snapshot filename
                local last_ts
                last_ts=${last_snapshot##*__}
                echo "$filepath | last modified: $last_ts"
            else
                echo "$filepath | no snapshots in vault"
            fi
        else
            echo "$filepath | vault directory missing"
        fi
    done < "$DB_FILE"
}

