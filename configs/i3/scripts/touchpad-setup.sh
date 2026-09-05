#!/usr/bin/env bash
# touchpad-setup.sh — conservative, safe setup for ALPS DualPoint + libinput-gestures

TOUCHPAD_NAME="AlpsPS/2 ALPS DualPoint TouchPad"

# Check device exists
if ! xinput list --name-only | grep -Fxq "$TOUCHPAD_NAME"; then
  echo "ERROR: touchpad '$TOUCHPAD_NAME' not found. Aborting."
  exit 1
fi

echo "Setting safe libinput properties for: $TOUCHPAD_NAME"




# Enable tapping (1-finger left click) and tapping drag
xinput set-prop "$TOUCHPAD_NAME" "libinput Tapping Enabled" 1
xinput set-prop "$TOUCHPAD_NAME" "libinput Tapping Drag Enabled" 1

# Natural (reverse) scrolling
xinput set-prop "$TOUCHPAD_NAME" "libinput Natural Scrolling Enabled" 1

# Horizontal scrolling allowed
xinput set-prop "$TOUCHPAD_NAME" "libinput Horizontal Scroll Enabled" 1

# Adjust acceleration for smoother pointer travel (range -1.0 .. 1.0).
# Start modest, change later if you want.
xinput set-prop "$TOUCHPAD_NAME" "libinput Accel Speed" 0.35

# NOTE: Scrolling Pixel Distance can be touchpad-specific. We avoid forcing it here
# because some ALPS devices reject low values. If you want to experiment, see the optional commands below.

echo
echo "Creating libinput-gestures config (~/.config/libinput-gestures.conf)"

mkdir -p ~/.config
cat > ~/.config/libinput-gestures.conf <<'CFG'
# libinput-gestures - Captain's window/workspace setup

# 3-finger swipe left/right -> move focus between windows
gesture swipe left  3 xdotool key super+h
gesture swipe right 3 xdotool key super+l

# 4-finger swipe left/right -> switch workspaces
gesture swipe left  4 i3-msg workspace prev
gesture swipe right 4 i3-msg workspace next

# 3-finger swipe up/down -> rofi / window list
gesture swipe up 3 rofi -show drun
gesture swipe down 3 rofi -show window

# 4-finger swipe up/down -> volume
gesture swipe up 4 pactl set-sink-volume @DEFAULT_SINK@ +15%
gesture swipe down 4 pactl set-sink-volume @DEFAULT_SINK@ -15%

# 4-finger swipe left/right -> brightness (optional, can overlap with workspace)
#gesture swipe left 4 brightnessctl set 5%-
#gesture swipe right 4 brightnessctl set +5%


CFG

echo
echo "Attempting to start libinput-gestures (user session)."
# stop first (safe) then start
libinput-gestures-setup stop || true
libinput-gestures-setup start || echo "libinput-gestures failed to start in this session (check permissions / group membership)."

echo
echo "Done. Test your touchpad now."
echo "- Try single tap (left click), two-finger click (middle click/paste), three-finger swipe left/right for workspace, three-finger swipe up for rofi."
echo
echo "Optional: if you want 2-finger tap => RIGHT click and 3-finger tap => MIDDLE click, see the OPTIONAL commands in the accompanying instructions."
