# PowerShell script for automating the SSH key generation, transfer, and SSH connection to VPN server

# Step 1: Prompt user for necessary inputs
$SERVER_PUBLIC_IP = Read-Host "Please enter the Server's Public IP"


# Step 2: Function to generate SSH keys
function Generate-SSHKeys {
     
    Write-Host "Generating SSH keys..." -ForegroundColor Blue
    ssh-keygen -t rsa -b 2048 -f "$HOME\.ssh\vpn_key" ""  # Non-interactive key generation
    Write-Host "SSH keys generated!" -ForegroundColor Green
}

# Step 3: Function to transfer the public key and bash script to the server
function Transfer-Files {
    Write-Host "Transferring SSH public key to the server..." -ForegroundColor Blue
    scp "$HOME\.ssh\vpn_key.pub" "root@${SERVER_PUBLIC_IP}:~/.ssh/authorized_keys"
    Write-Host "Public key transferred!"

    # Transfer the bash script to the server
    $bashScript = "vpn-setup.sh" 
    Write-Host "Transferring VPN setup script to the server..." -ForegroundColor Blue
    scp "$bashScript" "root@${SERVER_PUBLIC_IP}:/root/vpn-setup.sh"
    Write-Host "VPN setup script transferred!"
}

# Call the function with the key name
Generate-SSHKeys -KeyName vpn_key
Transfer-Files

# Final output
Write-Host "Your SSH keys have been generated and transferred along with the setup script to the server." -ForegroundColor Green
Write-Host "Please use the following command to connect to the server and run the vpn-setup.sh:" 
Write-Host "ssh -i $HOME\.ssh\vpn_key root@$SERVER_PUBLIC_IP" -ForegroundColor Red



