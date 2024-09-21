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

# Get the number of times to ping each URL
read -p "How many times do you want to ping each URL? " ping_count

# Calculate total time for execution
total_time=$((url_count * ping_count * interval))
echo "Total execution time will be approximately $total_time seconds."

# Ping each URL for the specified number of times
for url in "${urls[@]}"
do
    for (( j=1; j<=ping_count; j++ ))
    do
        echo "Pinging $url (Attempt #$j)..."
        curl -s -o /dev/null -w "HTTP Response Code: %{http_code}\n" "$url"
        sleep "$interval"
    done
done
