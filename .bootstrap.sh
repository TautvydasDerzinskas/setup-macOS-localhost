#!/bin/bash

# Updating bootstrap counter and timestamp
file="${SETUP_HOME_DIR}.bootstrap.txt"
if ! test -f "$file"; then
  echo "*** Creating bootstrap counter DB file"
  touch "$file"
  echo "0" > "$file"
  echo "0" >> "$file"
fi
currentDate=$(date)
current_time=$(date +%s)

if [ -e "$file" ]; then
  starts=$(head -1 "$file")
  last_time=$(tail -1 "$file")
else
  starts=0
  last_time=0
fi

echo "$(($starts + 1))" > "$file"
echo "$current_time" >> "$file"

S_E_P_A_R_A_T_O_R="----------------------------------------------------"

# Colors
RCol='\x1B[0m'
Bla='\x1B[0;30m';
Red='\x1B[0;31m';
Cya='\x1B[0;36m';
Blu='\x1B[0;34m';
Whi='\x1B[0;37m';
BRed='\x1B[1;31m';

# Main info
version="3.0.2"
helpCommand="help-list"
WEATHER_LOCATION="Zendek,Poland"
WEATHER_LOCATION_2="Siauliai,Lithuania"

echo "${Bla}$S_E_P_A_R_A_T_O_R${RCol}";
echo "${Cya}~|~ _    _|_  |_| _| _  _";
echo "${Cya} | (_||_| | \/ _|(_|(_|_\\  ${Red}.zshrc config ${Whi}$version${RCol}";
echo "${Bla}$S_E_P_A_R_A_T_O_R${RCol}";
echo "${Cya}* ${Whi}Current date${RCol} - ${BRed}$currentDate${RCol}"
if [ "$last_time" -gt 0 ]; then
  diff=$((current_time - last_time))
  hours=$((diff / 3600))
  minutes=$(((diff % 3600) / 60))
  seconds=$((diff % 60))
  time_since="${hours}h ${minutes}m ${seconds}s"
  echo "${Blu}* ${Whi}Time since last launch${RCol} - ${BRed}$time_since${RCol}"
fi
echo "${Cya}* ${Whi}Runs${RCol} - ${BRed}$(($starts + 1))${RCol}";
if [ -x "$(command -v curl)" ]; then
  weather=$(curl -s "wttr.in/$WEATHER_LOCATION?format=3" 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$weather" ]; then
    echo "${Blu}* ${Whi}Weather${RCol} - ${BRed}$weather${RCol}"
  else
    echo "${Blu}* ${Whi}Weather${RCol} - ${BRed}Unable to fetch${RCol}"
  fi
  weather2=$(curl -s "wttr.in/$WEATHER_LOCATION_2?format=3" 2>/dev/null)
  if [ $? -eq 0 ] && [ -n "$weather2" ]; then
    echo "${Cya}* ${Whi}Weather${RCol} - ${BRed}$weather2${RCol}"
  else
    echo "${Cya}* ${Whi}Weather${RCol} - ${BRed}Unable to fetch${RCol}"
  fi
fi

echo "${Blu}* ${Whi}Find out available commands by typing${RCol} - ${BRed}$helpCommand${RCol}"
echo "${Bla}$S_E_P_A_R_A_T_O_R${RCol}";