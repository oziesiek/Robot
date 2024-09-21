#!/bin/bash

# Function to output colored text
color_output() {
    case $1 in
        2*) echo -e "\e[32m$1\e[0m" ;;  # Green for 2xx
        3*) echo -e "\e[33m$1\e[0m" ;;  # Yellow for 3xx
        4*) echo -e "\e[31m$1\e[0m" ;;  # Red for 4xx
        5*) echo -e "\e[31m$1\e[0m" ;;  # Red for 5xx
        *) echo "$1" ;;                 # Default (no color)
    esac
}

# Get the number of URLs from the user
read -p "How many URLs do you want to ping? " url_count
urls=()

# Loop to collect URLs
for (( i=1; i<=url_count; i++ ))
do
    read -p "Enter URL #$i: " url
    urls+=("$url")
done

# Get the interval time from the user
read -p "Enter the time interval (in seconds): " interval

# Get the number of times to ping each URL
read -p "How many times do you want to ping each URL? " ping_count

# Calculate total time for execution
total_time=$((url_count * ping_count * interval))
total_minutes=$((total_time / 60))
echo "Total execution time will be approximately $total_time seconds ($total_minutes minutes)."

# Function to ping a URL
ping_url() {
    local url=$1
    local url_number=$2
    for (( j=1; j<=ping_count; j++ ))
    do
        echo "Pinging URL #$url_number (Attempt #$j)..."

        # Perform a detailed curl request to simulate a real user
        response_code=$(curl -s -o /dev/null -w "%{http_code}" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.6167.160 Safari/537.36" --location "$url")

        # Output the colored response code
        echo "Response code for URL #$url_number: $(color_output "$response_code")"

        sleep "$interval"
    done
}

# Ping each URL in the background
for i in "${!urls[@]}"
do
    ping_url "${urls[i]}" "$((i+1))" &
done

# Wait for all background processes to finish
wait
