#!/bin/zsh
echo "start pacman.sh"
#this is essential packages for arch linux install
Pm_i() { pacman -S $ins && clear }
Pm_u() { pacman -Syu && clear }
Pm_db() { pacman -Syy && clear }
Gb_mk() { grub-mkconfig -o /boot/grub/grub.cfg }

ins_repo() { ### REPOSETORY INSTALLL
    repos=$(ls $pacc)
    cd $pacc
    for r in $repos
    do
        cat $r >> /etc/pacman.conf
    done
    popd
    Pm_db
    #ins="archlinuxcn-keyring" && Pm_i
}
#
ins_intel() { ### INTEL MICROCODE
    echo "Intel Microcode"
    ins="intel-ucode" && Pm_i
}
#
ins_libreoffice() { ### Libre Office Liberate your Office ;P
    echo "Libre Office"
    ins="libreoffice-still" && Pm_i
}
#
ins_alsa() { ### ALSA DRIVER & LIBs
    echo "Alsa"
    ins="alsa-lib alsa-oss alsa-plugins alsa-tools alsa-utils jack2 jack2-dbus" && Pm_i
    echo "Alsa 32-bit-lib"
    ins="lib32-alsa-oss lib32-alsa-plugins lib32-alsa-lib" && Pm_i
}
#
ins_codecs() { ### MULTIMEDIA CODEC's
    echo "multimedia codec"
    ins="opus celt faac faad2 flac jasper lame a52dec libdca libdv libmpeg2 libmad libmpcdec opencore-amr schroedinger speex libtheora libvorbis libvpx wavpack x264 x265 xvidcore libfdk-aac" && Pm_i
    ins="exfat-utils fuse-exfat gst-libav libxv gstreamer0.10-plugins flashplugin libdvdcss libdvdread libdvdnav dvd+rw-tools dvdauthor dvgrab" && Pm_i
    ### XINE AND FFMPEG
    echo "xine ffmpeg"
    ins="xine xine-lib ffmpeg" && Pm_i
}
#### YAOURT (AUR)
ins_yaourt() { echo "yaourt" && ins="yaourt" && Pm_i }
#### VLC VideoLAN Media Player
ins_vlc() { echo "vlc" && ins="vlc" && Pm_i }
#### Pacman Gui Installer
ins_pacgui() { echo "pacman Gui" && ins="pamac-aur" && Pm_i }
#### ARCHIVING TOOLS
ins_archive() { echo "archiving" && ins="p7zip p7zip-plugins unrar tar rsync" && Pm_i }
#### Acess Control List
ins_acl() { echo "Access Control List" && ins="acl" &&  Pm_i }
#### Bluetooth
ins_bluez() {  echo "bluez" && ins="bluez bluez-utils" && Pm_i }
#
ins_mics() { echo "mics" && ins="lib32-libldap" && Pm_i }
##

ins_xyne() { echo "installing packages from xyne repo" && ins="powerpill repoman fehbg-mgr alsaequal-mgr xrandr-mgr" && Pm_i }

ins_readedid() { echo "installing read-edid" && ins="read-edid i2c-tools" && Pm_i }

#ins_name() { echo "lol" }
#### VIDEO SUOND SYSTEM
ins_soundvid() { echo "Sound & Video" && ins_alsa && ins_codecs && ins_vlc }
}
auto_pacman() {
    echo "Initiate AUTO FUNCTION pacman.sh"
    ins_repo
    ins_intel
    ins_bluez
    ins_acl
    ins_archive
    ins_soundvid
    ins_yaourt
    ins_pacgui
    ins_xyne
    ins_readedid
    echo "Finished AUTO FUNCTION pacman.sh"
}
pacmenu() {
    PS3="$pacmenumsg"
    select pcmenu in ins_repo ins_intel ins_bluez ins_acl ins_archive ins_yaourt ins_pacgui ins_xyne ins_readedid ins_soundvid auto_pacman back exit
    do
        case $pcmenu in
            back) echo "back to main menu" && break ;;
            exit) echo "Ok you want to exit Bye! then" && exit 0 ;;
            *_*) echo "you have chosen to install $pcmenu " && $pcmenu ;;
            *) echo "invalid option valid options are between { 1..13 }" ;;
        esac
    done
}
#for c in $@; do ins_$c; done
echo "pacman finished"
