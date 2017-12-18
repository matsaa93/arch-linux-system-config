#!/bin/zsh
## PATH set
## BASE DIR ARCH
echo "Initiate start.sh"
base=$(cd $(dirname "$0") && pwd)
export arch="$base"
## tmp/
export tmpdr="$arch/tmp"
[ -d $tmpdr ] || echo "missing dirrectory trying to create one" && mkdir -p $tmpdr
## bin/*
export arbin="$arch/bin"
## resources/*
botcfe="/boot/loader/entries"
resources="$arch/resources"
arzsh="$resources/etc/skel"
aretc="$resources/etc"
## rules.d
arudev="$aretc/udev/rules.d"
udev="/etc/udev/rules.d"
## pacman.conf Repo directory
pacc="$aretc/pacman.conf"
## cron
orgcrond="$resources/cron"
pacman_conf="/etc/pacman.conf"
### /boot
arboot="$resources/boot"
## #END PATH set
## Retreve messages
source $arbin/messages.sh
source $arbin/boot.sh
source $arbin/color-vars.sh
source $arbin/config-script.sh
source $arbin/desktop.sh
source $arbin/disk-config.sh
source $arbin/pacman.sh
source $arbin/zsh-install.sh
minlog() { x=$1 && print -P  "$menuvalid" && echo "Starting $0~: $1" >> $tmpdr/install.log }
inlog() { echo "Starting $0~: $1" >> $tmpdr/install.log }
utlog() { echo "Finished $0~: $1" >> $tmpdr/install.log }
main_menu() {
    PS3="$msgmain"
select main_menu_option in Config_menu Disk_menu Linux_menu Linux_Drivers_menu Pacman_menu
do
    clear
    x=$main_menu_option
    case $main_menu_option in
        exit) ;;
        *-*)
        minlog $main_menu_option
        $main_menu_option
        utlog $main_menu_option
        ;;
        *) ;;
    esac
done
}


echo "Finished start.sh"
