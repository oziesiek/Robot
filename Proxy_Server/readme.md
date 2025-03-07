# Shadowsocks Proxy Server Setup

<img src="https://camo.githubusercontent.com/e147f8c2377335066df0b7cc791b55ebda8d442a3e549f14a04bbea406f4fd68/68747470733a2f2f73742e6f766572636c6f636b6572732e72752f6c65676163792f626c6f672f33343334322f3134373736385f4f2e6a7067" height="300">

Welcome to the Shadowsocks Proxy Server Setup repository! This project provides a streamlined way to set up a Shadowsocks proxy server on your machine, ensuring secure and private internet browsing.

## Overview  📋

This repository contains scripts to automate the installation and configuration of a Shadowsocks proxy server. It includes:

- **Bash Script**: Automates the installation and configuration of Shadowsocks on a Linux server.
- **PowerShell Script**: Facilitates SSH key generation, transfer, and connection to the server.

## Features ✨

- **Automated Setup**: Quickly set up a Shadowsocks server with minimal manual intervention.
- **Secure Configuration**: Generates a strong, random password for each setup.
- **Firewall Configuration**: Automatically opens necessary ports for Shadowsocks.

## Prerequisites 📌

- A Linux server with root access.
- Basic knowledge of SSH and server management.
- Ensure your server is secured and hardened against unauthorized access.

## How to Run 🏃‍♂️

1. **Clone the Repository**:
2. **Run the PowerShell Script**:
   - Open PowerShell and navigate to the repository directory.
   - Execute the script to generate SSH keys and transfer the setup script:
     .\run_me.ps1
3. **Connect to the Server**:
4. **Execute the Setup Script**:
   - Once connected, run the setup script on your server:
     bash /root/proxy-setup.sh
5. **Verify Installation**:
   - Check the status of the Shadowsocks client service on your Windows computer to ensure it's running correctly.

## Security Note ⚠️

For your safety, remember to harden your proxy server. This includes closing connections without a key and implementing other security best practices to protect your server from unauthorized access.