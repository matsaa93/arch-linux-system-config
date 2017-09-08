#!/bin/zsh
## PATH set
## BASE DIR ARCH
echo "Initiate start.sh"
base=$(cd $(dirname "$0") && pwd)
export arch="$base"
## tmp/
export tmpdr="$arch/tmp"
mkdir $tmpdr
## bin/*
export arbin="$arch/bin"
## resources/*
export resources="$arch/resources"
export arzsh="$resources/etc/skel"
export aretc="$resources/etc"
## rules.d
export arudev="$aretc/udev/rules.d"
export udev="/etc/udev/rules.d"
## pacman.conf Repo directory
export pacc="$aretc/pacman.conf"
## cron
orgcrond="$resources/cron"

### /boot
export arboot="$resources/boot"
## #END PATH set
## Retreve messages
zsh $arbin/messages.smessages.sh

menu() {
    PS3="$msgmain"
select main in config-menu disk-menu boot-menu
do
    case main in
        exit) ;;
        config-menu) ;;
        disk-menu) ;;
        boot-menu) ;;
        *) ;;
    esac
done
}


echo "Finished start.sh"
