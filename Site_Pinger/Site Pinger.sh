#!/bin/bash

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

# Calculate total time for execution
total_time=$((url_count * interval))
echo "Total execution time will be approximately $total_time seconds."

# Ping each URL at the specified interval
for url in "${urls[@]}"
do
    while true; do
        echo "Pinging $url..."
        curl -s -o /dev/null -w "HTTP Response Code: %{http_code}\n" "$url"
        sleep "$interval"
    done
done
