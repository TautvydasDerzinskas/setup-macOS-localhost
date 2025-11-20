fetch_prs() {
  cache_file="${SETUP_HOME_DIR}/.prs.txt"
  max_age=$((60 * 60))

  get_mtime() { stat -f %m "$1"; }

  generate_prs() {
    if [ -x "$(command -v gh)" ]; then
      user=$(gh api user --jq .login)
      {
        # PRs awaiting your review
        reviewer_prs=$(gh pr list --repo openx/ui-unity --state open --json number,title,reviewRequests,reviews \
          | jq -r --arg user "$user" '.[]
            | select(
                (any(.reviewRequests[]?; .__typename=="User" and .login==$user))
                or
                (
                  any(.reviews[]?; .author.login==$user)
                  and ([.reviews[]? | select(.author.login==$user) | .state] | last != "APPROVED")
                )
              )
            | "https://github.com/openx/ui-unity/pull/\(.number)\n\(.title)"' 2>/dev/null)

        # Your own PRs
        own_prs=$(gh pr list --repo openx/ui-unity --author @me --json url,title \
          --template '{{range .}}{{.url}}{{"\n"}}{{.title}}{{"\n"}}{{end}}' 2>/dev/null)

        if [ -n "$reviewer_prs" ]; then
          print_line "$(generate_asterisk) ${Whi}PRs to review:${RCol}"
          echo "$reviewer_prs" | while IFS= read -r url && IFS= read -r title; do
            [ -n "$url" ] && [ -n "$title" ] && {
              print_line "${Yel}" "  - ${Blu}$url${RCol}"
              print_line "${Yel}" "   ${Whi}$title${RCol}"
            }
          done
          print_separator
        fi

        if [ -n "$own_prs" ]; then
          print_line "$(generate_asterisk) ${Whi}My PRs:${RCol}"
          echo "$own_prs" | while IFS= read -r url && IFS= read -r title; do
            [ -n "$url" ] && [ -n "$title" ] && {
              print_line "${Yel}" "  - ${Blu}$url${RCol}"
              print_line "${Yel}" "   ${Whi}$title${RCol}"
            }
          done
          print_separator
        fi
      } > "$cache_file"
    else
      print_line "$(generate_asterisk) ${Whi}GitHub CLI not available${RCol}"
    fi
  }

  # Check cache freshness
  if [ -f "$cache_file" ]; then
    last_modified=$(get_mtime "$cache_file")
    age=$(( $(date +%s) - last_modified ))
  else
    age=$max_age
  fi

  # Use cache if fresh
  if [ $age -lt $max_age ]; then
    cat "$cache_file"
  else
    generate_prs
    cat "$cache_file"
  fi
}
