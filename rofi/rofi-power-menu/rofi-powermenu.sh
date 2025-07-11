#!/bin/sh

# Power menu script using Rofi

CHOSEN=$(printf "  Lock\n󰤄  Suspend\n  Reboot\n  Power Off\n󰗽  Log Out" | rofi -dmenu -i -p "Power Menu")

case "$CHOSEN" in
    "  Lock") light-locker-command --lock ;;  # Replace with your lock script if needed
    "󰤄  Suspend") systemctl suspend ;;
    "  Reboot") systemctl reboot ;;
    "  Power Off") systemctl poweroff ;;
	"󰗽  Log Out") pkill -KILL -u "$USER" ;;
    *) exit 1 ;;
esac
