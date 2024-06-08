# Proxmox-AIS

This script provides a simple menu-driven interface for automating the setup process of a Proxmox 8.2 server on Debian 12. It includes options to add entries to /etc/hosts, add the Proxmox repository, download and add the Proxmox GPG key, update and upgrade packages, install the Proxmox default kernel, install Proxmox VE, postfix, open-iscsi, and chrony, and reboot the system.

## Usage

1. Run the script as the root user:
 
   ```bash
   bash -c "$(wget -qLO - https://raw.githubusercontent.com/Fa-r27-aD/Proxmox-AIS/main/pve8-2-ais.sh)"
   ```
   ```bash
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/Fa-r27-aD/Proxmox-AIS/main/pve8-2-ais.sh)"
   ```
   
2. Follow the on-screen instructions to select and execute actions.

## Notes

This script is intended for users who have installed and set up Debian 12 and want to implement Proxmox.
Ensure you have sudo privileges to run the script.
