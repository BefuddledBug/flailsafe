# flailsafe log
# Display the global flailsafe event log

flailsafe_log() {
    require_root

    # Ensure log file exists
    if [[ ! -f "$LOG_FILE" ]]; then
        echo "No log entries found"
        return 0
    fi

    # Print log contents as-is (chronological order)
    cat "$LOG_FILE"
}

