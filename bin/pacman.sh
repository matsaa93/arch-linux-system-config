#!/bin/zsh
#this is essential packages for arch linux install
Pm_i() { pacman -S $ins && clear }
Pm_u() { pacman -Syu && clear }
Pm_db() { pacman -Syy && clear }
Gb_mk() { grub-mkconfig -o /boot/grub/grub.cfg }
ins_repo() { ### REPOSETORY INSTALLL
echo "#
[multilib]
include = /etc/pacman.d/mirrorlist
#
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/\$arch" >> /etc/pacman.conf
Pm_db
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
#
ins_yaourt() { ### YAOURT (AUR)
    echo "yaourt"
    ins="yaourt" && Pm_i
}
#
ins_vlc() { ### VLC VideoLAN Media Player
    echo "vlc"
    ins="vlc" && Pm_i
}
#
ins_soundvid() { ### VIDEO SUOND SYSTEM
     echo "Sound & Video"
     ins_alsa && ins_codecs && ins_vlc
}
#
ins_pacgui() { ### Pacman Gui Installer
    echo "pacman Gui"
    ins="pamac-aur" && Pm_i
}
#
ins_archive() { ### ARCHIVING TOOLS
    echo "archiving"
    ins="p7zip p7zip-plugins unrar tar rsync" && Pm_i
}
#
ins_acl() { ### Acess Control List
    echo "Access Control List"
    ins="acl" &&  pm_i
}
#
ins_bluez() { ### Bluetooth
    echo "bluez"
    ins="bluez bluez-utils" && pm_i
}
#
ins_mics() { ### OTHER MICS
    echo "mics"
    ins="lib32-libldap" && pm_i
}
##

for c in $@; do ins_$c; done
echo "pacman finished"
