#!/bin/bash

# Get the number of repetitions from the user
read -p "Enter the number of repetitions: " repetitions

# Get the time interval from the user (in seconds)
read -p "Enter the time interval (in seconds): " interval

# URLs to check
url1="https://www.olx.pl/d/oferta/uchwyt-do-monitora-vesa-100x100-bardzo-dobry-stan-CID99-ID122gAM.html?bs=olx_pro_listing"
url2="https://www.olx.pl/d/oferta/drazek-multi-grip-do-sufitu-sciany-w-dobrym-stanie-okazyjna-cena-CID767-ID122g0W.html?bs=olx_pro_listing"

# Calculate total execution time
total_seconds=$((interval * (repetitions - 1)))

# Convert seconds to minutes and seconds
minutes=$((total_seconds / 60))
seconds=$((total_seconds % 60))

# Display the estimated total execution time
if [ $minutes -gt 0 ]; then
    echo "The script will take approximately $minutes minutes and $seconds seconds to complete."
else
    echo "The script will take approximately $seconds seconds to complete."
fi

# Perform the HTTP request the given number of times at specified intervals
for ((i=1; i<=repetitions; i++))
do
    echo "Request $i to $url1"
    curl -s -o /dev/null -w "%{http_code}\n" "$url1"  # Make a request to URL1 and display the HTTP status code

    echo "Request $i to $url2"
    curl -s -o /dev/null -w "%{http_code}\n" "$url2"  # Make a request to URL2 and display the HTTP status code

    # Wait for the specified interval if this is not the last iteration
    if [ $i -lt $repetitions ]; then
        sleep $interval
    fi
done
