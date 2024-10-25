#!/bin/bash

# Change to the home directory
cd ~

# Display information about the specified OpenSCAP content file
oscap info content/build/ssg-ubuntu2204-ds.xml

# Create the directory for the web server if it doesn't exist
sudo mkdir -p /var/www/html/

# Evaluate the security profile and generate results and report files
oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_cis_level2_server --results ~/openscap-results.xml --report ~/cis_start.html ~/content/build/ssg-ubuntu2204-ds.xml

# Copy the generated report to the web server's root directory as index.html
sudo cp ~/cis_start.html /var/www/html/index.html

# Set permissions for the index.html file to be readable by everyone
sudo chmod 644 /var/www/html/index.html

# Generate a fix script based on the evaluation results
oscap xccdf generate fix --fix-type bash --output fixes.sh --result-id xccdf_org.ssgproject.content_profile_stig ~/content/build/ssg-ubuntu2204-ds.xml