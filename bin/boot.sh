#!/bin/zsh
#
Boot_menu() {
    #
    # Boot_menu
    #
    PS3="$Boot_menu_message"

    select Boot_menu_options in Systemd_Bootloader_menu GRUB_Bootloader_menu back exit
    do
    #
    #
    Systemd_Bootloader_menu(){
        #
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
        MD_bootloader_write_entry() {
            echo "finalising writhing entries and loader.conf"
            [ -f /boot/loader/entries/arch.conf ] && echo "options root=PARTUUID=$partuid $optbt" >> $botcfe/arch.conf
            [ -f /boot/loader/entries/arch-bash.conf ] && echo "options root=PARTUUID=$partuid $optbt init=/bin/bash" >> $botcfe/arch-bash.conf
            [ -f /boot/loader/entries/arch-zsh.conf ] && echo "options root=PARTUUID=$partuid $optbt init/bin/zsh" >> $botcfe/arch-zsh.conf
        }

        loadmdedit() {
            echo "timeout 10" > /boot/loader/loader.conf
            echo "default $loadbt.conf" >> /boot/loader/loader.conf        
        }

        Systemd_bootloader_config() {
        if [ -f $botcfe/arch.conf ] && [ -f $botcfe/arch-bash.conf ] && [ -f $botcfe/arch-zsh.conf ]; then
            echo "all files are there"
        else
            PS3=" : INTEL or AMD / with sh or bash or zsh or all :
    : the last you select will be default-boot : "
            select p in intel intel_bash intel_zsh amd amd_bash amd_zsh next
            do
                case $p in
                    intel) cp -r $arboot/intelsh $botcfe/arch.conf && loadbt="arch" 
                    ;;
                    intel_bash) cp -r $arboot/intelbash $botcfe/arch-bash.conf && loadbt="arch-bash" 
                    ;;
                    intel_zsh) cp -r $arboot/intelzsh $botcfe/arch-zsh.conf && loadbt="arch-zsh" 
                    ;;
                    amd) cp -r $arboot/amdsh $botcfe/arch.conf && loadbt="arch" 
                    ;;
                    amd_bash) cp -r $arboot/amdbash $botcfe/arch-bash.conf && loadbt="arch-bash" 
                    ;;
                    amd_zsh) cp -r $arboot/amdzsh $botcfe/arch-zsh.conf && loadbt="arch-zsh" 
                    ;;
                    next) echo "continuing" && break 
                    ;;
                    *) echo "error" ;;
                esac
            done
            loadmdedit
            clear


            optbt="rw"
            PS3="$Kernel_Boot_option_message"
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
                    default) optbt="$optbt $defoptbt" && echo "$optbt is the options added to list" 
                    ;;
                    nvidia-drm) optbt="$optbt nvidia-drm.modeset=1" && echo "$optbt is the options added to list" 
                    ;;
                    costum) echo "default options are : $defoptbt : nvidia-drm add nvidia-drm.modeset=1"
                    echo "$optbt is the options alredy added to the list" && echo " : enter your options : "
                    read roptbt
                    optbt="$optbt $roptbt" 
                    ;;
                    btrfs-subvol) echo "enter the subvol that is the ROOT :" && read btsvol
                    optbt="$optbt rootflags=subvol=$btsvol"
                    ;;
                    set-root) echo "enter the name of your root partition" && echo "like sda2 or nvme0p2"
                    read rtfs
                    ;;
                    clear_options) print -P "$menuclear" && optbt="rw"
                    ;;
                    finish_write) MD_bootloader_write_entry && break ;;
                    back) Systemd_Bootloader_menu ;;
                    exit) menu_exit ;;
                    *) menu_invalid 9
                    ;;
                esac
            #echo "finalising writhing entries and loader.conf"
            done
        fi
        }
    
        ## Systemd boot_menu
            PS3="$Systemd_bootloader_menu_message"
                select MD_menu_options in mdbootloader_install Systemd_bootloader_config back exit
                do
                case_menu_boot $MD_menu_options Boot_menu
                done
    }
    GRUB_Bootloader_menu() {
        echo
            PS3="$GRUB_menu_message"
            select grub_options in set_efi_partition install config_defaut config_entry back exit
            do

                    case ${grub_options} in
                        set_efi_partition)
                        read esp_mount
                        ;;
                        install)
                        [ -d ${esp_mount} ] && grub-install --target=x86_64-efi --efi-directory=${esp_mount} --bootloader-id=grub || grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=grub
                        ;;
                        config_entry)
                        [ -d ${esp_mount} ] && grub-mkconfig -o /boot/grub/grub.cfg || grub-mkconfig -o /${esp_mount}/grub/grub.cfg
                        ;;
                        config_defaut)
                        vim /etc/default/grub
                        ;;
                        back)
                        Boot_menu
                        ;;
                        exit)
                        menu_exit
                        ;;
                        *) menu_invalid 6
                        ;;
                    esac
            done
    }
        local option_amount=4
        case_menu_boot $Boot_menu_options Linux_menu
    done    

}

