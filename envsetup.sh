#!/bin/bash

############################################################
# TigerOS Fedora Release Script                            #
# @author: Patrick Kubiak                                  #
#                                                          #
# Usage: sudo bash envsetup.sh [RELEASE_VER] [BASE_ARCH]   #
# Example: sudo bash envsetup.sh 25 x86_64                 #
#                                                          #
############################################################

# Colors
green=`tput setaf 2`
red=`tput setaf 1`
reset=`tput sgr0`

# check arguments
if [ $# -ne 2 ]; then
    echo "Usage: sudo bash envsetup.sh [RELEASE_VER] [BASE_ARCH]"
    exit 1
fi

RELEASE_VER=$1
BASE_ARCH=$2
MOCK_IMG=antuple-fedora-$RELEASE_VER-$BASE_ARCH

echo "${red}************************************${reset}"
echo "${green}   TigerOS Fedora Build Setup Script!${reset}"
echo "${red}************************************${reset}"
echo " "

# get fedora boot.iso
if [ ! -f boot.iso ]; then
    echo "${green}Getting fedora boot.iso...${reset}"
    wget https://download.fedoraproject.org/pub/fedora/linux/releases/$RELEASE_VER/Workstation/$BASE_ARCH/os/images/boot.iso
else
    echo "${green}Using existing fedora boot.iso...${reset}"
fi

# setup mock
echo "${green}Setting up mock...${reset}"
dnf install mock
cp $MOCK_IMG.cfg /etc/mock/
mock -r $MOCK_IMG --init
mock -r $MOCK_IMG --install lorax-lmc-novirt pykickstart qemu nosync wget

