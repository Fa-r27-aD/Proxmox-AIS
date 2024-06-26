#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to add or replace an entry in /etc/hosts
add_entry() {
    echo -e "${YELLOW}Add or replace an entry in /etc/hosts${NC}"
    old_hostname=$(hostname)
    read -p "Enter the new hostname [$old_hostname]: " new_hostname
    new_hostname=${new_hostname:-$old_hostname}

    read -p "Do you want to change the IP address? (y/n): " change_ip

    if [[ $change_ip == "y" ]]; then
        read -p "Enter the new IP address: " new_ip
    fi

    # Replace old entry with new entry in /etc/hosts
    if [[ $change_ip == "y" ]]; then
        sed -i "s/^[0-9.]*[[:space:]]*$old_hostname[[:space:]]*$/$new_ip $new_hostname/g" /etc/hosts
        echo -e "${GREEN}Changing hostname from $old_hostname to $new_hostname with new IP $new_ip in /etc/hosts...${NC}"
    else
        sed -i "s/^\([0-9.]*[[:space:]]*\)$old_hostname\([[:space:]]*\)$/\1$new_hostname\2/g" /etc/hosts
        echo -e "${GREEN}Changing hostname from $old_hostname to $new_hostname in /etc/hosts...${NC}"
    fi
    
    # Display the new IP address
    hostname --ip-address
}

# Function to add Proxmox repository
add_proxmox_repo() {
    echo -e "${YELLOW}Add Proxmox repository${NC}"
    echo "Adding Proxmox repository..."
    echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" | tee /etc/apt/sources.list.d/pve-install-repo.list > /dev/null
    echo -e "${GREEN}Proxmox repository added.${NC}"
}

# Function to download and add Proxmox GPG key
add_proxmox_gpg_key() {
    echo -e "${YELLOW}Download and add Proxmox GPG key${NC}"
    echo "Downloading Proxmox GPG key..."
    wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
    echo -e "${GREEN}Proxmox GPG key added.${NC}"
}

# Function to update and upgrade packages
update_upgrade() {
    echo -e "${YELLOW}Update and upgrade packages${NC}"
    echo "Updating package lists..."
    apt update
    echo "Upgrading packages..."
    apt full-upgrade -y
    echo -e "${GREEN}Package upgrade completed.${NC}"
}

# Function to install Proxmox default kernel
install_proxmox_kernel() {
    echo -e "${YELLOW}Install Proxmox default kernel${NC}"
    echo "Installing Proxmox default kernel..."
    apt install proxmox-default-kernel -y
    echo -e "${GREEN}Proxmox default kernel installed.${NC}"
}

# Function to reboot the system
reboot_system() {
    echo -e "${YELLOW}Reboot system${NC}"
    echo "Rebooting the system..."
    systemctl reboot
}

# Function to install Proxmox VE and additional packages
install_proxmox() {
    echo -e "${YELLOW}Install Proxmox VE, postfix, open-iscsi, and chrony${NC}"
    echo "Installing Proxmox VE, postfix, open-iscsi, and chrony..."
    apt install proxmox-ve postfix open-iscsi chrony -y
    echo -e "${GREEN}Proxmox VE, postfix, open-iscsi, and chrony installed.${NC}"
}

# Main menu
while true; do
    echo -e "${CYAN}Proxmox 8.2 auto-installer-script${NC}"
    echo -e "${CYAN}Choose an option:${NC}"
    echo -e " ${GREEN}1.${NC} Add a new entry to /etc/hosts"
    echo -e " ${GREEN}2.${NC} Add Proxmox repository"
    echo -e " ${GREEN}3.${NC} Download and add Proxmox GPG key"
    echo -e " ${GREEN}4.${NC} Update and upgrade packages"
    echo -e " ${GREEN}5.${NC} Install Proxmox default kernel"
    echo -e " ${GREEN}6.${NC} Reboot system"
    echo -e " ${GREEN}7.${NC} Install Proxmox VE, postfix, open-iscsi, and chrony"
    echo -e " ${RED}8.${NC} Exit"
    read choice

    case $choice in
        1)
            add_entry
            ;;
        2)
            add_proxmox_repo
            ;;
        3)
            add_proxmox_gpg_key
            ;;
        4)
            update_upgrade
            ;;
        5)
            install_proxmox_kernel
            ;;
        6)
            reboot_system
            ;;
        7)
            install_proxmox
            ;;
        8)
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            ;;
    esac
done
