TOGGLE_FILE="${SETUP_HOME_DIR}/.asterisk_toggle.txt"

generate_asterisk() {
    if [ ! -f "$TOGGLE_FILE" ]; then
        echo 0 > "$TOGGLE_FILE"
    fi
    local toggle=$(cat "$TOGGLE_FILE")
    local colors=("${Blu}" "${Cya}")
    local result="${colors[$toggle]}*${RCol}"
    local new_toggle=$((1 - toggle))
    echo "$new_toggle" > "$TOGGLE_FILE"
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