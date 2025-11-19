print_separator() {
  echo "${Bla}$S_E_P_A_R_A_T_O_R${RCol}"
}

print_line() {
  local color="$1"
  local text="$2"
  echo "${color}${text}${RCol}"
}

print_stats() {
  print_line "${Cya}" "* ${Whi}Current date${RCol} - ${BRed}$currentDate${RCol}"
  if [ "$last_time" -gt 0 ]; then
    diff=$((current_time - last_time))
    hours=$((diff / 3600))
    minutes=$(((diff % 3600) / 60))
    seconds=$((diff % 60))
    time_since="${hours}h ${minutes}m ${seconds}s"
    print_line "${Blu}" "* ${Whi}Time since last launch${RCol} - ${BRed}$time_since${RCol}"
  fi
  print_line "${Cya}" "* ${Whi}Runs${RCol} - ${BRed}$(($starts + 1))${RCol}"
}