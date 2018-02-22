#!/bin/zsh
#

Linux_menu() {
# TODO: Add options for microcode and cleanup bootloader configurations

    Boot_menu() {

        set_efi_partition() { read esp_mount }

        set-root() { echo "enter the name of your root partition" && echo "like sda2 or nvme0p2" && read Root_Filesystem }

        set_btrfs_subvol_root() { echo "enter the subvol that is the ROOT :" && read Btrfs_root_subvol && Kernel_Option_Buffer="$Kernel_Option_Buffer rootflags=subvol=$Btrfs_root_subvol" }


        Systemd_Bootloader_menu(){
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
                [ -f /boot/loader/entries/arch.conf ] && echo "options root=PARTUUID=$partuid $Kernel_Option_Buffer" >> $botcfe/arch.conf
                [ -f /boot/loader/entries/arch-bash.conf ] && echo "options root=PARTUUID=$partuid $Kernel_Option_Buffer init=/bin/bash" >> $botcfe/arch-bash.conf
                [ -f /boot/loader/entries/arch-zsh.conf ] && echo "options root=PARTUUID=$partuid $Kernel_Option_Buffer init/bin/zsh" >> $botcfe/arch-zsh.conf
            }

            loadmdedit() {
                echo "timeout 10" > /boot/loader/loader.conf
                echo "default ${loadbt}.conf" >> /boot/loader/loader.conf
            }

                Systemd_bootloader_config() {

                    Buffer_Kernel_option(){
                        local o=$1 ; local bkor=false ; echo "checking if the variable is alredy stored"
                        echo "the value you are adding is alredy in"; echo "adding Kernel Option: $o : to \$Kernel_Option_Buffer"
                        Kernel_Option_Buffer="${Kernel_Option_Buffer} $o"; echo "New values are now: $Kernel_Option_Buffer :"
                    }

                    Manual_add_kernel_boot_option(){
                        echo -n "Enter your option here: "; read Read_Kernel_Option_Buffer
                        echo "$Read_Kernel_Option_Buffer is the value you have entered" ; Buffer_Kernel_option  $Read_Kernel_Option_Buffer
                    }

                    if [ -f $botcfe/arch.conf ] && [ -f $botcfe/arch-bash.conf ] && [ -f $botcfe/arch-zsh.conf ]; then
                        echo "all files are there"
                    else
                        PS3="$Systemd_bootloader_config_message"
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




                        partuid=$(blkid -s PARTUUID -o value /dev/$Root_Filesystem)
                        PS3="$Kernel_Boot_option_message"
                        select Kernel_boot_option_menu in rw "nvidia-drm.modeset=1" "nvidia-drm.modeset=0" "rootflags=subvol=$Btrfs_root_subvol" quiet splash Manual_add_kernel_boot_option clear_options main_menu Linux_menu Boot_menu back exit
                        do
                            lsblk
                            if [ ${Kernel_boot_opton_menu} == "Manual_add_kernel_boot_option" ] || [ ${Kernel_boot_option_menu} == "clear_option_buffer" ] || [ $Kernel_boot_option_menu == "MD_bootloader_write_entry" ];then
                                ${Kernel_boot_option_menu}
                            elif [ ${Kernel_boot_opton_menu} == "back" ];then
                                Systemd_Bootloader_menu
                            elif [ ${Kernel_boot_opton_menu} == "exit" ];then
                                exit 0
                            else
                                for opt in ${Kernel_boot_option_menu};do { Buffer_Kernel_option $opt } done
                        fi
                        #[[ ${Kernel_boot_option_menu} == "MD_bootloader_write_entry" ] || [ ${Kernel_boot_option_menu} == "MD_bootloader_write_entry" ] || [ ${Kernel_boot_option_menu} =="MD_bootloader_write_entry" ]] &&  ${Kernel_boot_option_menu}
                        ## USER INPUT ROOT partition
                        #read Root_Filesystem
                        ##variable for PARTUUIDLinux_menu Boot_menu

                    #echo "finalising writhing entries and loader.conf"
                    done
                fi
            }
            #
        ## Systemd boot_menu
        PS3="$Systemd_bootloader_menu_message"
        select MD_menu_options in mdbootloader_install Systemd_bootloader_config back exit
        do
            # case_menu_boot $MD_menu_options Boot_menu
            case_menu_boot Boot_menu ${MD_menu_options}
        done
        }
        GRUB_Bootloader_menu() {
        #
        #
        #
        Grub_Install_EFI(){
            if [ -d ${esp_mount} ]; then grub-install --target=x86_64-efi --efi-directory=${esp_mount} --bootloader-id=grub
            elif [ -d /boot/efi ]; then grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
            elif [ -d /boot/EFI ]; then grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub
            else return 0; fi
        }

        Grub_Config_entry(){
            if [ -d ${esp_mount} ]; then grub-mkconfig -o /${esp_mount}/grub/grub.cfg
            elif [ -d /boot/grub ]; then grub-mkconfig -o /boot/grub/grub.cfg
            else return 0; fi
        }

        Grub_Config_default(){
        vim /etc/default/grub
        }
            PS3="${GRUB_menu_message}"
            select grub_options in set_efi_partition Grub_Install_EFI Grub_Config_default Grub_Config_entry main_menu Linux_menu back exit
            do
                # case_menu_boot ${grub_options} Boot_menu
                case_menu_boot Boot_menu ${grub_options}
            done
        }
        #
        # Boot_menu
        #
        PS3="$Boot_menu_message"
        #
        select Boot_menu_options in set-root set_btrfs_subvol_root set_efi_partition Systemd_Bootloader_menu GRUB_Bootloader_menu main_menu back exit
        do
            #
            #
            # case_menu_boot ${Boot_menu_options} Linux_menu
            case_menu_boot Linux_menu ${Boot_menu_options}
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
            select Module_menu_options in Module_Nvidia Module_Nvidia_modeset Module_Nvidia_uvm Module_Nvidia_drm Module_ext4 Module_btrfs Module_nvme Module_snd-seq-oss Module_snd-pcm-oss Module_snd-mixer-oss manual_add_Module Clear_Modules Write_Module back exit
            do
                # case_menu_boot ${Module_menu_options} Edit_Linux_menu
                case_menu_boot Edit_Linux_menu ${Module_menu_options}

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

                # case_menu_boot ${hokcfg} Edit_Linux_menu
                case_menu_boot Edit_Linux_menu ${hokcfg}
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
            #case_menu_boot ${edlinux} Linux_menu
            case_menu_boot Linux_menu ${edlinux}
        done
    }


    #
    # Linux_menu
    #
    PS3="$Linux_menu_message"
    select Linux_menu_options in Edit_Linux_menu Boot_menu back exit
    do
        # case_menu_boot $Linux_menu_options main_menu
        case_menu_boot main_menu ${Linux_menu_options}
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
    print -P "$menu_back_msg ${x}"
    ${x}
}
menu_exit() {
    local x=$1
    print -P "$menu_exit_msg"
    exit 0
}

case_menu_boot(){
    #local menuoption=$1; local preview_menu=$2
    # local option_amount=$2; local name=$3; local sublevel=$4 #menu level amnount of times to break to main menu
    preview_menu=$1 ;local menuoption=$2; local case_buffer
    # for menuoption in $menuoption_list; do
        case ${menuoption} in
            Module_*)
            #for bufmod in ${menuoption}; do
            Buffer_Modules ${menuoption}
            #done
            ;;
            hook_*)
            #for bufhok in ${menuoption}; do
            Buffer_Hooks ${menuoption}
            #done
            ;;
            AURK_*)
            AUR_Kernels_install ${menuoption}
            ;;
            PACKAGE_*)
            case_buffer=$(echo ${menuoption} | cut -c 9-) && Buffer_Packages_list ${case_buffer}
            ;;
            REPO_*)
            case_buffer=$(echo ${menuoption} | cut -c 6-) && Repo_install ${case_buffer}
            ;;
            KEYID_*)
            case_buffer=$(echo ${menuoption} | cut -c 7-) && Repo_keyid_add ${case_buffer}
            ;;
            back)
            menu_back ${preview_menu}
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
    # done
}
