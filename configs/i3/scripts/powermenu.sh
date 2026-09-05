#!/bin/bash

MENU=$(printf "🔌 Shutdown\n🔁 Reboot\n🌙 Hibernate\n💤 Suspend\n🚪 Logout\n🚪 Exit i3" | rofi -dmenu -p "Power" -i)

case "$MENU" in

    "🔌 Shutdown")
        CONF=$(echo -e "Cancel\nProceed" | rofi -dmenu -p "Shutdown now?")
        if [[ "$CONF" == "Proceed" ]]; then
            systemctl poweroff
        fi
        ;;

    "🔁 Reboot")
        CONF=$(echo -e "Cancel\nProceed" | rofi -dmenu -p "Reboot now?")
        if [[ "$CONF" == "Proceed" ]]; then
            systemctl reboot
        fi
        ;;

    "🌙 Hibernate")
        systemctl hibernate
        ;;

    "💤 Suspend")
        systemctl suspend
        ;;

    "🚪 Logout")
        loginctl terminate-user "$USER"
        ;;

    "🚪 Exit i3")
        i3-msg exit
        ;;

    *)
        # Nothing selected or rofi closed
        exit 0
        ;;
esac

