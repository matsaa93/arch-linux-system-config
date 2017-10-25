#!/bin/zsh
#
mdbootloader_install() {
echo "initiating $0"
botcfe="/boot/loader/entries"
## initial install
if [ -f $botcfe/arch.conf ]; then
    echo "boot loader is alredy installed proseeding"
else
    echo " installing systemd-boot loader"
    bootctl install
fi
}
#
#bootedit function
bootmdedit() {
    echo "finalising writhing entries and loader.conf"
    [ -f /boot/loader/entries/arch.conf ] && echo "options root=PARTUUID=$partuid $optbt" >> $botcfe/arch.conf
    [ -f /boot/loader/entries/arch-bash.conf ] && echo "options root=PARTUUID=$partuid $optbt init=/bin/bash" >> $botcfe/arch-bash.conf
    [ -f /boot/loader/entries/arch-zsh.conf ] && echo "options root=PARTUUID=$partuid $optbt init/bin/zsh" >> $botcfe/arch-zsh.conf
}

loadmdedit() {
    echo "
    timeout 10
    default $loadbt.conf
    " > /boot/loader/loader.conf
}

config_entry() {
if [ -f $botcfe/arch.conf ] && [ -f $botcfe/arch-bash.conf ] && [ -f $botcfe/arch-zsh.conf ]; then
    echo "all files are there"
else
    PS3=" : INTEL or AMD / with sh or bash or zsh or all :
    : the last you select will be default-boot : "
    select p in intel intel_bash intel_zsh amd amd_bash amd_zsh next
    do
        case $p in
            intel) cp -r $arboot/intelsh $botcfe/arch.conf && loadbt="arch" ;;
                 intel_bash) cp -r $arboot/intelbash $botcfe/arch-bash.conf && loadbt="arch-bash" ;;
                      intel_zsh) cp -r $arboot/intelzsh $botcfe/arch-zsh.conf && loadbt="arch-zsh" ;;
            amd) cp -r $arboot/amdsh $botcfe/arch.conf && loadbt="arch" ;;
                amd_bash) cp -r $arboot/amdbash $botcfe/arch-bash.conf && loadbt="arch-bash" ;;
                    amd_zsh) cp -r $arboot/amdzsh $botcfe/arch-zsh.conf && loadbt="arch-zsh" ;;
                next) echo "continuing" && break ;;
            *) echo "error" ;;
        esac
    done
    loadmdedit
    clear


    optbt="rw"
    PS3="$kbomsg"
    #
    select option in set-root btrfs-subvol default nvidia-drm costum clear_options back exit
    do
        lsblk

        ## USER INPUT ROOT partition
        #read rtfs
        ##variable for PARTUUID
        partuid=$(blkid -s PARTUUID -o value /dev/$rtfs)
        defoptbt="quiet splash"
        case option in
            default) optbt="$optbt $defoptbt" && echo "$optbt is the options added to list" ;;
            nvidia-drm) optbt="$optbt nvidia-drm.modeset=1" && echo "$optbt is the options added to list" ;;
            costum) echo "default options are : $defoptbt : nvidia-drm add nvidia-drm.modeset=1"
                echo "$optbt is the options alredy added to the list" && echo " : enter your options : "
                read roptbt
                optbt="$optbt $roptbt" ;;
            btrfs-subvol) echo "enter the subvol that is the ROOT :" && read btsvol
            optbt="$optbt rootflags=subvol=$btsvol"
            ;;
            set-root) echo "enter the name of your root partition" && echo "like sda2 or nvme0p2"
             read rtfs
            ;;
            clear_options) print -P "$menuclear" && optbt="rw"
            ;;
            finish_write) bootmdedit && break ;;
            back) print -P "$menusbk" && break ;;
            exit) print -P "$menuex" && exit 0 ;;
            *) print -P "$menuinvalid { 1..9 } "
            ;;
        esac
    #echo "finalising writhing entries and loader.conf"
    done
fi
}

write_mods() {
   echo "# MODULES ADDED by Arch linux System Config scripts
   MODULES=\"$mkmodules\" #btrfs modules" >> $tmpdr/mkinitcpio.conf
}

