#!/bin/bash

getBashVersion() {
	echo $(echo ${BASH_VERSION} | sed -E 's|([0-9])\..*|\1|')
}

bash_version="$(getBashVersion)"

switchDisplay() {
    if [ $bash_version -ge 4 ] #$1 contains bash version, we check that it is >=4 to use mapfile
	then
		mapfile -t activeOutputs < <(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
        mapfile -t connectedOutputs < <(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
	else
		IFS=$'\n' read -r -d '' -a activeOutputs < <(xrandr | grep -E " connected (primary )?[1-9]+" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
        IFS=$'\n' read -r -d '' -a connectedOutputs < <(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
	fi

    outputToActivate=$(echo ${activeOutputs[@]} ${activeOutputs[@]} ${connectedOutputs[@]} | tr ' ' '\n' | sort | uniq -u)

    if [ ! -z "$outputToActivate" ]
    then
        xrandr --output "${activeOutputs[0]}" --off --output "$outputToActivate" --auto
    else
        xrandr --output "${activeOutputs[1]}" --off --output "${activeOutputs[0]}" --auto
    fi
}

activeAll() {
    if [ $bash_version -ge 4 ] #$1 contains bash version, we check that it is >=4 to use mapfile
	then
        mapfile -t connectedOutputs < <(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
	else
        IFS=$'\n' read -r -d '' -a connectedOutputs < <(xrandr | grep " connected" | sed -e "s/\([A-Z0-9]\+\) connected.*/\1/")
	fi
    execute="xrandr "
    for display in ${connectedOutputs[@]}
    do
        execute=$execute"--output $display --auto "
    done
    `$execute`
}

if [ -z "$1" ]
then
    switchDisplay "${activeOutputs[@]}" "${connectedOutputs[@]}"
elif [ "$1" == "-a" ] || [ "$1" == "--all" ]
then
    activeAll $connectedOutputs
else
    echo "Unknow given argument \"$1\""
    echo "How to use this script =>"
    echo "\"switch_display\" will swap your displays"
    echo "\"switch_display -a\" or \"switch_display --all\" will switch all your displays on"
fi    