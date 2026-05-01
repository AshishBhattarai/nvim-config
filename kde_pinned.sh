#!/usr/bin/env bash
set -euo pipefail

launchers="$(
  grep -m1 '^launchers=' "$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc" |
  sed 's/^launchers=//'
)"

format_item() {
  item="$1"
  item="${item#applications:}"
  item="${item%.desktop}"
  item="${item##*/}"
  item="$(printf '%s' "$item" | tr '[:upper:]' '[:lower:]')"

  case "$item" in
    systemsettings) item="settings" ;;
    org.kde.dolphin|dolphin|filemanager) item="files" ;;
    brave-ffhnkanmhmmnfebldhpffiopadhbeimp-default) item="goodnotes" ;;
  esac

  printf '%s' "$item"
}

rendered=""
index=1

OLDIFS="$IFS"
IFS=,
set -- $launchers
IFS="$OLDIFS"

for raw in "$@"; do
  [ "$index" -lt 9 ] || break
  name="$(format_item "$raw")"

  if [ -n "$rendered" ]; then
    rendered="$rendered "
  fi

  rendered="${rendered}${index}:${name}"
  index=$((index + 1))
done

tmux set -gq @kde_pins "$rendered"
