#!/usr/bin/env bash
echo "$(date) Starting Gammastep…" >> /tmp/gammastep.log
sleep 2
gammastep -c ~/.config/gammastep/config >> /tmp/gammastep.log 2>&1
echo "$(date) Gammastep exited with status $?" >> /tmp/gammastep.log
