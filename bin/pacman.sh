#!/bin/zsh
echo "start pacman.sh"
#this is essential packages for arch linux install
Pm_i() { pacman -S $1 && clear }
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
ins_bluez() { echo "bluez" && ins="bluez bluez-utils" && Pm_i }
#
ins_mics() { echo "mics" && Pm_i "lib32-libldap" }
##

ins_xyne() { echo "installing packages from xyne repo" && Pm_i "powerpill repoman fehbg-mgr alsaequal-mgr xrandr-mgr" }

ins_readedid() { echo "installing read-edid" && Pm_i "read-edid i2c-tools" }

#ins_name() { echo "lol" }
#### VIDEO SUOND SYSTEM
ins_soundvid() { echo "Sound & Video" && ins_alsa && ins_codecs && ins_vlc }

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

ins_OhMyZsh() {
    echo "START $0"
echo "INSTALLING ZSH"
    Pm_i "zsh zsh-completions"
    chsh -s /usr/bin/zsh
    cp -aT /etc/skel/ /root/
    chmod 700 /root
    Pm_i "git wget"
echo "INSTALLING OH_MY_ZSH"
    #powerline powerline-fonts oh-my-zsh
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
echo "INSTALLING DEP POWERLINE "
    Pm_i "powerline powerline-fonts powerline-vim python-powerline"
    Pm_i "awesome-terminal-fonts"
    Pm_i "fontforge"
     git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
     git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "POWERLINE INSTALL DEP FINALIZED"
    # cp -r {.zshrc,.fonts,.oh-my-zsh} ~/
    cp -r $arzsh/power-themes ~/.oh-my-zsh/custom/themes/
    cp -r $arzsh/fontconfig ~/.config/
    # fc-cache -fv ~/.fonts
    cat $arzsh/.zshrc > ~/.zshrc
echo "OH-MY-ZSH INSTALL FINALIZED"
echo "INSTALLING VIM"
    Pm_i "vim vim-plugins"
    git clone https://github.com/amix/vimrc.git ~/.vim_runtime && sh ~/.vim_runtime/install_awesome_vimrc.sh
echo "VIM INSTALL FINALIZED"
echo "COPYING .zshrc,.oh-my-zsh,.vimrc,.vim_runtime to /etc/skel"
    cp -r ~/{.zshrc,.oh-my-zsh,.vimrc,.vim_runtime} /etc/skel/
    mkdir -p /etc/skel/.config
    cp -r $arzsh/fontconfig /etc/skel/.config/
echo "FINISHED copying all files"
echo "FINIDHED $0"
}

pacman_menu() {
    PS3="$pacmenumsg"
    select pcmenu in ins_OhMyZsh ins_repo ins_intel ins_bluez ins_acl ins_archive ins_yaourt ins_pacgui ins_xyne ins_readedid ins_soundvid auto_pacman back exit
    do
    clear
        case $pcmenu in
            back) echo "$menubk" && break ;;
            exit) echo "$menuex" && exit 0 ;;
            *_*)
            minlog $pcmenu
            echo "you have chosen to install $pcmenu " && $pcmenu
            ;;
            *) echo "$menuinvalid { 1..13 }" ;;
        esac
    done
}
#for c in $@; do ins_$c; done
echo "pacman finished"
