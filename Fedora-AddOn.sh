#!/bin/bash
# NAME: FEDORA customization
# REPO URL: https://github.com/TheCoinWarrior/Linux.git
# !! Run this script as a ROOT user !!
#########################################################################################

# Set of Colors

BLUE="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m"
PURPLE="\033[0;35m"
RED='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'

# Logo
echo "


███████╗███████╗██████╗░░█████╗░██████╗░░█████╗░  ██╗░░░░░██╗███╗░░██╗██╗░░░██╗██╗░░██╗
██╔════╝██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗  ██║░░░░░██║████╗░██║██║░░░██║╚██╗██╔╝
█████╗░░█████╗░░██║░░██║██║░░██║██████╔╝███████║  ██║░░░░░██║██╔██╗██║██║░░░██║░╚███╔╝░
██╔══╝░░██╔══╝░░██║░░██║██║░░██║██╔══██╗██╔══██║  ██║░░░░░██║██║╚████║██║░░░██║░██╔██╗░
██║░░░░░███████╗██████╔╝╚█████╔╝██║░░██║██║░░██║  ███████╗██║██║░╚███║╚██████╔╝██╔╝╚██╗
╚═╝░░░░░╚══════╝╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝  ╚══════╝╚═╝╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝
================================================================================================
[+] Author: TheCoinWarrior
[+] Description: This script will install my addional custom tools and custom softare packages
[+] In no event shall the copyright holder be liable for any claim, damages or other liability
[+] These instructions are provided 'as is' without warranty of any kind    
-------------------------------------------------------------------------------------------------
[+] If You Know The Enemy and Know Yourself You Need Not Fear the Results of a Hundred Battles. 
[+] // Sun Tzu - Art of War //
"
# LOG FILE 
LOG="fedoracustom_install_`date +"%Y-%m-%d_%H-%M"`.log"

sleep 3
read -r -s -p $'Press escape to continue ... \n' -d $'\e'


# Only run as a root user
if [ "$(sudo id -u)" != "0" ]; then
    echo "This script may only be run as root or with user with sudo privileges."
    exit 1
fi


sleep 3

echo  -e "${YELLOW} Adding few lines into dnf.conf file  ..."
# Speed up DNF: /nano/dnf/dnf.conf 

echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
echo 'deltarpm=True' | sudo tee -a /etc/dnf/dnf.conf
echo 'defaultyes=True' | sudo tee -a /etc/dnf/dnf.conf
echo 'keepcache=True' | sudo tee -a /etc/dnf/dnf.conf

sleep 3

sudo dnf update -y 
sudo dnf upgrade --refresh  

# Enable RPM fussion : https://rpmfusion.org/Configuration

sudo dnf install https://rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm 
sudo dnf install https://rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 

sudo dnf update                     2>&1 >> "$LOG"
sudo dnf groupupdate core           2>&1 >> "$LOG"


# Isntall media codecs
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin 2>&1 >> "$LOG"
sudo dnf groupupdate sound-and-video    2>&1 >> "$LOG"

# Install additional software packages

Install_Custom_Packages(){
echo  -e "${RED} Updating System and Installing requirements ..."
clear
sudo dnf install python3 python3-pip wget git curl -y   2>&1 >> "$LOG"
sudo dnf install google-chrome-stable gimp -y   2>&1 >> "$LOG"
sudo dnf install gnome-tweak-tool -y    2>&1 >> "$LOG"
dnf install chrome-gnome-shell gnome-extensions-app -y  2>&1 >> "$LOG"
sudo dnf isntall dnfdragora -y  2>&1 >> "$LOG"
sudo dnf install bleachbit -y   2>&1 >> "$LOG"
sudo dnf copr enable dawid/better_fonts -y   2>&1 >> "$LOG"
sudo dnf install fontconfig-font-replacements -y    2>&1 >> "$LOG"
sudo dnf install fontconfig-enhanced-defaults -y    2>&1 >> "$LOG"
}   


# Install support for Flatpak
flatpak --version
sudo flatpak remote-add --if-not-exists flathub https://flathib.org/repo/flathub.flatpakrepo


## EOF
# Clear Cache
sudo dnf clean dbcache
sudo dnf clean all




