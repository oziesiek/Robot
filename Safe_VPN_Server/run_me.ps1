# PowerShell script for automating the SSH key generation, transfer, and SSH connection to VPN server

# Step 1: Prompt user for necessary inputs
$SERVER_PUBLIC_IP = Read-Host "Please enter the Server's Public IP"
$WORKSTATION_PUBLIC_IP = Read-Host "Please enter the Workstation's Public IP"

# Step 2: Function to generate SSH keys
function Generate-SSHKeys {
    Write-Host "Generating SSH keys..."
    ssh-keygen -t rsa -f $HOME\.ssh\vpn2 -N ""  # No passphrase for the key
    Write-Host "SSH Keys generated!"
}

# Step 3: Function to transfer the public key and bash script to the server
function Transfer-Files {
    Write-Host "Transferring SSH public key to the server..."
    scp "$HOME\.ssh\vpn2.pub" root@$SERVER_PUBLIC_IP:~/.ssh/authorized_keys
    Write-Host "Public key transferred!"

    # Transfer the bash script to the server
    $bashScript = "vpn-setup.sh" 
    Write-Host "Transferring VPN setup script to the server..."
    scp $bashScript root@$SERVER_PUBLIC_IP:/root/vpn-setup.sh
    Write-Host "VPN setup script transferred!"
}

# Step 4: Function to extract public and private keys into variables
function Extract-SSHKeys {
    $pub_key = Get-Content "$HOME\.ssh\vpn2.pub"
    $priv_key = Get-Content "$HOME\.ssh\vpn2"
    Write-Host "Public key: $pub_key"
    Write-Host "Private key: $priv_key"
}

# Step 5: Function to connect to the server, run the bash script as root
function Connect-AndRunScript {
    Write-Host "Connecting to the VPN server and running the setup script..."
    ssh -i "$HOME\.ssh\vpn" root@$SERVER_PUBLIC_IP "bash /root/vpn-setup.sh"
    Write-Host "VPN setup script executed on the server!"
}

# Main execution
Generate-SSHKeys
Transfer-Files
Extract-SSHKeys
Connect-AndRunScript