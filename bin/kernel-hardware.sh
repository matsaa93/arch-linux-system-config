#!/bin/zsh

Kernels_Hardware_menu() {
    Linux_Drivers_menu(){
        Graphical_Drivers_menu() {
            OPENSOURCE_Driver_menu() {
                echo lol
             }
            NVIDIA_Geforce_Driver_menu() {
                Nvidia_Geforce_Packages() {
                    #
                    # Nvidia_Geforce_Packages
                    #
                    # TODO:_add Nvidia_Geforce_Packages_messge to message.sh
                    # nvidia - NVIDIA drivers for linux
                    # nvidia-lts - NVIDIA drivers for linux-lts
                    # nvidia-dkms - NVIDIA driver sources for linux
                    # nvidia-utils - NVIDIA drivers utilities
                    # lib32-nvidia-utils - NVIDIA drivers utilities (32-bit)
                    # opencl-nvidia - OpenCL implemention for NVIDIA
                    # lib32-opencl-nvidia - OpenCL implemention for NVIDIA (32-bit)
                    PS3="$Nvidia_Geforce_Packages_message"
                    select Nvidia_Geforce_Packages_options in nvidia nvidia-lts nvidia-dkms nvidia-utils lib32-nvidia-utils opencl-nvidia lib32-opencl-nvidia back exit
                    do
                        case_menu_hardware NVIDIA_Geforce_Drivers_menu PACKAGE_${Nvidia_Geforce_Packages_options}
                    done
                }
                Nvidia_Geforce_304xx_Packages() {
                    #
                    # Nvidia_Geforce_304xx_Packages
                    #
                    # TODO: add Nvidia_Geforce_304xx_Packages_messge to message.sh
                    # nvidia-304xx - NVIDIA drivers for linux, 304xx legacy branch
                    # nvidia-304xx-lts - NVIDIA drivers for linux-lts, 304xx legacy branch
                    # nvidia-304xx-dkms - NVIDIA driver sources for linux, 304xx legacy branch
                    # nvidia-304xx-utils - NVIDIA drivers utilities and libraries, 304xx legacy branch
                    # lib32-nvidia-304xx-utils - NVIDIA drivers utilities (32-bit)
                    # opencl-nvidia-304xx - OpenCL implemention for NVIDIA, 304xx legacy branch
                    # lib32-opencl-nvidia-304xx - OpenCL implemention for NVIDIA (32-bit)
                    PS3="$Nvidia_Geforce_304xx_Packages_message"
                    select Nvidia_Geforce_304xx_Packages_options in nvidia-304xx nvidia-304xx-lts nvidia-304xx-dkms nvidia-304xx-utils opencl-nvidia-304xx lib32-opencl-nvidia-304xx back exit
                    do
                        case_menu_hardware NVIDIA_Geforce_Drivers_menu PACKAGE_${Nvidia_Geforce_304xx_Packages_options}
                    done
                }
                Nvidia_Geforce_340xx_Packages() {
                    #
                    # Nvidia_Geforce_340xx_Packages
                    #
                    # TODO: add Nvidia_Geforce_340xx_Packages_messge to message.sh
                    # nvidia-340xx - NVIDIA drivers for linux, 340xx legacy branch
                    # nvidia-340xx-lts - NVIDIA drivers for linux-lts
                    # nvidia-340xx-dkms - NVIDIA driver sources for linux, 340xx legacy branch
                    # nvidia-340xx-utils - NVIDIA drivers utilities
                    # lib32-nvidia-340xx-utils - NVIDIA drivers utilities (32-bit)
                    # opencl-nvidia-340xx - OpenCL implemention for NVIDIA
                    # lib32-opencl-nvidia-340xx - OpenCL implemention for NVIDIA (32-bit)
                    PS3="$Nvidia_Geforce_340xx_Packages_message"
                    select Nvidia_Geforce_340xx_Packages_options in nvidia-340xx nvidia-340xx-lts nvidia-340xx-dkms nvidia-340xx-utils lib32-nvidia-340xx-utils opencl-nvidia-340xx lib32-opencl-nvidia-340xx back exit
                    do
                        case_menu_hardware NVIDIA_Geforce_Drivers_menu PACKAGE_${Nvidia_Geforce_340xx_Packages_options}
                    done
                }
                Nvidia_Geforce_Extra_Packages() {
                    #
                    # Nvidia_Geforce_Extra_Packages
                    #
                    # TODO: add Nvidia_Geforce_Extra_Packages_messge to message.sh
                    # 1. nvidia-settings - Tool for configuring the NVIDIA graphics driver
                    # 2. libvdpau - Nvidia VDPAU library
                    # 3. lib32-libvdpau - Nvidia VDPAU library
                    # 4. nvidia-cg-toolkit - NVIDIA Cg libraries
                    # 5. lib32-nvidia-cg-toolkit - NVIDIA Cg libraries
                    # 6. nvdock - A tray icon for easy launching of the NVIDIA control panel
                    # 7. libxnvctrl - NVIDIA NV-CONTROL X extension
                    # 8. bbswitch - Kernel module allowing to switch dedicated graphics card on Optimus laptops
                    # 9. nvidia-xrun - Script to run dedicated X server with discrete nvidia graphics
                    # 10. nvidia-xrun-git - Script to run dedicated X server with discrete nvidia graphics (git version)
                    # 11. bumblebee - NVIDIA Optimus support for Linux through VirtualGL
                    # 12. back - back to NVIDIA_Geforce_Drivers_menu
                    # 13. exit - Exit program
                    PS3="$Nvidia_Geforce_Extra_Packages_message"
                    select Nvidia_Geforce_Extra_Packages_options in nvidia-settings libvdpau lib32-libvdpau nvidia-cg-toolkit lib32-nvidia-cg-toolkit nvdock libxnvctrl bbswitch AUR_nvidia-xrun AUR_nvidia-xrun-git bumblebee back exit
                    do
                        case_menu_hardware NVIDIA_Geforce_Drivers_menu PACKAGE_${Nvidia_Geforce_Extra_Packages_options}
                    done
                }
                Nvidia_Geforce_Cuda_Packages() {
                    #
                    # Nvidia_Geforce_Cuda_Packages
                    #
                    # TODO: add Nvidia_Geforce_Cuda_Packages_messge to message.sh
                    # 1. cuda - NVIDIA's GPU programming toolkit
                    # 2. cudnn - NVIDIA CUDA Deep Neural Network library
                    # 3. pycuda-headers - Python wrapper for Nvidia CUDA
                    # 4. python2-pycuda - Python2 wrapper for Nvidia CUDA
                    # 5. python-pycuda - Python wrapper for Nvidia CUDA
                    # . back - back to NVIDIA_Geforce_Drivers_menu
                    # . exit - Exit program
                    PS3="$Nvidia_Geforce_Cuda_Packages_message"
                    select Nvidia_Geforce_Cuda_Packages_options in cuda cudnn pycuda-headers python2-pycuda python-pycuda back exit
                    do
                        case_menu_hardware NVIDIA_Geforce_Driver_menu Driver_${Nvidia_Geforce_Cuda_Packages_options}
                    done
                }
            #
            # NVIDIA_Geforce_Driver_menu
            # TODO: add the NVIDIA_Geforce_Driver_menu_message to message.sh
            # 1. Nvidia_Geforce_Packages - selection of nvidia driver packages
            # 2. Nvidia_Geforce_304xx_Packages - selection of nvidia-304xx driver packages
            # 3. Nvidia_Geforce_340xx_Packages - selection of nvidia-340xx driver packages
            # 4. Nvidia_Geforce_Extra_Packages - selection of nvidia extra packages
            # 5. Nvidia_Geforce_Cuda_Packages - selection of nvidia cuda packages
            # 6. back - back to Graphical_Drivers_menu
            # 7. exit - Exit program
                PS3="$NVIDIA_Geforce_Driver_menu_message"
                select NVIDIA_Geforce_Driver_menu_options in Nvidia_Geforce_Packages Nvidia_Geforce_304xx_Packages Nvidia_Geforce_340xx_Packages Nvidia_Geforce_Extra_Packages Nvidia_Geforce_Cuda_Packages back exit
                do
                    # case_menu_Software $NVIDIA_Geforce_Driver_menu_options Graphical_Drivers_menu
                    case_menu_hardware Graphical_Drivers_menu ${NVIDIA_Geforce_Driver_menu_options}
                done
            }
            AMD_Catalyst_Driver_menu(){
                    Catalyst_repo_menu(){
                    #
                    # Catalyst_repo_menu
                    # https://wiki.archlinux.org/index.php/AMD_Catalyst#Installing_from_the_unofficial_repository
                    # TODO: add the Catalyst_repo_menu_message to the massage.sh
                    # there is three different Catalyst repositories, maintain by Vi0L0, each having different drivers:
                    # 1. catalyst - for the regular Catalyst driver needed by Radeon HD 5xxx to Rx 300, it contains the latest beta release (Catalyst 15.12).
                    # 2. catalyst-stable - for the regular Catalyst driver needed by Radeon HD 5xxx to Rx 300, with the latest stable release (Catalyst 15.9).
                    # 3. catalyst-hd234k - for the legacy Catalyst driver needed by Radeon HD 2xxx, 3xxx and 4xxx cards (Catalyst 12.4).
                    # 4. KEYID_653C094 - adds key for the repository's
                    # 5. back - back to AMD_Catalys_Drivers_menu
                    # 6. exit - Exit program
                        PS3="${Catalyst_repo_menu_message}"
                        select Catalyst_repo_menu_options in REPO_catalyst REPO_catalyst-stable REPO_catalyst-hd234k KEYID_653C094 back exit
                        do
                            # case_menu_Software ${Catalyst_repo_menu_options} Graphical_Drivers_menu
                            case_menu_hardware AMD_Catalys_Drivers_menu ${Catalyst_repo_menu_options}
                        done
                    }

                    Catalyst_Driver_Packages(){
                    #
                    # Catalyst_Driver_Packages
                    # https://wiki.archlinux.org/index.php/AMD_Catalyst#Installing_the_driver
                    # TODO: add the Catalyst_Driver_Packages_message to the massage.sh
                    # 1. catalyst - AMD/ATI Catalyst drivers for linux. fglrx kernel module only. Radeons HD 2 3 4 xxx ARE NOT SUPPORTED
                    # 2. catalyst-test - AMD/ATI Catalyst drivers for linux AKA Crimson. catalyst-dkms + catalyst-utils + lib32-catalyst-utils + experimental powerXpress suppport. PRE-GCN Radeons are optionally supported 	Vi0L0
                    # 3. catalyst-total - AMD/ATI Catalyst drivers for linux. catalyst-dkms + catalyst-utils + lib32-catalyst-utils + experimental powerXpress suppport. Radeons HD 2 3 4 xxx ARE NOT SUPPORTED 	Vi0L0
                    # 4. catalyst-total-hd234k - AMD/ATI legacy drivers. catalyst-dkms+ catalyst-utils + lib32-catalyst-utils
                    # 5. catalyst-generator - AMD/ATI drivers. Generator of catalyst-{kernver} packages with fglrx module inside.
                    # 6. catalyst-hook - AMD/ATI drivers. Auto re-compile fglrx module while shutdown/reboot.
                    # 7. catalyst-dkms - AMD/ATI drivers AKA Crimson. Sources to build fglrx module on DKMS. 	Vi0L0
                    # 8. catalyst-firepro - AMD/ATI drivers for FirePro/GL/MV brand cards. catalyst-dkms + catalyst-utils + lib32-catalyst-utils + experimental powerXpress suppport. 	Vi0L0
                    # 9. catalyst-utils - AMD/ATI drivers. Utilities and libraries. Radeons HD 2 3 4 xxx ARE NOT SUPPORTED
                    # 10. catalyst-libgl - AMD/ATI drivers. Catalyst drivers libraries symlinks + experimental powerXpress support.
                    # 11. opencl-catalyst - optional, needed for OpenCL support
                    # 12. lib32-catalyst-utils - optional, needed for 32-bit OpenGL support on 64-bit systems
                    # 13. lib32-catalyst-libgl - optional, needed for 32-bit OpenGL support on 64-bit systems
                    # 14. lib32-opencl-catalyst - optional, needed for 32-bit OpenCL support on 64-bit systems
                    # 15. back - back to AMD_Catalys_Drivers_menu
                    # 16. exit - Exit program
                        PS3="$Catalyst_Driver_Packages_message"
                            select Catalyst_Driver_Packages_options in catalyst catalyst-test catalyst-total catalyst-total-hd234k catalyst-generator catalyst-hook catalyst-dkms catalyst-firepro catalyst-utils catalyst-libgl opencl-catalyst lib32-catalyst-utils lib32-catalyst-libgl lib32-opencl-catalyst back exit
                            do
                                # case_menu_Software ${Catalyst_repo_menu_options} Graphical_Drivers_menu
                                case_menu_hardware AMD_Catalys_Drivers_menu PACKAGE_${Catalyst_Driver_Packages_options}
                            done

                    }
            #
            # AMD_Catalyst_Driver_menu
            # https://wiki.archlinux.org/index.php/AMD_Catalyst
            # TODO: add the AMD_Catalyst_Driver_menu_message to the message.sh
                PS3="$AMD_Catalyst_Driver_menu_message"

                select AMD_Catalyst_Driver_menu_options in Catalyst_repo_menu Catalyst_Driver_Packages back exit
                    do
                        # case_menu_Software ${AMD_Catalyst_Driver_menu_options} Graphical_Drivers_menu
                        case_menu_hardware Graphical_Drivers_menu ${AMD_Catalyst_Driver_menu_options}
                    done
            }
        #
        # Graphical_Drivers_menu
        #
        #TODO: add the Graphical_menu_message to message.sh
            PS3="$Graphical_Drivers_menu_message"
            select Graphical_Drivers_menu_option in AMD_Catalyst_Driver_menu NVIDIA_Geforce_Driver_menu back exit
            do
                # case_menu_Software ${Graphical_Drivers_menu_option} Linux_Drivers_menu
                case_menu_hardware Linux_Drivers_menu ${Graphical_Drivers_menu_option}
            done
        }
        Audio_Drivers_menu() {
            Pulse_Audio_Packages_menu() {
                #
                # Pulse_Audio_Packages_menu
                # https://wiki.archlinux.org/index.php/PulseAudio
                # TODO: add the Pulse_Audio_Packages_menu_message to message.sh
                # 1. pulseaudio - A featureful, general-purpose sound server
                # 2. pulseaudio-alsa - ALSA Configuration for PulseAudio
                # 3. pulseaudio-bluetooth - Bluetooth support for PulseAudio
                # 4. pulseaudio-equalizer - Equalizer for PulseAudio
                # 5. pulseaudio-gconf - GConf support for PulseAudio
                # 6. pulseaudio-jack - Jack support for PulseAudio
                # 7. pulseaudio-lirc - IR (lirc) support for PulseAudio
                # 8. pulseaudio-zeroconf - Zeroconf support for PulseAudio
                # 9. libpulse - A featureful, general-purpose sound server (client library)
                # 10. lib32-libpulse - A featureful, general-purpose sound server (32-bit client libraries)
                # 11. libcanberra-pulse - PulseAudio plugin for libcanberra
                # 12. lib32-libcanberra-pulse - PulseAudio plugin for libcanberra (32-bit)
                # 13. pamixer - Pulseaudio command-line mixer like amixer
                # 14. paprefs - A simple GTK-based configuration dialog for PulseAudio
                # 15. pavucontrol - PulseAudio Volume Control
                # 16. pavucontrol-qt - A Pulseaudio mixer in Qt (port of pavucontrol)
                # 17. plasma-pa - Plasma applet for audio volume management using PulseAudio
                # 18. ponymix - CLI PulseAudio Volume Control 	2016-06-07
                # 19. projectm-pulseaudio - ProjectM support for Pulseaudio
                # 20. back  - Back to Audio_Drivers_menu
                # 21. exit - Exit program

                PS3="$Pulse_Audio_Packages_message"
                select Pulse_Audio_Packages_options in pulseaudio pulseaudio-alsa pulseaudio-bluetooth pulseaudio-equalizer pulseaudio-gconf pulseaudio-jack pulseaudio-lirc pulseaudio-zeroconf libpulse lib32-libpulse libcanberra-pulse lib32-libcanberra-pulse pamixer paprefs pavucontrol pavucontrol-qt plasma-pa ponymix projectm-pulseaudio back exit
                do
                    case_menu_hardware Audio_Driver_menu Driver_${Pulse_Audio_Packages_option}
                done
            }
            JACK_Kit_menu() {
            #
            # JACK_KIT_menu
            # https://wiki.archlinux.org/index.php/JACK_Audio_Connection_Kit
            # TODO: add the JACK2_Kit_menu_message to message.sh
            # 1. jack - A low-latency audio server
            # 2. jack2 - The next-generation JACK with SMP support
            # 3. lib32-jack2 - The next-generation JACK with SMP support (32 bit)
            # 4. jack2-dbus - The next-generation JACK with SMP support (for D-BUS interaction only)
            # 5. back  - Back to Audio_Drivers_menu
            # 6. exit - Exit program

                PS3="$JACK2_Kit_menu_message"
                    select JACK2_Kit_menu_options in jack lib32-jack jack2 lib32-jack2 jack2-dbus back exit
                    do
                        # case_menu_Software PACKAGE_${JACK2_Kit_menu_options} Audio_Drivers_menu
                        case_menu_hardware Audio_Drivers_menu PACKAGE_${JACK2_Kit_menu_options}
                    done

            }
            ALSA_Driver_menu() {
            #
            ### ALSA DRIVER & LIBs
            # https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture
            # TODO: add the ALSA_Driver_menu_message to message.sh
            # 1. alsa-firmware - ALSA firmware package
            # 2. alsa-lib - An alternative implementation of Linux sound support
            # 3. alsa-oss - OSS compatibility library
            # 4. alsa-plugins - Extra alsa plugins
            # 5. alsa-tools - Advanced tools for certain sound cards
            # 6. alsa-utils - An alternative implementation of Linux sound support
            # 7. clalsadrv - C++ wrapper around the ALSA API
            # 8. lib32-alsa-oss - OSS compatibility library (32 bit)
            # 9. lib32-alsa-plugins - Extra alsa plugins (32-bit)
            # 10. lib32-alsa-lib - An alternative implementation of Linux sound support (32 bit)
            # 11. back  - Back to Audio_Drivers_menu
            # 12. exit - Exit program

                PS3="$ALSA_Driver_menu_message"
                select ALSA_Driver_menu_options in alsa-firmware alsa-lib alsa-oss alsa-plugins alsa-tools alsa-utils clalsadrv lib32-alsa-oss lib32-alsa-plugins lib32-alsa-lib back exit
                do
                    # case_menu_Software PACKAGE_${ALSA_Driver_menu_options} Audio_Drivers_menu
                    case_menu_hardware Audio_Drivers_menu PACKAGE_${ALSA_Driver_menu_options}

                done
            }
        #
        # Audio_Drivers_menu
        # https://wiki.archlinux.org/index.php/Sound_system
        # TODO: add the Audio_Drivers_menu_message to message.sh
            PS3="$Audio_Drivers_menu_message"
            select Audio_Drivers_menu_option in ALSA_Driver_menu JACK_Kit_menu Pulse_Audio_Packages back exit
            do
                case_menu_hardware Linux_Drivers_menu ${Audio_Drivers_menu_option}
                #case_menu_Software ${Audio_Drivers_menu_option} Linux_Drivers_menu
            done
        }
        #
        # Linux_Drivers_menu
        #
        # TODO: add Linux_Driver_menu_message to message.sh
        PS3="$Linux_Drivers_menu_message"
        select Linux_Drivers_menu_option in Audio_Drivers_menu Graphical_Drivers_menu Install_Selected_Packages AUR_Install_Selected_Packages back exit
        do
            case_menu_hardware Kernels_Hardware_menu ${Linux_Drivers_menu_option}
            # case_menu_Software ${Linux_Drivers_menu_option} Kernels_Hardware_menu
        done
    }
    Microcode_Firmware_menu(){
        #
        # Microcode_Firmware_menu
        #
        # TODO: add message for Microcode_Firmware_menu
        #  1:intel-ucode        For Intel prosessors further configuration is needed in the bootloader to
        #   :                   enable microcode see options for microcode during installation of the bootloader,
        #   :                   if the bootloader is grub there will be no option as it does it for you.
        #
        #  2:linux-firmware     For AMD processors the microcode updates are available in linux-firmware,
        #   :                   which is installed as part of the base system. No further action is needed.
        #   :
        PS3=${Microcode_Firmware_message}
        select Microcode_Firmware_options in intel-ucode linux-firmware back exit
        do
            case_menu_hardware Kernels_Hardware_menu PACKAGE_${Microcode_Firmware_options}
        done
    }
    Linux_Kernels_menu() {
        # TODO: fix nvidia{-rt&-ck} and add driver menu under linux menu!!
        AUR_Kernels() {
            #AUR_Kernels_install(){
            #local x=$(echo $1 | cut -c 6-)
            #print -P "$CF[99] $Administrator_message $CF[256]"
            #su -l admin -c "yaourt -S $x $x-headers"
            #}
            Administrator_message="enter your Administrator password not root-pass if they are different~: "
            PS3="$AUR_Kernels_message"
            select AUR_Kernels_options in linux-rt linux-rt-headers linux-mainline linux-mainline-headers linux-ck linux-ck-headers back exit
                do
                # case_menu_boot AURK_${AUR_Kernels_options} Linux_menu
                case_menu_hardware Linux_Kernels_menu PACKAGE_AUR_${AUR_Kernels_options}
            done
        }

        OFFICIAL_Kernels() {
            #
            #   OFFICIAL_kernels
            #
            #   TODO: add OFFICIAL_Kernels_message to message.sh
            #   TODO: add OFFICIAL_Kernels_options to select function
            PS3="$OFFICIAL_Kernels_message"
            select OFFICIAL_Kernels_options in values back exit
            do
                # case_menu_boot AURK_PACKAGE_${OFFICIAL_Kernels_options} Linux_menu
                case_menu_hardware Linux_Kernels_menu PACKAGE_${OFFICIAL_Kernels_options}
            done
        }
        #
        # Linux_Kernels_menu
        #

        PS3="$Linux_Kernels_menu_message"
        select Linux_Kernels_menu_options in OFFICIAL_Kernels AUR_Kernels back exit
        do
            # case_menu_boot AURK_PACKAGE_${OFFICIAL_Kernels_options} Linux_menu
            case_menu_hardware Kernels_Hardware_menu ${Linux_Kernels_menu_options}
        done
    }
    # Kernels_Hardware_menu
    #
    # TODO: add multimedia_menu
    # TODO: add software menu function
        PS3="$Software_menu_message"
            select Software_menu_options in values back exit
            do
                case_menu_hardware main_menu ${Software_menu_options}
            done

}

 
Buffer_Packages_list() {
    #
    # Buffer_Packages_list
    # TODO: add the Packages_Active_message & Packages_ALL_Active_message & AUR_Packages_Active_message & AUR_Packages_ALL_Active_message to message.sh
    #
    local x=$2; local pre_menu=$1
    for x in $2 ;do
        case $x in
            AUR_*)
                local y=$(echo ${x} | cut -c 5-)
                AUR_Packages_Buffer_list="${AUR_Packages_Buffer_list} ${y}"
                print -P "$CF[99] ${x} ${AUR_Packages_Active_message}"
                    print -P "${AUR_Packages_ALL_Active_message}"
            ;;
            back)
                menu_back ${pre_menu}
            ;;
            exit)
                exit 0
            ;;
            *)
                Packages_Buffer_list="${Packages_Buffer_list} ${x}"
                print -P "$CF[99] ${x} ${Packages_Active_message}"
                print -P "${Packages_ALL_Active_message}"
            ;;
        esac
    done
}