set_mods() {
    #
    ## MODULES write to mkinitcpio.conf for linux image generation
    #
    ## modules for mkinitcpio.conf
    nvidiamod="nvidia nvidia_modeset nvidia_uvm nvidia_drm" && ext4mod="ext4" && btrfsmod="btrfs" && nvmemod="nvme"
    PS3="$modmsg"
    select modcfg in nvidia-drm ext4 btrfs nvme clear_options finish-write back exit
    do
    clear
        case $modcfg in
            nvidia-drm) mkmodules="$mkmodules $nvidiamod" && print -P "$CF[99] $nvidiamod $modsg1"
                print -P "$modmsg2" && sleep 1
                ;;
            ext4) mkmodules="$mkmodules $ext4mod" && print -P "$CF[99] $ext4mod $modsg1"
                print -P "$modmsg2" && sleep 1
                ;;
            btrfs) mkmodules="$mkmodules $btrfsmod" &&  print -P "$CF[99] $btrfsmod $modsg1"
                print -P "$modmsg2" && sleep 1
                ;;
            nvme) mkmodules="$mkmodules $nvmemod" && print -P "$CF[99] $nvmemod $modsg1"
                print -P "$modmsg2" && sleep 1
                ;;
            finish-write) print -P "$menunext" && write_mods
                break ;;
            clear_options) print -P "$menuclear" && mkmodules=""
                ;;
            back) print -P "$menusbk" && break ;;
            exit) print -P "$menuex" && exit 0 ;;
            *) print -P "$menuinvalid { 1..8 } "
                ;;
        esac
    done
}

write_hooks() {
echo "# HOOKS ADDED by Arch Linux System Config scripts
HOOKS=\"$mkhooks\" #btrfs modules" >> $tmpdr/mkinitcpio.conf
}

set_hooks() {
    ## hooks for mkinitcpio.conf
    defaulthooks="base udev usr systemd filesystems" && fsckhook="fsck" && detecthook="autodetect" && btrfshook="btrfs"
    modprobehook="modconf" && resumehook="resume"
    PS3="$hookmsg"
    select hokcfg in  defaults fsck modprobe btrfs resume autodetect clear_options finish-write back exit
    do
    clear
        case $hokcfg in
            defaults) mkhooks="$mkhooks $defaulthooks" && print -P "$CF[99] $defaulthooks $hookmsg1"
            print -P "$hookmsg2"
            ;;
            fsck) mkhooks="$mkhooks $fsckhook" && print -P "$CF[99] $fsckhook $hookmsg1"
            print -P "$hookmsg2"
            ;;
            btrfs) mkhooks="$mkhooks $btrfshook" && print -P "$CF[99] $btrfshook $hookmsg1"
            print -P "$hookmsg2"
            ;;
            resume) mkhooks="$mkhooks $resumehook" && print -P "$CF[99] $resumehook $hookmsg1"
            print -P "$hookmsg2"
            ;;
            autodetect) mkhooks="$mkhooks $detecthook" && print -P "$CF[99] $detecthook $hookmsg1"
            print -P "$hookmsg2"
            ;;
            modprobe) mkhooks="$mkhooks $modprobehook" && print -P "$CF[99] $modprobehook $hookmsg1"
            print -P "$hookmsg2"
            ;;
            finish-write) print -P "$menunext" && write_hooks
            break ;;
            clear_options) print -P "$menuclear" && mkhooks=""
            ;;
            back) print -P "$menusbk" && break ;;
            exit) print -P "$menuex" && exit 0 ;;
            *) print -P "$menuinvalid { 1..10 } "
            ;;
        esac
    done
}

