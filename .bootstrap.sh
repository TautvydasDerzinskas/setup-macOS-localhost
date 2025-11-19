#!/bin/bash

# Source constants
source "${SETUP_HOME_DIR}utils/const.sh"

# Source utility scripts
source "${SETUP_HOME_DIR}utils/bootstrap_utils.sh"
source "${SETUP_HOME_DIR}utils/print_utils.sh"
source "${SETUP_HOME_DIR}utils/ascii_utils.sh"
source "${SETUP_HOME_DIR}utils/weather_utils.sh"
source "${SETUP_HOME_DIR}utils/github_utils.sh"

# Initialize bootstrap
init_bootstrap

main() {
  print_separator
  print_ascii
  print_separator
  print_stats
  fetch_weather
  print_weather
  print_line "${Blu}" "* ${Whi}Find out available commands by typing${RCol} - ${BRed}$helpCommand${RCol}"
  print_separator
  fetch_prs
}

main