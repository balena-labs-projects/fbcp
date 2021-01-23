#!/bin/sh

if [ ! -e /dev/fb1 ]
then
    echo "Display not detected, exiting..."
    exit 0
fi

# workaround for plymouth blocking fbcp
# https://github.com/klutchell/balena-pihole/issues/25
# https://github.com/balena-os/meta-balena/issues/1772
dbus-send \
    --system \
    --dest=org.freedesktop.systemd1 \
    --type=method_call \
    --print-reply \
    /org/freedesktop/systemd1 org.freedesktop.systemd1.Manager.StartUnit \
    string:"plymouth-quit.service" string:"replace"

exec /usr/src/app/fbcp
