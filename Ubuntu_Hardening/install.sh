#!/bin/bash

# Define color codes
GREEN='\033[0;32m'   # Green
YELLOW='\033[1;33m'  # Yellow
RED='\033[0;31m'     # Red
NC='\033[0m'         # No Color

# Update and get dependencies 
echo -e "${YELLOW}Updating package list...${NC}"
sudo apt update

# Install necessary packages
echo -e "${YELLOW}Installing necessary packages...${NC}"
sudo apt install -y apache2 bzip2 build-essential cmake make git libbz2-dev libcurl4-openssl-dev libgcrypt20-dev libglib2.0-dev libgnutls28-dev libpcap-dev libssh-dev libxml2-dev libxml2-utils libxmlsec1-dev libxslt1-dev xsltproc libopenscap8 
echo -e "${GREEN}Apache service started and enabled to start on boot.${NC}"
sudo systemctl start apache2  # Start Apache service
sudo systemctl enable apache2 # Enable Apache to start on boot

# Download and extract OpenSCAP
echo -e "${YELLOW}Downloading OpenSCAP...${NC}"
wget https://github.com/OpenSCAP/openscap/releases/download/1.4.0/openscap-1.4.0.tar.gz
echo -e "${YELLOW}Extracting OpenSCAP...${NC}"
tar -xvzf openscap-1.4.0.tar.gz
cd openscap-1.4.0
echo -e "${YELLOW}Configuring the build...${NC}"
cmake ..  # Configure the build
echo -e "${YELLOW}Compiling the source code...${NC}"
make      # Compile the source code
echo -e "${GREEN}Installing the compiled binaries...${NC}"
make install  # Install the compiled binaries
ldconfig  # Update the shared library cache

# Profiles
cd ~
echo -e "${YELLOW}Cloning compliance content repository...${NC}"
git clone https://github.com/ComplianceAsCode/content.git  # Clone compliance content repository
cd content/build
echo -e "${YELLOW}Configuring the build for compliance content...${NC}"
cmake ..  # Configure the build for compliance content

# Path to the CMakeCache.txt file
input_file="CMakeCache.txt"

# Temporary output file
temp_file=$(mktemp)

# Initialize line number variable
line_number=0

# Process the file line by line
while IFS= read -r line; do
    ((line_number++))
    if ((line_number >= 193 && line_number <= 296)) && [[ "$line" != "SSG_PRODUCT_UBUNTU2204:BOOL=ON" ]]; then
        # Replace :BOOL=ON with :BOOL=OFF in the relevant lines
        echo "${line/:BOOL=ON/:BOOL=OFF}" >> "$temp_file"
    else
        # Copy lines unchanged
        echo "$line" >> "$temp_file"
    fi
done < "$input_file"

# Replace the original file with the temporary one
mv "$temp_file" "$input_file"

echo -e "${YELLOW}Compiling the project again...${NC}"
make  # Compile the project again
echo -e "${GREEN}Rebooting the system...${NC}"
sudo shutdown -r now  # Reboot the system