#!/bin/bash

# VPN Auto-Setup Script for Ubuntu 20.04 with WireGuard
# Assumes connecting with Windows 11 client

# Prompt user for the workstation's public IP
printf "\033[1;33m" 
read -rp "Please enter the Workstation's Public IP: " WORKSTATION_PUBLIC_IP
read -rp "Please enter the Server's Public IP: " SERVER_PUBLIC_IP
printf "\033[0m" 

# Define global variables for the script
PRIV_SERVER=""
PUB_SERVER=""
PRIV_C1=""
PUB_C1=""
INTERFACE=""

# Function to configure SSH settings
configure_ssh() {
    printf "\033[1;34mConfiguring SSH...\n\033[0m" 
    sed -i '58s/.*/PasswordAuthentication no/' /etc/ssh/sshd_config # Set PasswordAuthentication to no
    systemctl restart sshd
    printf "\033[1;34mSSH Password authentication disabled and restarted!\n\033[0m" 
}

# Function to configure UFW firewall
configure_ufw() {
    printf "\033[1;31mConfiguring UFW...\n\033[0m" 
    
    # Delete all existing UFW rules allowing SSH (port 22)
    ufw reset && printf "All UFW rules have been deleted\n" # Reset UFW to delete all rules
    
    # Allow SSH from the specified workstation IP
    ufw allow from $WORKSTATION_PUBLIC_IP to any port 22 && printf "UFW rule added for workstation IP\n" # Allow SSH from workstation IP
    
    # Allow WireGuard client IP for port 12345
    ufw allow from 10.10.10.2/32 to any port 12345 proto udp && printf "UFW rule added for WireGuard client IP\n" # Allow WireGuard client IP for port 12345

    # Enable UFW if it's not already enabled
    ufw enable && printf "UFW has been enabled\n" 
   
    # Display UFW status
    ufw status | grep -i "active" --color=auto
}

# Function to install WireGuard and generate keys
install_wireguard() {
    printf "\033[1;31mInstalling WireGuard...\n\033[0m"
    apt update
    apt install wireguard-tools -y
    umask 077

    # Generate keys
    PRIV_SERVER=$(wg genkey | tee priv_server)
    PUB_SERVER=$(echo "$PRIV_SERVER" | wg pubkey)

    PRIV_C1=$(wg genkey | tee priv_c1)
    PUB_C1=$(echo "$PRIV_C1" | wg pubkey)

    printf "\033[1;31mWireGuard installed and keys generated!\n\033[0m"
}

# Function to get network interface for internet
get_network_interface() {
    printf "\033[1;34mGetting network interface...\n\33[0m"
    INTERFACE=$(ip a | grep -E "^[0-9]+:" | grep -v "lo" | awk -F': ' '{print $2}' | head -n 1)
    printf "Detected Interface: %s\n" "$INTERFACE"
}

# Function to configure WireGuard
configure_wireguard() {
    printf "Configuring WireGuard...\n"
    cat > /etc/wireguard/wg1.conf <<EOF
[Interface]
Address = 10.10.10.1/24
ListenPort = 12345
PrivateKey = $PRIV_SERVER
PostUp = sysctl net.ipv4.ip_forward=1; iptables -A FORWARD -i wg1 -j ACCEPT; iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE; ufw allow 12345/udp; ufw allow from 10.10.10.0/24 to any port 22 proto tcp
PostDown = sysctl net.ipv4.ip_forward=0; iptables -D FORWARD -i wg1 -j ACCEPT; iptables -t nat -D POSTROUTING -o $INTERFACE -j MASQUERADE; ufw deny 12345/udp; ufw deny from 10.10.10.0/24 to any port 22 proto tcp

[Peer]
PublicKey = $PUB_C1
AllowedIPs = 10.10.10.2/32
EOF
    printf "WireGuard configuration added to wg1.conf\n"
}

# Function to start WireGuard
start_wireguard() {
    printf "\033[1;34 Starting WireGuard...\n\33[0m"
    wg-quick up wg1
    ip a | grep wg1 --color=auto
    ufw status | grep -i "active" --color=auto
    printf "\033[1;34WireGuard started!\n\33[0m"
}

# Main function to run the script
main() {
    configure_ssh
    configure_ufw
    install_wireguard
    get_network_interface
    configure_wireguard
    start_wireguard

    # Print WireGuard configuration for user
    printf "\033[38;5;208mCopy below configuration to your WireGuard Client and run VPN\033[0m"
    printf "\n\033[1;32m" # Set text color to green
    printf "[Interface]\n"
    printf "PrivateKey = %s\n" "$PRIV_C1"
    printf "Address = 10.10.10.2/32\n"
    printf "DNS = 1.1.1.1, 8.8.8.8\n\n"
    printf "[Peer]\n"
    printf "PublicKey = %s\n" "$PUB_SERVER"
    printf "AllowedIPs = 0.0.0.0/0\n"
    printf "Endpoint = $SERVER_PUBLIC_IP:12345\n"
    printf "PersistentKeepalive = 25\n"
    printf "\033[0m" # Reset text color
}

main