Install_Selected_Packages() {
    # TODO: add Install_Selected_Packages_message to message.sh
    print -P "${Install_Selected_Packages_message}"
    pacman -S ${Packages_Buffer_list}
    Packages_Buffer_list=""
}
AUR_Install_Selected_Packages() {
    # TODO: add AUR_Install_Selected_Packages_message to message.sh
    print -P "${AUR_Install_Selected_Packages_message}"
    print -P "$CF[99] ${Administrator_message} $CF[256]"
    su -l admin -c "yaourt -S ${AUR_Packages_Buffer_list}"
    AUR_Packages_Buffer_list=""
}
Repo_install() {
    local repo=$1
    print -P "$CF[99] adding $repo as a new repo $CF[256]"
    cat $pacc/$repo.repo >> ${pacman_conf}
    pacman -Syy

}
Repo_keyid_add() {
    local keyid=$1
    pacman-key -r ${keyid}
    pacman-key -f ${keyid}
    pacman-key --lsign-key ${keyid}
}
case_menu_hardware() {
    #local menuoption=$1; local preview_menu=$2
    # local option_amount=$2; local name=$3; local sublevel=$4 #menu level amnount of times to break to main menu
    preview_menu=$1 ;local menuoption=$2; local case_buffer
    # for menuoption in $menuoption_list; do
        case ${menuoption} in
            PACKAGE_*)
            case_buffer=$(echo ${menuoption} | cut -c 9-) && Buffer_Packages_list ${preview_menu} ${case_buffer}
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

