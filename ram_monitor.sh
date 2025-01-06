#!/bin/bash

# RAM usage limit (percentage)
LIMIT=95  # Change to 90 if you want a lower limit

# Function to get current RAM usage
get_ram_usage() {
    free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

# Loop to monitor RAM periodically
while true; do
    RAM_USAGE=$(get_ram_usage)
    echo "RAM usage: $RAM_USAGE%"
    if (( RAM_USAGE >= LIMIT )); then
    	echo "RAM has reached the limit of $LIMIT%. Stopping node processes."
        killall -SIGINT node
    fi
    sleep 5  # Check every 5 seconds
done
