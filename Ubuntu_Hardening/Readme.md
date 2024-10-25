# Ubuntu Hardening Scripts 🛡️

Welcome to the Ubuntu Hardening Scripts repository! This project provides a set of scripts designed to enhance the security of your Ubuntu 22.04 server. The scripts include installation of necessary packages and running OpenSCAP reports to assess system compliance.

## Table of Contents 📚
- [Prerequisites](#prerequisites)
- [Installation Instructions](#installation-instructions)
- [Running the OpenSCAP Report](#running-the-openscap-report)
- [Important Considerations](#important-considerations)

## Prerequisites ⚙️
Before you begin, ensure you have:
- A running instance of Ubuntu.
- Sudo privileges to install packages and make system changes.

## Installation Instructions 🚀
1. **Clone the Repository**:
   First, clone this repository to your local machine:

   git clone https://github.com/oziesiek/Robot/Ubuntu_Hardening.git
   cd Ubuntu_Hardening

2. **Run the Installation Script**:
   Execute the `install.sh` script to install the necessary packages and set up the environment:

   chmod +x install.sh
   ./install.sh
 
   This script will:
   - Update the package list.
   - Install essential packages, including Apache for live report view and OpenSCAP.
   - Start and enable the Apache service.
   - Download and compile OpenSCAP.

   **Note**: During the installation, the script will provide colored output to indicate the progress of each step. Please pay attention to any warnings or errors.

## Running the OpenSCAP Report 📊
After the installation is complete, you can run the OpenSCAP report to assess your system's compliance:

1. **Execute the OpenSCAP Report Script**:
   Run the `oscap_report.sh` script:

   chmod +x oscap_report.sh
   ./oscap_report.sh

   This script will generate a compliance report based on the security policies defined for your Ubuntu system which you can view in your browser.

## Important Considerations ⚠️
- **Test Environment**: It is highly recommended to test these scripts in a non-production environment before applying them to your live server. This will help you understand the changes being made and avoid potential disruptions.
  
- **User Adjustments**: Each user should carefully review and adjust the scripts to fit their specific server configuration and security requirements. This is crucial to maintain control over your server and prevent accidental lockouts or service interruptions.

- **Backup**: Always create backups of critical files and configurations before running these scripts. This ensures that you can restore your system to its previous state if needed.

---
If you have any questions or need further assistance, please don't hesitate to reach out! 😊