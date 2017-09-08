#!/bin/zsh
# messages for menus and more
clps=%F{202}
lbcl[1]="\e[1;44m;95m" # magenta-fg blue-bg
 lbcl[2]="\e[1;104;95m" # magenta-fg light-blue-bg
 lbcl[3]="\e[0m"      # reset color
 lbcl[4]="\e[1;41;93m"  # yellow-fg red-bg
 lbcl[5]="\e[1;102;94m"
export msgmain="
                             ######## MAIN MENU #########
     ######################### Arch-Linux-System-Config ######################
     #                       ######### Scripts ##########
     # this is a collection of script ment to help with arch-linux install.
     ##%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%##%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#%#
 Options Description;
     # Config-menu  : Brings you to the menu for essential configuration.
     # Disk-menu    : Brings you to the menu for disk configuration.
     #                 : manly intended for SSD's but has some for HDD 
     # Pacman-menu  : Brings you to the menu for software install
     #                 : has a collection of software and some essentials
     # Desktop-menu : Brings you to the menu for installing Xorg and Wayland,
     #                 : and the desired Desktop Enviroment.
     # Boot-menu    : brings you to the menu for BootLoader install 
     #                 : and kernel options & modules
     ##################:
     : Enter The Option You Want {1..14} And Press <Enter> : 

"
     # Boot-menu    : Installs the bootloader and configures default boot option
     #              : the boot loader will be systemd-boot
 

export msgus="
                                               ###############
      ########################################## CONFIG MENU ##########################################
     #                                         ############### 
     # This is ment to be used to configure arhlinux and it's shell,
     # and adding the users & admins you want to add.
 Option Description;
     # Install_zsh     : install zsh & oh-my-zsh powerline and sets zsh as root-shell
     #                   : install powerline &-font and powerlevel9k theme
     #                   : configure zsh to use powerlevel9k and special font
     # Pw_root          : spesify root password
     # Add_hostmane    : adds hostname to system domain
     # Add_groups      : Adds standar & admin groups and sets their permissions
     # Add_admin       : Add's a admin user to system near root permission
     # Add_user        : Add's a standar user to system
     # Enable_services : Enables default to multi-user & services thru systemctl
     # Set_locale      : Sets the local time/location
     # Ssd_config      : Configures system RW-schedule and enables trim
     #                   : the schedule is set to deadline and trim is fstrim
     # Auto_aug         : is the auto config that runs: add_hostname : add_groups : add_admin : add_user
     # Auto_tmpfs       : is a auto matic config for mounting tmp files to tmpfs
     # Auto_config     : runs all the above options {but not enable_services as it may not work}
     ##################:
     : Enter The Option You Want {1..14} And Press <Enter> : "

### SECTION disk-config.sh 
export msgdmenu="                    ### DISK MENU ###
     # this is ment be used to configure Disks to prolong disk life-cycle.
     # this script should detect any mounted SSD's available on the system.
     # it has the ability to enable trim for active mount's if SSD's are detected.
 
 Option Description;
     # disk_check     : this checks if a disk is rotational or not and returns a list
     #                  : of SSD'd and non SSD's for future trim enabling.
     #
     # disk_schedule  : enable R/W $udev/schedule.rule {noop,deadline,cfg} for Disks
     #                  : this lets you chose between the 3 shedules available for SSD & HDD
     #                  : you will be able to have diffrent shedule for SSD or HDD
     #                  : Recommanded shedule for SSD in general is {deadline} but some use {noop}.
     #                  : Recommanded shedule for HDD in general is {cfg} but deadline works fine.
     #
     # fstri_mcro     : Fstrim by cron this enables TRIM thru a acron job that runs on a shedule
     #                  : that you will be prompted to set by default it is weekly.
     #                  : i recommand you to run disk_check before running fstrimcron as it will be
     #                  : more automatic but if you want to put in the mount mountpoint your self
     #                  : you are welcome to do sow by just running fsrim_cron and no disk_check
     #
     # fstrim_systemd : this will enable trim for supported filesystem weekly! tru systemd
     #                  : it should be able to detect any SSD's if the system has one mounted
     #                  : it should be smart about how it handles trim by not doing a TRIM operation
     #                  : when it is not needed even if the timer is up !! NEEDs Reboot to take effect !!
     #                  : !! Should not be enabled during install as it may not work !!
     #
     # auto_conf     : Is a auto function that runs all the abowe options in order and let you chose TRIM type
     ################:
     : Enter The Option You Want {1..7} And Press <Enter> : "





