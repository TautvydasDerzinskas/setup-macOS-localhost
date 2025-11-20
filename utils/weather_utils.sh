extract_temp() {
  local t
  t=$(echo "$1" | sed -E 's/.* ([+-]?[0-9]+)°C.*/\1/')
  if [[ "$t" =~ ^-?[0-9]+$ ]]; then
    echo "$t"
  fi
}

fetch_weather() {
  weather_file="${SETUP_HOME_DIR}.weather.txt"
  weather="Unable to fetch"
  weather2="Unable to fetch"
  temp_change="N/A"
  temp_change2="N/A"
  fetched=false
  if [ -f "$weather_file" ]; then
    last_fetch=$(head -1 "$weather_file")
    weather_saved=$(sed -n '2p' "$weather_file")
    weather2_saved=$(sed -n '3p' "$weather_file")
    temp_saved=$(sed -n '4p' "$weather_file")
    temp2_saved=$(sed -n '5p' "$weather_file")
    if [ $((current_time - last_fetch)) -le 1800 ]; then
      weather="$weather_saved"
      weather2="$weather2_saved"
      temp_change=0
      temp_change2=0
    else
      # old, fetch
      if [ -x "$(command -v curl)" ]; then
        weather=$(curl -s "wttr.in/$WEATHER_LOCATION?format=3" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$weather" ]; then
          weather2=$(curl -s "wttr.in/$WEATHER_LOCATION_2?format=3" 2>/dev/null)
          if [ $? -eq 0 ] && [ -n "$weather2" ]; then
            fetched=true
            temp_current=$(extract_temp "$weather")
            temp2_current=$(extract_temp "$weather2")
            if [[ "$temp_current" =~ ^-?[0-9]+$ && "$temp_saved" =~ ^-?[0-9]+$ ]]; then
              temp_change=$((temp_current - temp_saved))
            else
              temp_change="N/A"
            fi

            if [[ "$temp2_current" =~ ^-?[0-9]+$ && "$temp2_saved" =~ ^-?[0-9]+$ ]]; then
              temp_change2=$((temp2_current - temp2_saved))
            else
              temp_change2="N/A"
            fi
          else
            weather="$weather_saved"
            weather2="$weather2_saved"
            temp_change=0
            temp_change2=0
          fi
        else
          weather="$weather_saved"
          weather2="$weather2_saved"
          temp_change=0
          temp_change2=0
        fi
      fi
    fi
  else
    # no file, fetch
    if [ -x "$(command -v curl)" ]; then
      weather=$(curl -s "wttr.in/$WEATHER_LOCATION?format=3" 2>/dev/null)
      if [ $? -eq 0 ] && [ -n "$weather" ]; then
        weather2=$(curl -s "wttr.in/$WEATHER_LOCATION_2?format=3" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$weather2" ]; then
          fetched=true
          temp_change="N/A"
          temp_change2="N/A"
        else
          weather="Unable to fetch"
          weather2="Unable to fetch"
        fi
      else
        weather="Unable to fetch"
        weather2="Unable to fetch"
      fi
    fi
  fi
  if [ "$fetched" = true ]; then
    echo "$current_time" > "$weather_file"
    echo "$weather" >> "$weather_file"
    echo "$weather2" >> "$weather_file"
    echo "$temp_current" >> "$weather_file"
    echo "$temp2_current" >> "$weather_file"
  fi
}

print_weather() {
  if [ "$temp_change" != "0" ] && [ "$temp_change" != "N/A" ]; then
    print_line "$(generate_asterisk) ${Whi}Weather${RCol} - ${BRed}$weather${Whi} ($temp_change°C)${RCol}"
  else
    print_line "$(generate_asterisk) ${Whi}Weather${RCol} - ${BRed}$weather${RCol}"
  fi
  if [ "$temp_change2" != "0" ] && [ "$temp_change2" != "N/A" ]; then
    print_line "$(generate_asterisk) ${Whi}Weather${RCol} - ${BRed}$weather2${Whi} ($temp_change2°C)${RCol}"
  else
    print_line "$(generate_asterisk) ${Whi}Weather${RCol} - ${BRed}$weather2${RCol}"
  fi
}