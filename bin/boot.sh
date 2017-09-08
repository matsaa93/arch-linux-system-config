#!/bin/zsh
#
echo "initiating $0"
botcfe="/boot/loader/entries"
## initial install
if [ -f $botcfe/arch.conf ]; then
    echo "boot loader is alredy installed proseeding"
else
    echo " installing systemd-boot loader"
    bootctl install
fi
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
    kbomsg="
                                                                                                      '/\'
                                                                                                     '//\\'
# : ############################### Kernel Boot Options ############################################'//-\`\\'
# : enable kernel boot options/parameters for more info visit links below;                  #      '//.o-\`\\'
# : https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt              #     '//.ooo+\`\\'
# : https://wiki.archlinux.org/index.php/Kernel_parameters                                  #    '//\`+oooo/\`\\'
# : usefull links if costumasing the kernel parameters.                                     #   '//\`+oooooo:\`\\'
# : enable default or enable nvidia.drm.modeset=1 or input other custom options for systemd.#  '//\`-+ooooooo:\`\\'
# : ################################# : ########### : ####################################### '//\`/:-:++oooo+:\`\\'
# : #-------------------------------# : ########### : #------------------------------#       '//\`/++++/+++++++:\`\\'
# : ################################# : Description : ################################      ',/\`/+++ooooooooooo/\`\,'
# : if you enable nvidia.drm i recommand you to add                                  #     '/\`/ooosssso++osssssso+\`\'
# : MODULES+=\"nvidia nvidia_modeset nvidia_uvm nvidia_drm\" : to /etc/mkinitcpio.conf      '/.oossssso-\`\`\`\`/ossssss+\`\'
# : as it is stated at the Arch-Linux Wiki under                                     #   '/-osssssso.      :ssssssso.\'
# : https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting              #  '/:osssssss/        osssso+++.\'
# : ################### : ############################################################'//osssssssss/        +sssssooo/-\'
# : #-----------------# : #-------------------------------------------------------- #'/\`/ossssso+/:-        -:/+osssso+-\`\
# : valid inputs {1..3} : "
    #
    PS3="$kbomsg"
    #
    select option in default nvidia-drm costum
    do
        lsblk
        echo "enter the name of your root partition"
        echo "like sda2 or nvme0p2"
        ## USER INPUT ROOT partition
        read rtfs
        ##variable for PARTUUID
        partuid=$(blkid -s PARTUUID -o value /dev/$rtfs)
        defoptbt="rw quiet splash"
        case option in
            default) optbt="$defoptbt" && bootmdedit && break ;;
            nvidia-drm) optbt="$defoptbt nvidia-drm.modeset=1" && bootmdedit && break ;;
            costum) echo "default options are : $defoptbt : nvidia-drm add nvidia-drm.modeset=1" echo " : enter your option : " && read optbt && bootmdedit && break ;;
            *) echo "invalid input please input a number between  {1..3} "
        esac
    #echo "finalising writhing entries and loader.conf"
    done
fi

echo "finished $0"
