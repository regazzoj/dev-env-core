#!/bin/bash
id=$(xinput | sed '/Touchpad/s/.*id=\([0-9]*\).*/\1/;t;d')
status=$(xinput --list-props $id | grep "Device Enabled" | cut -f 3)
if [ $status -eq 1 ]; then
    xinput --disable $id
else
    xinput --enable $id
fi