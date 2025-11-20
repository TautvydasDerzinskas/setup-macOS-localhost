#!/bin/bash

fetch_calendar_events() {
    calendar_id="tautvydas.derzinskas@openx.com"
    now_sec=$(date +%s)
    printed_any=0

    # Capture output first (no pipe → no subshell for the while loop)
    output="$(gcalcli --calendar "$calendar_id" agenda today tomorrow 2>/dev/null \
              | sed 's/\x1B\[[0-9;]*[mG]//g')"

    while IFS= read -r line; do
        # Match lines starting with a time (e.g. "10:30  Meeting title")
        if [[ "$line" =~ ^[[:space:]]*([0-9]{1,2}:[0-9]{2})[[:space:]]+(.*)$ ]]; then
            time="${BASH_REMATCH[1]}"
            title="${BASH_REMATCH[2]}"

            # macOS-safe HH:MM → epoch
            event_sec=$(date -j -f "%H:%M" "$time" +"%s" 2>/dev/null) || continue
            diff_sec=$((event_sec - now_sec))
            if (( diff_sec > 0 )); then
                hours=$((diff_sec / 3600))
                echo "$time - $title - $hours hours until"
                printed_any=1
            fi
        fi
    done <<< "$output"

    # Run once after the last printed event
    if (( printed_any == 1 )); then
        print_separator
    fi
}
