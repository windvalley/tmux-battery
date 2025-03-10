#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/helpers.sh"

# script global variables
icon_charge_tier8=''
icon_charge_tier7=''
icon_charge_tier6=''
icon_charge_tier5=''
icon_charge_tier4=''
icon_charge_tier3=''
icon_charge_tier2=''
icon_charge_tier1=''

# script default variables
icon_charge_tier8_default='█'
icon_charge_tier7_default='▇'
icon_charge_tier6_default='▆'
icon_charge_tier5_default='▅'
icon_charge_tier4_default='▄'
icon_charge_tier3_default='▃'
icon_charge_tier2_default='▂'
icon_charge_tier1_default='▁'

# icons are set as script global variables
get_icon_charge_settings() {
    icon_charge_tier8=$(get_tmux_option "@batt_icon_charge_tier8" "$icon_charge_tier8_default")
    icon_charge_tier7=$(get_tmux_option "@batt_icon_charge_tier7" "$icon_charge_tier7_default")
    icon_charge_tier6=$(get_tmux_option "@batt_icon_charge_tier6" "$icon_charge_tier6_default")
    icon_charge_tier5=$(get_tmux_option "@batt_icon_charge_tier5" "$icon_charge_tier5_default")
    icon_charge_tier4=$(get_tmux_option "@batt_icon_charge_tier4" "$icon_charge_tier4_default")
    icon_charge_tier3=$(get_tmux_option "@batt_icon_charge_tier3" "$icon_charge_tier3_default")
    icon_charge_tier2=$(get_tmux_option "@batt_icon_charge_tier2" "$icon_charge_tier2_default")
    icon_charge_tier1=$(get_tmux_option "@batt_icon_charge_tier1" "$icon_charge_tier1_default")
}

print_icon_charge() {
    percentage=$($CURRENT_DIR/battery_percentage.sh | sed -e 's/%//')
    if [ $percentage -ge 95 -o "$percentage" == "" ]; then
        # if percentage is empty, assume it's a desktop
        printf "$icon_charge_tier8"
    elif [ $percentage -ge 80 ]; then
        printf "$icon_charge_tier7"
    elif [ $percentage -ge 65 ]; then
        printf "$icon_charge_tier6"
    elif [ $percentage -ge 50 ]; then
        printf "$icon_charge_tier5"
    elif [ $percentage -ge 35 ]; then
        printf "$icon_charge_tier4"
    elif [ $percentage -ge 20 ]; then
        printf "$icon_charge_tier3"
    elif [ $percentage -gt 5 ]; then
        printf "$icon_charge_tier2"
    else
        printf "$icon_charge_tier1"
    fi
}

main() {
    local update_interval=$(get_tmux_option $battery_update_interval_option $battery_update_interval_default)
    local current_time=$(date "+%s")
    local previous_update=$(get_tmux_option "@iconcharge_previous_update_time")
    local delta=$((current_time - previous_update))

    if [[ -z "$previous_update" ]] || [[ $delta -ge $update_interval ]]; then
        local value=$(
            get_icon_charge_settings
            print_icon_charge
        )

        if [ "$?" -eq 0 ]; then
            set_tmux_option "@iconcharge_previous_update_time" "$current_time"
            set_tmux_option "@iconcharge_previous_value" "$value"
        fi
    fi

    echo -n "$(get_tmux_option "@iconcharge_previous_value")"
}

main
