# 🌐 WireGuard VPN Auto-Setup for Ubuntu 20.04

![WireGuard Logo](https://www.wireguard.com/img/wireguard.svg)

## Overview 🚀
This project provides a fully automated **VPN server setup** using **WireGuard** on an Ubuntu 20.04 server, ideal for creating a secure VPN that connects to a Windows 11 client. This script allows for very fast deployment of a VPN server, which can be particularly useful for OSINT (Open Source Intelligence) activities.

The script handles:
- 🔒 **SSH configuration**
- 🔥 **Firewall setup** (UFW)
- 🔑 **WireGuard key generation**
- 📡 **VPN configuration** with WireGuard

No manual intervention is required, making the process **fast**, **secure**, and **reliable**.

## Requirements 🛠️
- **Ubuntu 20.04** server with root access
- **SSH access** to the server
- **WireGuard** installed on the client machine (e.g., Windows 11)

## Features ✨
- Fully automates the VPN setup process 🔧
- Generates and configures WireGuard keys securely 🔑
- Adjusts firewall rules for secure SSH and VPN connections 🛡️
- Configures a WireGuard VPN tunnel 🖧
- **Fast deployment** of VPN servers for OSINT and other use cases 🚀

## Installation and Usage 📖

### 1️⃣ Clone the repository
Clone the GitHub repository to your local machine. Place `run_me.ps1` & `vpn-setup.sh` in the same folder and run `run_me.ps1`. 
You will be prompted to enter the server's public IP address and your workstation's public IP address.

To get the `<client-private-key>` and `<server-public-key>`, refer to the output of the setup script. The script prints both during execution.

### 4️⃣ Verify the VPN connection 🔍
In your system, open WireGuard and create a new connection & input values provided by the script at the of execution.

## FAQs ❓
**What is WireGuard?**

WireGuard is a simple, fast, and modern VPN that utilizes state-of-the-art cryptography.

**Why use this script?**

This script automates the tedious manual steps for configuring a VPN on Ubuntu, ensuring consistency and reducing potential for errors.

**Can I run this on other Linux distributions?**

This script is optimized for Ubuntu 20.04, but with minor adjustments, it may work on other distributions.

## Contributing 🤝

If you find this project useful, please give it a ⭐️ on GitHub — it helps others discover this project!
