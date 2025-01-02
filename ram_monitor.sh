#!/bin/bash

# RAM usage limit (percentage)
LIMIT=95  # Change to 90 if you want a lower limit

# Function to get current RAM usage
get_ram_usage() {
    free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
}

# Function to terminate pnpm or yarn processes
kill_dev_process() {
    # Find running pnpm or yarn processes
    PID=$(ps aux | grep -E 'pnpm dev|yarn dev' | grep -v grep | awk '{print $2}')
    if [[ ! -z "$PID" ]]; then
        echo "RAM has reached the limit of $LIMIT%. Terminating process with PID $PID."
        kill -9 $PID
    else
        echo "No development server processes found."
    fi
}

# Function to terminate processes on port 3000
kill_port_3000() {
    PID=$(lsof -t -i:3000)
    if [[ ! -z "$PID" ]]; then
        echo "Port 3000 is being used by process with PID $PID. Terminating process."
        kill -9 $PID
        killall -SIGINT node
    else
        echo "No processes are using port 3000."
    fi
}

# Loop to periodically monitor RAM usage
while true; do
    RAM_USAGE=$(get_ram_usage)
    echo "RAM usage: $RAM_USAGE%"
    if (( RAM_USAGE >= LIMIT )); then
        kill_dev_process
        kill_port_3000
    fi
    sleep 5  # Check every 5 seconds
done
