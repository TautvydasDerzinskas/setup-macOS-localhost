fetch_weather() {
  weather_file="${SETUP_HOME_DIR}.weather.txt"
  weather="Unable to fetch"
  weather2="Unable to fetch"
  fetched=false
  if [ -f "$weather_file" ]; then
    last_fetch=$(head -1 "$weather_file")
    weather_saved=$(sed -n '2p' "$weather_file")
    weather2_saved=$(sed -n '3p' "$weather_file")
    if [ $((current_time - last_fetch)) -le 1800 ]; then
      weather="$weather_saved"
      weather2="$weather2_saved"
    else
      # old, fetch
      if [ -x "$(command -v curl)" ]; then
        weather=$(curl -s "wttr.in/$WEATHER_LOCATION?format=3" 2>/dev/null)
        if [ $? -eq 0 ] && [ -n "$weather" ]; then
          weather2=$(curl -s "wttr.in/$WEATHER_LOCATION_2?format=3" 2>/dev/null)
          if [ $? -eq 0 ] && [ -n "$weather2" ]; then
            fetched=true
          else
            weather="$weather_saved"
            weather2="$weather2_saved"
          fi
        else
          weather="$weather_saved"
          weather2="$weather2_saved"
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
  fi
}