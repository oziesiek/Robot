#!/bin/bash

# VPN Auto-Setup Script for Ubuntu 20.04 with WireGuard
# Assumes connecting with Windows 11 client

# Prompt user for the workstation's public IP
read -rp "Please enter the Workstation's Public IP: " WORKSTATION_PUBLIC_IP

# Define global variables for the script
PRIV_SERVER=""
PUB_SERVER=""
PRIV_C1=""
PUB_C1=""
INTERFACE=""

# Function to configure SSH settings
configure_ssh() {
    printf "Configuring SSH...\n"
    sed -i '58s/^/#/' /etc/ssh/sshd_config # Disable PasswordAuthentication
    systemctl restart sshd
    printf "SSH Passwd auth. disabled and restarted!\n"
}

# Function to configure UFW firewall
configure_ufw() {
    printf "Configuring UFW...\n"
    ufw delete 2 && printf "UFW rule 2 for IPv6 deleted\n"
    ufw allow from $WORKSTATION_PUBLIC_IP to any port 22 && printf "UFW rule added for workstation IP\n"
    ufw status | grep -i "active" --color=auto
}

# Function to install WireGuard and generate keys
install_wireguard() {
    printf "Installing WireGuard...\n"
    apt update
    apt install wireguard-tools -y
    umask 077

    # Generate keys
    PRIV_SERVER=$(wg genkey | tee priv_server)
    PUB_SERVER=$(echo "$PRIV_SERVER" | wg pubkey)

    PRIV_C1=$(wg genkey | tee priv_c1)
    PUB_C1=$(echo "$PRIV_C1" | wg pubkey)

    printf "WireGuard installed and keys generated!\n"
    printf "Server Private Key: %s\n" "$PRIV_SERVER"
    printf "Server Public Key: %s\n" "$PUB_SERVER"
    printf "Client Private Key: %s\n" "$PRIV_C1"
    printf "Client Public Key: %s\n" "$PUB_C1"
}

# Function to get network interface for internet
get_network_interface() {
    printf "Getting network interface...\n"
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
    printf "Starting WireGuard...\n"
    wg-quick up wg1
    ip a | grep wg1 --color=auto
    ufw status | grep -i "active" --color=auto
    printf "WireGuard started!\n"
}

# Main function to run the script
main() {
    configure_ssh
    configure_ufw
    install_wireguard
    get_network_interface
    configure_wireguard
    start_wireguard
}

main

