#!/usr/bin/env bash

set -euo pipefail

input=$(cat)

# ── Colors ──
GREEN="\033[38;2;151;201;195m"
YELLOW="\033[38;2;229;192;123m"
RED="\033[38;2;224;108;117m"
GRAY="\033[38;2;74;88;92m"
RESET="\033[0m"
sep="${GRAY} | ${RESET}"

color_for_pct() {
  local pct=$1
  if (( pct >= 80 )); then
    printf '%s' "$RED"
  elif (( pct >= 50 )); then
    printf '%s' "$YELLOW"
  else
    printf '%s' "$GREEN"
  fi
}

# ── Progress bar (10 segments) ──
progress_bar() {
  local pct=$1
  local filled=$(( pct / 10 ))
  local empty=$(( 10 - filled ))
  local color
  color=$(color_for_pct "$pct")
  local bar=""
  for ((i=0; i<filled; i++)); do bar+="▰"; done
  for ((i=0; i<empty; i++)); do bar+="▱"; done
  printf '%b%s%b' "$color" "$bar" "$RESET"
}

# Round a percentage (possibly float/empty) to an integer
pct_to_int() {
  local v=$1
  [ -z "$v" ] && { printf '0'; return; }
  local int
  printf -v int "%.0f" "$v" 2>/dev/null || int="${v%%.*}"
  printf '%s' "$int"
}

# ── Line 1: Session info ──
# Join with U+001F (a non-whitespace delimiter) instead of @tsv: read collapses
# consecutive whitespace delimiters, so an empty field (e.g. used_percentage is
# null early in a session) would otherwise shift every later field left by one.
IFS=$'\x1f' read -r model used_pct lines_added lines_removed cwd < <(
  echo "$input" | jq -r '[
    .model.display_name // "",
    .context_window.used_percentage // "",
    .cost.total_lines_added // 0,
    .cost.total_lines_removed // 0,
    .workspace.current_dir // ""
  ] | map(tostring) | join("\u001f")'
)

ctx_int=$(pct_to_int "$used_pct")
ctx_color=$(color_for_pct "$ctx_int")
ctx_bar=$(progress_bar "$ctx_int")

# Git branch
git_branch=""
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  git_branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi

line1="${model}${sep}ctx  ${ctx_bar}  ${ctx_color}${ctx_int}%${RESET}${sep}+${lines_added}/-${lines_removed}"
if [ -n "$git_branch" ]; then
  line1+="${sep}⎇ ${git_branch}"
fi

# ── Usage API (OAuth, cached) ──
CACHE_FILE="/tmp/claude-usage-cache.json"
CACHE_TTL=360

fetch_usage() {
  # Get OAuth token from macOS Keychain
  local token
  token=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null || true)
  [ -z "$token" ] && return 1

  # Token is stored as JSON with nested structure
  local access_token
  access_token=$(echo "$token" | jq -r '.claudeAiOauth.accessToken // .accessToken // .access_token // empty' 2>/dev/null || true)
  [ -z "$access_token" ] && return 1

  local response
  response=$(curl -sf --max-time 5 \
    -H "Authorization: Bearer ${access_token}" \
    -H "anthropic-beta: oauth-2025-04-20" \
    "https://api.anthropic.com/api/oauth/usage" 2>/dev/null) || return 1

  # Write cache with timestamp
  echo "$response" | jq --arg ts "$(date +%s)" '. + {cached_at: ($ts | tonumber)}' > "$CACHE_FILE" 2>/dev/null
  echo "$response"
}

get_usage() {
  # Serve from cache while fresh
  if [ -f "$CACHE_FILE" ]; then
    local cached_at age
    cached_at=$(jq -r '.cached_at // 0' "$CACHE_FILE" 2>/dev/null || echo "0")
    age=$(( $(date +%s) - cached_at ))
    if (( age < CACHE_TTL )); then
      jq -r 'del(.cached_at)' "$CACHE_FILE" 2>/dev/null
      return 0
    fi
  fi

  fetch_usage
}

# Convert ISO 8601 to epoch seconds (macOS compatible)
iso_to_epoch() {
  local stripped="${1%%.*}"
  TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$stripped" +%s 2>/dev/null || echo ""
}

# Format a reset timestamp using the given strftime format, in Asia/Tokyo
format_reset() {
  local iso_time=$1 fmt=$2 epoch
  epoch=$(iso_to_epoch "$iso_time")
  [ -z "$epoch" ] && return
  LC_ALL=en_US.UTF-8 TZ="Asia/Tokyo" date -r "$epoch" +"$fmt" 2>/dev/null | sed 's/AM/am/;s/PM/pm/'
}

# Build a usage line: "<label>  <pct>%[ | Resets ...]"
build_usage_line() {
  local label=$1 util=$2 reset=$3 fmt=$4
  [ -z "$util" ] && return
  local int color bar reset_str
  int=$(pct_to_int "$util")
  color=$(color_for_pct "$int")
  bar=$(progress_bar "$int")
  local line="${label}  ${bar}  ${color}${int}%${RESET}"
  if [ -n "$reset" ]; then
    reset_str=$(format_reset "$reset" "$fmt")
    [ -n "$reset_str" ] && line+=" ${GRAY}(${reset_str})${RESET}"
  fi
  printf '%s' "$line"
}

usage_5h=""
usage_7d=""

usage_json=$(get_usage 2>/dev/null || true)

if [ -n "$usage_json" ]; then
  IFS=$'\t' read -r five_util five_reset seven_util seven_reset < <(
    echo "$usage_json" | jq -r '[
      .five_hour.utilization // "",
      .five_hour.resets_at // "",
      .seven_day.utilization // "",
      .seven_day.resets_at // ""
    ] | @tsv'
  )

  usage_5h=$(build_usage_line "5h" "$five_util" "$five_reset" "Resets at %-l%p")
  usage_7d=$(build_usage_line "7d" "$seven_util" "$seven_reset" "Resets at %-l%p on %b %-d")
fi

# ── Output ──
# Line 1: session info. Line 2: usage (5h and 7d joined by a separator).
printf '%b' "$line1"
usage_line="$usage_5h"
if [ -n "$usage_7d" ]; then
  [ -n "$usage_line" ] && usage_line+="${sep}"
  usage_line+="$usage_7d"
fi
[ -n "$usage_line" ] && printf '\n%b' "$usage_line"