export sdmsg="
      $lbcl[1].__________________##$lbcl[2]: TEST DISK IF ROTATIONAL OR NOT :$lbcl[1]##__________________.$lbcl[3]
      $lbcl[1]:                                                                          :$lbcl[3]
      $lbcl[1]:  $lbcl[2]:'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]: this will check if the partition that is mounted is an SSD or not. :$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]: if a partition gets listed it will test for TRIM-Support,          :$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]: if TRIM is supported then it will be Enabled thru cron,            :$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]: you will be prompted to set it to daily, weekly or montly,         :$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]: I Recomand to do it weekly. anyway Happy Hacking!......~:          :$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:$lbcl[1]  :$lbcl[3]
      $lbcl[1]:__________________________________________________________________________:$lbcl[3]
      "
export crmsg1="
       $lbcl[1].----------------------------------------------------.$lbcl[3]
       $lbcl[1]:  $lbcl[2]:'''''''''''''''''''''''''''''''''''''''''''''':$lbcl[1]  :$lbcl[3]
       $lbcl[1]:  $lbcl[2]: fstrim-cron timer set to default $lbcl[4]: $crms :$lbcl[2] :$lbcl[1]  :$lbcl[3]
       $lbcl[1]:  $lbcl[2]:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:$lbcl[1]  :$lbcl[3]
       $lbcl[1]:____________________________________________________:$lbcl[3]
 "
export crmsg2="
  ############################################################################
  #  I recommand you 'weekly' to prevent performance drop by a unnessesery
  #  TRIM operation only do daily if needed mainly for servers or systems
  #  with high R/W pressure on drive{SSD/NVMe}
  #  file lacations:
  #  daily=$daily | weekly=$weekly | monthly=$monthly
  #  default is weekly
  #  select your prefered cron shecduled timer for fstrim valid input {1..3} : "

export fscrmsg1="
     ## FSTRIM BY CRON #######################
     # is a script that will run as a cron job##
     # and enables trim for SSD's on supported ##
     # File system or not it is kind of manual ###
     # it needs the partition mount point      ##
     # like /home, /ROOT, /etc....            ##
      ## END ##################################
"
export fscrmsg2="
     # enable trim chose where to enable it, it is on root by default
     # type inn partition path (where it is mounted) f.ex: mnt home media/data
     # if something seems off edit or disable /etc/cron.daily/trim-ssd.sh"

export editmsg="
   # file alredy present do you want to prossed with editing: #
   #   $shmsg: $fileut #
   ### please enter the correct number {yes 1..2 no} :"

### END SECTION disk-config.sh 

### SECTION desktop.sh
dtmsg="
     ### What Desktop Environment do you want ###
     ##  options;                              ##
     #          Deepin   : Lxde                 #
     #          Gnome    : Cinnamon             #
     #          Kde      : Sugar                #
     #          Xfce                            #
     ##                                        ##
     ###                                      ###
"


### END SECTION desktop.sh

### SECTION boot.sh
kbomsg="
    # : ############################### Kernel Boot Options #####################################
    # : enable kernel boot options/parameters for more info visit links below;                  #
    # : https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt              #
    # : https://wiki.archlinux.org/index.php/Kernel_parameters                                  #
    # : usefull links if costumasing the kernel parameters.                                     #
    # : enable default or enable nvidia.drm.modeset=1 or input other custom options for systemd.#
    # : ################################# : ########### : #######################################
    # : #-------------------------------# : ########### : #------------------------------#
    # : ################################# : Description : ################################
    # : if you enable nvidia.drm i recommand you to add                                  #
    # : MODULES+=\"nvidia nvidia_modeset nvidia_uvm nvidia_drm\" : to /etc/mkinitcpio.conf
    # : as it is stated at the Arch-Linux Wiki under                                     #
    # : https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting              #
    # : ################### : ############################################################
    # : #-----------------# : #-------------------------------------------------------- #
    # : valid inputs {1..3} : "

### END SECTION boot.sh

