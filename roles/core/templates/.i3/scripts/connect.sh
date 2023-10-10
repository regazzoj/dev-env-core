#!/bin/sh

device_mac_address=$1

bluetoothctl -- pair ${device_mac_address} && sleep 5
bluetoothctl -- trust ${device_mac_address}
bluetoothctl -- connect ${device_mac_address}