Linux_menu() {
    PS3="$Linux_menu_message"
    select Linux_menu_options in AUR_Kernels Edit_Linux_menu Boot_menu back exit
    do
    AUR_Kernels() {
        Administrator_message="enter your Administrator password not root-pass if they are different~: "
        PS3="$AUR_Kernels_message"
        select AUR_Kernels_options in linux-rt linux-nvidia-rt linux-mainline linux-ck
            do
                clear
            case ${AUR_Kernels_options} in
                linux-rt) 
                    echo "$Administrator_message"
                    su -l admin -c 'yaourt -S linux-rt linux-rt-headers'
                    ;;
                linux-nvidia-rt) 
                    echo "$Administrator_message"
                    su -l admin -c 'yaourt -S linux-rt linux-rt-headers nvidia-rt'
                    ;;
                linux-mainline) 
                    echo "$Administrator_message"
                    su -l admin -c 'yaourt -S linux-mainline linux-mainline-headers'
                    ;;
                linux-ck) 
                    echo "$Administrator_message"
                    su -l admin -c 'yaourt -S linux-ck linux-ck-headers' ;;
                linux-nvidia-ck)
                    echo "$Administrator_message"
                    su -l admin -c 'yaourt -S linux-ck linux-ck-headers nvidia-ck'
                    ;;
                back) 
                    Linux_menu 
                    ;;
                exit) 
                    menu_exit
                    ;;
            esac
        done
    }
    #OFFI_kernels() {

    #}

    Edit_Linux_menu() {
        #
        #
        Set_Modules() {
            Buffer_Modules() {
                local x=$(echo $1 | cut -c 8-)
                Module_Buffer_list="$Module_Buffer_list ${x}"
                print -P "$CF[99] $x $Module_Active_message"
                print -P "$Module_ALL_Active_message"
            }

            Write_Modules() {
                echo "# MODULES ADDED by Arch linux System Config scripts" >> ${tmpdr}/mkinitcpio.conf
                echo "MODULES=\"$Module_Buffer_list\" #btrfs modules" >> ${tmpdr}/mkinitcpio.conf
            }
            Clear_Modules() { Module_Buffer_list="" }
            manual_add_Module() { echo "Enter your hooks here ~: " && read User_Input && Buffer_Modules ${User_Input} }
            #
            # module_menu
            #        
            PS3="$Module_menu_message"
            select Module_menu_options in Module_Nvidia Module_Nvidia_modeset Module_Nvidia_uvm Module_Nvidia_drm Module_ext4 Module_btrfs Module_nvme manual_add_Module Clear_Modules Write_Module back exit
            do
                local option_amount=12
                case_menu_boot $Module_menu_options Edit_Linux_menu
            done
        }
        #
        #
        Set_Hooks() {
            Buffer_Hooks() {
                local x=$(echo $1 | cut -c 6-)
                Hooks_Buffer_list="$Hooks_Buffer_list ${x}"
                print -P "$CF[99] $x $hook_Active_message "
                print -P "$hook_ALL_Active_message"
            }
            Write_Hooks() {
            echo "# HOOKS ADDED by Arch Linux System Config scripts" >> ${tmpdr}/mkinitcpio.conf
            echo "HOOKS=\"$Hooks_Buffer_list\" #btrfs modules" >> ${tmpdr}/mkinitcpio.conf
            }
            Clear_Hooks() { Hooks_Buffer_list="" }
            manual_add_Hooks() { echo "Enter your hooks here ~: " && read User_Input && Buffer_Hooks ${User_Input} }
            #
            # hook_menu
            #
            PS3="$Hook_menu_message"
            select hokcfg in  hook_base hook_udev hook_usr hook_systmd hook_filesystems hook_fsck hook_autodetect hook_btrfs hook_modconf hook_resume manual_add_Hooks Clear_Hooks Write_Hooks back exit
            do
                local option_amount=15
                case_menu_boot ${hokcfg} Edit_Linux_menu

            done
        }
        #
        #
        add_nvidia_pacman_hook() { cp -r ${aretc}/nvidia.hook /etc/pacman.d/hooks/nvidia.hook && print -P "$add_nvidia_pacman_hook_message" }
        remove_nvidia_pacman_hook() { rm /etc/pacman.d/hooks/nvidia.hook && print -P "$remove_nvidia_pacman_hook_message"  }
        normal_write_changes_mkinitcpio(){ cp -r ${tmpdr}/mkinitcpio.conf /etc/mkinitcpio.conf && Print -P "$write_mkinitcpio_message" }
        custom_write_changes_mkinitcpio(){ read User_Input && cp -r ${tmpdr}/mkinitcpio.conf /etc/mkinitcpio-${User_Input}.conf && Print -P "$write_mkinitcpio_message" }
        generate_linux_image_mkinitcpio(){ 
            PS3="$generate_linux_image_mkinitcpio_message"
            select mkinitgen in linux linux-rt linux-nvidia-rt linux-mainline linux-ck linux-nvidia-ck
            do
                mkinitcpio -p $mkinitgen && break
            done
        }
        #
        #
        [ -f ${tmpdr}/mkinitcpio.conf ] || cat ${aretc}/mkinitcpio.conf > ${tmpdr}/mkinitcpio.conf && echo "File made ready for configuration in ${tmpdr}"
        PS3="$edlinuxmsg"
        select edlinux in Set_Modules Set_Hooks add_nvidia_pacman_hook remove_nvidia_pacman_hook normal_write_changes_mkinitcpio custom_write_changes_mkinitcpio generate_linux_image_mkinitcpio back main_menu exit
        do
            local option_amount=10
            case_menu_boot $edlinux Linux_menu
            done
    }
    #
    # Linux_menu
    #
        local option_amount=4
        case_menu_boot $Linux_menu_options main_menu
     
    done
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
menu_exit() {
    local x=$1
    print -P "$menu_exit_msg"
    exit 0
}



case_menu_boot(){
    local menuoption=$1; local preview_menu=$2
    # local option_amount=$2; local name=$3; local sublevel=$4 #menu level amnount of times to break to main menu
        case ${menuoption} in
            Module_*)
            Buffer_Modules ${menuoption}
            ;;
            hook_*)
            Buffer_Hooks ${menuoption}
            ;;
            back)
            $preview_menu
            ;;
            main_menu)
            main_menu
            ;;
            exit)
            exit 0
            ;;
            *_*)
                menu_valid ${menuoption}
            ;;
            *-*)
                menu_valid ${menuoption}
            ;;
            *)
            menu_invalid ${option_amount}
            ;;

        esac
}
