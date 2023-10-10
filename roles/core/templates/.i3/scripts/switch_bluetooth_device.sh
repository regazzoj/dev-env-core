#!/bin/sh

device_mac_address=$1

if [[ $(pacmd list-cards | grep -c "name: <${device_mac_address}>") -eq 0 ]]; then
  exit 0;
elif [[ $(pacmd list-cards | grep -c "active profile: <a2dp_sink>") -eq 1 ]]; then
  echo "Enable \"handsfree_head_unit\" profile for device \"${device_mac_address}\"";
  pacmd set-card-profile ${device_mac_address} handsfree_head_unit;
else
  echo "Enable \"a2dp_sink\" profile for device \"${device_mac_address}\"";
  pacmd set-card-profile ${device_mac_address} a2dp_sink;
fi