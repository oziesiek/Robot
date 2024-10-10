# PowerShell script for automating the SSH key generation, transfer, and SSH connection to VPN server

# Step 1: Prompt user for necessary inputs
$SERVER_PUBLIC_IP = Read-Host "Please enter the Server's Public IP"

# Step 2: Function to generate SSH keys
function Generate-SSHKeys {
    Write-Host "Generating SSH keys..."
    ssh-keygen -t rsa -f $HOME\.ssh\vpn2 -N ""  # No passphrase for the key
    Write-Host "SSH Keys generated!"
}

# Step 3: Function to transfer the public key and bash script to the server
function Transfer-Files {
    Write-Host "Transferring SSH public key to the server..."
    scp "$HOME\.ssh\vpn2.pub" root@{$SERVER_PUBLIC_IP}:~/.ssh/authorized_keys
    Write-Host "Public key transferred!"

    # Transfer the bash script to the server
    $bashScript = "vpn-setup.sh" 
    Write-Host "Transferring VPN setup script to the server..."
    scp $bashScript root@{$SERVER_PUBLIC_IP}:/root/vpn-setup.sh
    Write-Host "VPN setup script transferred!"
}
Generate-SSHKeys
Transfer-Files

# Final output
Write-Host "Your SSH keys have been generated and transferred along with the setup script to the server."
Write-Host "Please use the following command to connect to the server and run the script:"
Write-Host "ssh -i $HOME\.ssh\vpn2 root@$SERVER_PUBLIC_IP"



