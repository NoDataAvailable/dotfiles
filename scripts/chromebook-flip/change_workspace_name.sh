#!/bin/bash

for O in 0 1 2; do
    IS_ACTIVE=$(i3-msg -t get_outputs | jq ".[$O].active")
    if [[ $IS_ACTIVE == "true" ]]; then
        CURR_NAME=$(i3-msg -t get_outputs | jq ".[$O].current_workspace")
    fi
done

CURR_NUM=${CURR_NAME%:*}
CURR_NUM=${CURR_NUM#\"}
CURR_NUM=${CURR_NUM%\"}

echo "rename workspace to \"$CURR_NUM: $1\""
i3-msg "rename workspace to \"$CURR_NUM: $1\""

kill `pidof dzen2`
