#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display welcome message
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}           Welcome to the PocketFiBot  Installation           ${NC}"
echo -e "${GREEN}============================================================${NC}"
echo -e "${YELLOW}Auto script installer by: 🚀 AIRDROP SEIZER 💰${NC}"
echo -e "${YELLOW}Join our channel on Telegram: https://t.me/airdrop_automation${NC}"
echo -e "${GREEN}============================================================${NC}"

# Function to install a package if not already installed
install_if_not_installed() {
    pkg_name=$1
    if ! dpkg -s "$pkg_name" >/dev/null 2>&1; then
        echo -e "${BLUE}Installing ${pkg_name}...${NC}"
        pkg install "$pkg_name" -y
    else
        echo -e "${GREEN}${pkg_name} is already installed. Skipping...${NC}"
    fi
}

# Install necessary packages
install_packages() {
    echo -e "${BLUE}Updating package lists...${NC}"
    pkg update
    for pkg in git nano clang cmake ninja rust make tur-repo python3.10 libjpeg-turbo libpng zlib; do
        install_if_not_installed "$pkg"
    done
}

# Function to set up and activate virtual environment
setup_virtualenv() {
    python3.10 -m venv venv
    source venv/bin/activate
}

# Check if PocketFiBot directory exists
if [ ! -d "PocketFiBot" ]; then
    # Install packages and clone repo
    install_packages
    echo -e "${BLUE}Upgrading pip and installing wheel...${NC}"
    pip3.10 install --upgrade pip wheel --quiet
    echo -e "${BLUE}Cloning PocketFiBot repository...${NC}"
    git clone https://github.com/rjfahad/PocketFiBot

    # Navigate to PocketFiBot and set up
    cd PocketFiBot || exit
    echo -e "${BLUE}Copying .env-example to .env...${NC}"
    cp .env-example .env
    echo -e "${YELLOW}Opening .env file for editing...${NC}"
    nano .env
    echo -e "${BLUE}Setting up Python virtual environment...${NC}"
    setup_virtualenv
    echo -e "${BLUE}Installing Python dependencies...${NC}"
    pip3.10 install -r requirements.txt pillow --quiet

    echo -e "${GREEN}Installation completed! You can now run the bot.${NC}"
else
    cd PocketFiBot || exit
    echo -e "${GREEN}PocketFiBot is already installed.${NC}"
fi

# Activate virtual environment if not already active
if [ ! -f "venv/bin/activate" ]; then
    echo -e "${BLUE}Setting up Python virtual environment...${NC}"
    setup_virtualenv
    echo -e "${BLUE}Installing Python dependencies...${NC}"
    pip3.10 install -r requirements.txt pillow --quiet
else
    echo -e "${GREEN}Virtual environment already exists. Activating...${NC}"
    source venv/bin/activate
fi

# Run the bot
echo -e "${GREEN}Running the bot...${NC}"
python3.10 main.py

echo -e "${GREEN}Script execution completed!${NC}"