AUR-kernels() {
# wget https://aur.archlinux.org/packages/linux-rt/
# echo "rederecting to kernel.sh"
adminmsg="enter your Administrator password not root-pass if they are different~: "
PS3="$aurkmsg"
select kertype in linux-rt linux-nvidia-rt linux-mainline linux-ck
    do
    clear
        case $kertype in
        linux-rt) echo "$adminmsg"
            su -l admin -c 'yaourt -S linux-rt linux-rt-headers'
            ;;
        linux-nvidia-rt) echo "$adminmsg"
            su -l admin -c 'yaourt -S linux-rt linux-rt-headers nvidia-rt'
            ;;
        linux-mainline) echo "$adminmsg"
            su -l admin -c 'yaourt -S linux-mainline linux-mainline-headers'
            ;;
        linux-ck) echo "$adminmsg"
            su -l admin -c 'yaourt -S linux-ck linux-ck-headers' ;;
        linux-nvidia-ck)echo "$adminmsg"
            su -l admin -c 'yaourt -S linux-ck linux-ck-headers nvidia-ck'
            ;;
            back) print -P "$menusbk" && break ;;
            exit) print -P "$menuex" && exit 0 ;;
        esac
    done
}
#OFFI_kernels() {

#}

edit-linux-menu() {
    #
    #
    #
    [ -f $tmpdr/mkinitcpio.conf ] || cat $aretc/mkinitcpio.conf > $tmpdr/mkinitcpio.conf && echo "File made ready for configuration in $tmpdr"
    PS3="$edlinuxmsg"
    select edlinux in add_modules add_hooks add_nvidia-pacman-hook remove_nvidia-pacman-hook normal-write-changes custom-write-changes generate-linux-image back back-main exit
    do
    clear

    case $edlinux in
        add_modules)
        set_mods
        ;;
        add_hooks)
        set_hooks
        ;;
        add_nvidia-pacman-hook)
        cp -r $aretc/nvidia.hook /etc/pacman.d/hooks/nvidia.hook
        echo "pacman hook added now the kernel will update/generate every time a nvidia update is done"
        ;;
        remove_nvidia-pacman-hook)
        rm /etc/pacman.d/hooks/nvidia.hook
        echo "pacman hook is now removed from /etc/pacman.d/hooks/nvidia.hook" ;;
        normal-write-changes)
        cp -r $tmpdr/mkinitcpio.conf /etc/mkinitcpio.conf
        ;;
        custom-write-changes)
        echo "not active yet"
        ;;
        generate-linux-image)
        PS3="select a image that you whant to generate"
        select mkinitgen in linux linux-rt linux-nvidia-rt linux-mainline linux-ck linux-nvidia-ck
        do
        mkinitcpio -p $mkinitgen && break
        done
        ;;
        back)
        print -P $menusbk && break
        ;;
        back-main)
        print -P $menubk && break 2
        ;;
        exit) print -P "$menuex" && exit 0 ;;
        *) print -P "$menuinvalid { 1.. }" ;;

    esac
    done
}
bootLoader-menu() {
    PS3="$bootloader_menu_msg"


}

menu_valid() {
    local x=$1
    print -P "$menu_valid_msg" && $x
}
menu_invalid() {
    local x=$1
    print -P "$menu_invalid_msg {1...$x}"
}
menu_back() {
    local x=$1
    print -P "$menu_back_msg $x"
    break
}
menu_back-main() {
    local x=$1; local y=$2
    print -P "$main_back_msg"
    break $y
}
menu_exit() {
    local x=$1
    print -P "$menu_exit_msg"
    exit 0
}

boot_menu() {
    PS3="$boot_menu_message"
    select boot_menu_options in values back-main exit
    do
        clear
        case $boot_menu_options in
            value)
                menu_valid $boot_menu_options
            ;;
            back-main)
                menu_back-main "boot_menu" 1
            ;;
            *_*)
                menu_valid $boot_menu_options
            ;;
            *-*)
                menu_valid $boot_menu_options
            ;;
            *)
                menu_invalid 6
            ;;
            exit)
                menu_exit
            ;;
        esac
    done
}
#echo "MODULES+=\"nvidia nvidia_modeset nvidia_uvm nvidia_drm\" #Nvivia modules" >> $tmpdr/mkinitcpio.conf
#echo "MODULES+=\"nvme\" #Nvme modules" >> $tmpdr/mkinitcpio.conf


