#!/usr/bin/env bash

# --- Configuration (Optional) ---
icon_on="⌨️"       # Icon when wvkbd is running
icon_off="⌨️"     # Icon when wvkbd is not running (can be the same or different)
tooltip_on="wvkbd is running"
tooltip_off="wvkbd is not running"
# ------------------------------------

# Check if wvkbd-mobintl is running
is_running() {
    pgrep wvkbd-mobintl > /dev/null
}

# Toggle wvkbd-mobintl
toggle_wvkbd() {
    if is_running; then
        pkill wvkbd-mobintl
        echo "wvkbd-mobintl terminated."
    else
        wvkbd-mobintl -l full -H 360 -L 540 --fn 'JetBrainsMono Nerd Font 20' --bg 282828 --fg 3c3836 --fg-sp 504945 --text ebdbb2 --text-sp ebdbb2 &
        echo "wvkbd-mobintl started."
    fi
}

# --- Waybar JSON Output ---

# If no arguments, output current status
if [ -z "$1" ]; then
  if is_running; then
    jq -n --arg text "$icon_on" --arg tooltip "$tooltip_on" '{text: $text, tooltip: $tooltip, class: "wvkbd"}'  # Corrected: Added closing brace
  else
    jq -n --arg text "$icon_off" --arg tooltip "$tooltip_off" '{text: $text, tooltip: $tooltip, class: "wvkbd"}'  # Corrected: Added closing brace
  fi
  exit 0
fi

# If 'click' argument, toggle wvkbd
if [ "$1" == "click" ]; then
  toggle_wvkbd

  # Immediate update of the icon
  if is_running; then
     jq -n --arg text "$icon_on" --arg tooltip "$tooltip_on" '{text: $text, tooltip: $tooltip, class: "wvkbd"}'  # Corrected: Added closing brace and tooltip var
  else
    jq -n --arg text "$icon_off" --arg tooltip "$tooltip_off" '{text: $text, tooltip: $tooltip, class: "wvkbd"}'  # Corrected: Added closing brace and tooltip var
  fi
fi
exit 0
