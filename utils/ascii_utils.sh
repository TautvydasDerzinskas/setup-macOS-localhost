print_ascii() {
  ascii_files=("ascii-1.txt" "ascii-2.txt" "ascii-3.txt" "ascii-4.txt")
  if [ ${#ascii_files[@]} -gt 0 ]; then
    random_index=$((RANDOM % ${#ascii_files[@]}))
    selected_file="${SETUP_HOME_DIR}ascii/${ascii_files[$random_index]}"
    {
      while IFS= read -r line; do
        echo "${Cya}$line"
      done < "$selected_file"
    } | sed '$ s/$/ '"${Red}.zshrc config ${Whi}$version${RCol}"'/'
  else
    echo "${Cya}~|~ _    _|_  |_| _| _  _";
    echo "${Cya} | (_||_| | \/ _|(_|(_|_\\  ${Red}.zshrc config ${Whi}$version${RCol}";
  fi
}