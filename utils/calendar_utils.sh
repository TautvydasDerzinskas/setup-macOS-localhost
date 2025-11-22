#!/bin/bash

fetch_calendar_events() {
    calendar_id="tautvydas.derzinskas@openx.com"
    cache_file="${SETUP_HOME_DIR}/.calendar_events.txt"
    timestamp_file="${SETUP_HOME_DIR}/.calendar_timestamp.txt"
    max_age=$((60 * 60))  # 1 hour cache
    now_sec=$(date +%s)
    current_hour=$(date +%H)

    # Check if it's past 5 PM (17:00)
    if (( current_hour >= 17 )); then
        # After 5 PM, show tomorrow's events only
        start_day="tomorrow"
        end_day="tomorrow 23:59"
        time_marker="evening"
    else
        # Before 5 PM, show today's events
        start_day="today"
        end_day="tomorrow"
        time_marker="morning"
    fi

    # Check if we need to clear cache (first run after midnight or first run after 17:00)
    if [ -f "$timestamp_file" ]; then
        last_marker=$(cat "$timestamp_file")
        # Clear cache if the marker changed
        if [ "$last_marker" != "$time_marker" ]; then
            rm -f "$cache_file" "$timestamp_file"
        fi
    fi

    # Save current marker
    echo "$time_marker" > "$timestamp_file"

    # Function to get file modification time
    get_mtime() { stat -f %m "$1"; }

    # Function to generate and cache calendar events
    generate_calendar_events() {
        if [ -x "$(command -v gcalcli)" ]; then
            {
                output="$(gcalcli --calendar "$calendar_id" agenda "$start_day" "$end_day" 2>/dev/null \
                        | sed 's/\x1B\[[0-9;]*[mG]//g')"

                printed_any=0
                while IFS= read -r line; do
                    # Match lines starting with a time (e.g. "10:30  Meeting title")
                    if [[ "$line" =~ ^[[:space:]]*([0-9]{1,2}:[0-9]{2})[[:space:]]+(.*)$ ]]; then
                        time="${BASH_REMATCH[1]}"
                        title="${BASH_REMATCH[2]}"

                        # macOS-safe HH:MM → epoch
                        event_sec=$(date -j -f "%H:%M" "$time" +"%s" 2>/dev/null) || continue

                        # If showing tomorrow's events, add 24 hours to event time
                        if [ "$time_marker" = "evening" ]; then
                            event_sec=$((event_sec + 86400))
                        fi

                        diff_sec=$((event_sec - now_sec))
                        if (( diff_sec > 0 )); then
                            if (( printed_any == 0 )); then
                                echo "$(generate_asterisk) ${Whi}Upcoming Calendar events:${RCol}"
                            fi
                            hours=$((diff_sec / 3600))
                            echo "${Yel}" " - ${Blu}$time ${Yel}- ${Whi}$title ${Yel}- ${Red}$hours hours until${RCol}"
                            printed_any=1
                        fi
                    fi
                done <<< "$output"

                # Run once after the last printed event
                if (( printed_any == 1 )); then
                    print_separator
                fi
            } > "$cache_file"
        else
            print_line "$(generate_asterisk) ${Whi}gcalcli CLI not available${RCol}" > "$cache_file"
        fi
    }

    # Check cache freshness
    if [ -f "$cache_file" ]; then
        last_modified=$(get_mtime "$cache_file")
        age=$(( now_sec - last_modified ))
    else
        age=$max_age
    fi

    # Use cache if fresh, otherwise regenerate
    if [ $age -lt $max_age ]; then
        cat "$cache_file"
    else
        generate_calendar_events
        cat "$cache_file"
    fi
}
