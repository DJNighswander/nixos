#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <application_name> [arguments...]" >&2
  exit 1
fi

application_name="$1"
shift
application_args="$@"
# ALACRITTY
if [ "$application_name" = "alacritty" ]; then
  window_title=""
  if [[ "$application_args" =~ -T\ ([^[:space:]]+) ]]; then
    window_title="${BASH_REMATCH[1]}"
  elif [[ "$application_args" =~ -T([[:space:]].+)?$ ]]; then
    window_title="${BASH_REMATCH[1]}"
  fi

  if [ -n "$window_title" ]; then
    pid=$( hyprctl clients -j | jq -r --arg title "$window_title" '.[] | select(.title|contains($title)) | .pid' | head -1 ) 
    
    if [ -z "$pid" ] && command -v hyprctl >/dev/null && command -v jq >/dev/null; then
      echo "No Alacritty window found with title containing '$window_title'. Opening Window.">&2
      "$application_name" "$application_args" &
      exit 1
    elif [ -z "$pid" ]; then
      echo "Error: hyprctl or jq not found.">&2
      exit 1
    fi
  fi

  if [ -z "$pid" ]; then
    pid=$( pgrep -o -f "$application_name" )
  fi
# FIREFOX
elif [ "$application_name" = "firefox" ]; then
    pid=$( pgrep -o -f ".firefox-wrapped" )
# VIEB
elif [ "$application_name" = "vieb" ]; then
    pid=$( pgrep -o -f ".electron-wrapper" )
else
  pid=$( pgrep -o -f "$application_name" )
fi

if [ -z "$pid" ]; then
  "$application_name" $application_args &
else
  hyprctl dispatch -- focuswindow pid:"$pid"
fi
