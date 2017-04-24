#!/bin/bash

####################################################################
# TigerOS Fedora Release Script                                    #
# @author: Patrick Kubiak                                          #
#                                                                  #
# Usage: sudo bash build.sh [RELEASE_VER] [BASE_ARCH] [BUILD_VER]  #
# Example: sudo bash build.sh 25 x86_64 1                          #
#                                                                  #
####################################################################

# Colors
green=`tput setaf 2`
red=`tput setaf 1`
reset=`tput sgr0`

# check arguments
if [ $# -ne 3 ]; then
    echo "Usage: sudo bash build.sh [RELEASE_VER] [BASE_ARCH] [BUILD_VER]"
    exit 1
fi

RELEASE_VER=$1
BASE_ARCH=$2
BUILD_VER=$3
MOCK_IMG=tigeros-$RELEASE_VER-$BASE_ARCH
TITLE=TigerOS-$RELEASE_VER-$BASE_ARCH

echo "${red}************************************${reset}"
echo "${green}   TigerOS Release Script!${reset}"
echo "${green}   Based on Fedora $RELEASE_VER $BASE_ARCH v$BUILD_VER${reset}"
echo "${red}************************************${reset}"
echo " "

# copy kickstart
echo "${green}Copying Kickstart...${reset}"
mock -r $MOCK_IMG --chroot "mkdir remix"
mock -r $MOCK_IMG --copyin tigeros.ks fedora-live-base.ks fedora-repo.ks fedora-repo-not-rawhide.ks boot.iso remix/

# flatten kickstart
echo "${green}Flattening kickstart...${reset}"
mock -r $MOCK_IMG --chroot --cwd=remix/ "ksflatten -v, --config tigeros.ks -o flat-tigeros.ks --version F$RELEASE_VER"

# make iso
echo "${green}Building iso...${reset}"
mock -r $MOCK_IMG --chroot --cwd=remix/ "livemedia-creator --ks flat-tigeros.ks --resultdir /var/lmc --project $TITLE-Live --iso=boot.iso --make-iso --volid $TITLE --iso-only --iso-name $TITLE-$BUILD_VER.iso --releasever $RELEASE_VER --title $TITLE --macboot"

# save iso
echo "${green}Saving iso...${reset}"
mock -r $MOCK_IMG --copyout /var/lmc/$TITLE-$BUILD_VER.iso $TITLE-$BUILD_VER.iso

# save log
echo "${green}Saving log...${reset}"
mock -r $MOCK_IMG --copyout /remix/virt-install.log virt-install.log

