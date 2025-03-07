#!/bin/bash
echo -e "\e[31mShadowsocks installation in progress - please wait\e[0m"
# download and install SOCKS5 Shadowsocks 
sudo apt update > /dev/null 2>&1 && sudo apt install -y shadowsocks-libev > /dev/null 2>&1
sleep 2

# Generate a strong 12-character password
PASSWORD=$(openssl rand -base64 12)

# configure SOCKS5 ShadowSocks
echo -e "\e[36mAdding Shadowsocks configuration\e[0m"
sudo tee /etc/shadowsocks-libev/config.json > /dev/null <<EOF
{
    "server": "0.0.0.0",
    "server_port": 8388,
    "password": "$PASSWORD",
    "timeout": 300,
    "method": "aes-256-gcm",
    "fast_open": true,
    "mode": "tcp_and_udp"
}
EOF

# Restart service and enable autostart
echo -e "\e[33mRestarting Shadowsocks and enabling autostart\e[0m"
sudo systemctl enable shadowsocks-libev > /dev/null 2>&1
sudo systemctl restart shadowsocks-libev > /dev/null 2>&1
sleep 2

# Firewall opening
echo -e "\e[31mOpening port 8388 in UFW\e[0m"
    sudo ufw allow 8388/tcp > /dev/null 2>&1
    sudo ufw allow 8388/udp > /dev/null 2>&1
sleep 2

# Status check
echo -e "\e[32mCheck Shadowsocks status\e[0m"
sudo systemctl status shadowsocks-libev --no-pager

# Display server IP and password
SERVER_IP=$(hostname -I | awk '{print $1}')
echo -e "\e[95mPlease configure your Shadowsocks with below details\e[0m"
echo -e "\e[35mServer IP: $SERVER_IP\e[0m"
echo -e "\e[35mGenerated Password: $PASSWORD\e[0m"
echo -e "\e[35mEncryption: aes-256-gcm\e[0m"

