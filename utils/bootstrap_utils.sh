init_bootstrap() {
  file="${SETUP_HOME_DIR}.bootstrap.txt"
  if ! test -f "$file"; then
    echo "$(generate_asterisk) Creating bootstrap counter DB file"
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
}