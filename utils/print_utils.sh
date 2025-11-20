TOGGLE_FILE="${SETUP_HOME_DIR}/.asterisk_toggle.txt"

# Super overengineered way of returning asterisk in alternating colors
generate_asterisk() {
    if [ ! -f "$TOGGLE_FILE" ]; then
        echo 0 > "$TOGGLE_FILE"
    fi

    # Use a lock file to prevent race conditions
    local lock_file="${TOGGLE_FILE}.lock"
    local lock_fd=200

    # Acquire lock (create lock file exclusively)
    while ! mkdir "$lock_file" 2>/dev/null; do
        sleep 0.01
    done

    # Read current toggle state
    local toggle=$(cat "$TOGGLE_FILE")
    local colors=("${Blu}" "${Cya}")
    local result="${colors[$toggle]}*${RCol}"

    # Update toggle state
    local new_toggle=$((1 - toggle))
    echo "$new_toggle" > "$TOGGLE_FILE"

    # Release lock
    rmdir "$lock_file"

    echo "$result"
}

print_separator() {
  echo "${Bla}$S_E_P_A_R_A_T_O_R${RCol}"
}

print_line() {
  local color="$1"
  local text="$2"
  echo "${color}${text}${RCol}"
}

print_stats() {
  print_line "$(generate_asterisk) ${Whi}Current date${RCol} - ${BRed}$currentDate${RCol}"
  if [ "$last_time" -gt 0 ]; then
    diff=$((current_time - last_time))
    hours=$((diff / 3600))
    minutes=$(((diff % 3600) / 60))
    seconds=$((diff % 60))
    time_since="${hours}h ${minutes}m ${seconds}s"
    print_line "$(generate_asterisk) ${Whi}Time since last launch${RCol} - ${BRed}$time_since${RCol}"
  fi
  print_line "$(generate_asterisk) ${Whi}Runs${RCol} - ${BRed}$(($starts + 1))${RCol}"
}