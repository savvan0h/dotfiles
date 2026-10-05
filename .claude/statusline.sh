#!/usr/bin/env bash
# Claude Code status line. Reads session JSON on stdin, prints two lines:
#   ~/path  ⎇ branch  │  Opus · xhigh  │  +156 -23
#   ctx ▰▰▱▱▱▱▱▱▱▱ 23%  │  5h 12% ↻15:00  │  7d 41% ↻Fri 10:00

input=$(cat)

GREEN=$'\033[38;2;151;201;195m'
YELLOW=$'\033[38;2;229;192;123m'
RED=$'\033[38;2;224;108;117m'
BLUE=$'\033[38;2;130;170;255m'
DIM=$'\033[38;2;110;120;125m'
RESET=$'\033[0m'
SEP="${DIM}  │  ${RESET}"

# Fields are joined with U+001F: `read` collapses runs of whitespace
# delimiters, so empty fields would shift with tabs/spaces.
IFS=$'\x1f' read -r cwd model effort added removed ctx five five_reset seven seven_reset < <(
  jq -r '[
    .workspace.current_dir // .cwd // "",
    .model.display_name // "",
    .effort.level // "",
    .cost.total_lines_added // 0,
    .cost.total_lines_removed // 0,
    .context_window.used_percentage // "",
    .rate_limits.five_hour.used_percentage // "",
    .rate_limits.five_hour.resets_at // "",
    .rate_limits.seven_day.used_percentage // "",
    .rate_limits.seven_day.resets_at // ""
  ] | map(tostring) | join("\u001f")' <<<"$input"
)

color_for() {
  if (( $1 >= 80 )); then printf '%s' "$RED"
  elif (( $1 >= 50 )); then printf '%s' "$YELLOW"
  else printf '%s' "$GREEN"; fi
}

# "label ▰▰▱▱▱▱▱▱▱▱ 23%" — empty when the percentage is unavailable
meter() {
  local label=$1 pct bar="" i
  [ -z "$2" ] && return
  printf -v pct '%.0f' "$2"
  for ((i = 0; i < 10; i++)); do
    if (( i < pct / 10 )); then bar+="▰"; else bar+="▱"; fi
  done
  printf '%s %s%s %s%%%s' "$label" "$(color_for "$pct")" "$bar" "$pct" "$RESET"
}

# Epoch seconds -> local time; works with both BSD (macOS) and GNU date
fmt_epoch() {
  date -r "$1" +"$2" 2>/dev/null || date -d "@$1" +"$2" 2>/dev/null
}

# ── Line 1: location + model ──
dir=${cwd/#$HOME/\~}
branch=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

line1="${BLUE}${dir}${RESET}"
[ -n "$branch" ] && line1+="  ${DIM}⎇${RESET} ${branch}"
line1+="${SEP}${model}"
[ -n "$effort" ] && line1+=" ${DIM}·${RESET} ${effort}"
line1+="${SEP}${GREEN}+${added}${RESET} ${RED}-${removed}${RESET}"

# ── Line 2: context + rate limits ──
parts=()
m=$(meter ctx "$ctx") && [ -n "$m" ] && parts+=("$m")
if m=$(meter 5h "$five") && [ -n "$m" ]; then
  [ -n "$five_reset" ] && m+=" ${DIM}↻$(fmt_epoch "$five_reset" '%H:%M')${RESET}"
  parts+=("$m")
fi
if m=$(meter 7d "$seven") && [ -n "$m" ]; then
  [ -n "$seven_reset" ] && m+=" ${DIM}↻$(fmt_epoch "$seven_reset" '%a %H:%M')${RESET}"
  parts+=("$m")
fi

printf '%s' "$line1"
if (( ${#parts[@]} )); then
  line2=${parts[0]}
  for m in "${parts[@]:1}"; do line2+="${SEP}${m}"; done
  printf '\n%s' "$line2"
fi
