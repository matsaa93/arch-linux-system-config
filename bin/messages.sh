#!/bin/zsh
# messages for menus and more
#clps=%F{202}
#lbcl[1]="\e[1;44m;95m" # magenta-fg blue-bg
# lbcl[2]="\e[1;104;95m" # magenta-fg light-blue-bg
# lbcl[3]="\e[0m"      # reset color
# lbcl[4]="\e[1;41;93m"  # yellow-fg red-bg
# lbcl[5]="\e[1;102;94m"
msgmain="
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
 

msgus="
     $CF[203]# : ######################################### : ########### : ############################################$CF[256]
     $CF[203]# : #---------------------------------------# :%B$CF[94] CONFIG MENU %b$CF[203]: #------------------------------------------#$CF[256]
     $CF[203]# : ######################################### : ########### : ############################################$CF[256]
     $CF[203]# : $CF[95]This is ment to be used to configure arhlinux and it's shell,                                        $CF[203]#$CF[256]
     $CF[203]# : $CF[96]and adding the users & admins you want to add.                                                       $CF[203]#$CF[256]
     $CF[203]# : ##################################### : ################## : #########################################$CF[256]
     $CF[203]# : #-----------------------------------# :%B$CF[97] Option Description %b$CF[203]: #---------------------------------------#$CF[256]
     $CF[203]# : ##################################### : ################## : #########################################$CF[256]
     $CF[203]# : $CF[129]Install_zsh     $CF[203]:$CF[98] install zsh & oh-my-zsh powerline and sets zsh as root-shell                       $CF[203]#$CF[256]
     $CF[203]# :                  :$CF[99] install powerline &-font and powerlevel9k theme                                   $CF[203]#$CF[256]
     $CF[203]# :                  :$CF[105] configure zsh to use powerlevel9k and special font                                $CF[203]#$CF[256]
     $CF[203]# : $CF[128]Pw_root          $CF[203]:$CF[104] spesify root password                                                             $CF[203]#$CF[256]
     $CF[203]# : $CF[127]Add_hostmane    $CF[203]:$CF[103] adds hostname to system domain                                                     $CF[203]#$CF[256]
     $CF[203]# : $CF[126]Add_groups      $CF[203]:$CF[102] Adds standar & admin groups and sets their permissions                             $CF[203]#$CF[256]
     $CF[203]# : $CF[125]Add_admin       $CF[203]:$CF[101] Add's a admin user to system near root permission                                  $CF[203]#$CF[256]
     $CF[203]# : $CF[124]Add_user        $CF[203]:$CF[100] Add's a standar user to system                                                     $CF[203]#$CF[256]
     $CF[203]# : $CF[130]Enable_services $CF[203]:$CF[94] Enables default to multi-user & services thru systemctl                            $CF[203]#$CF[256]
     $CF[203]# : $CF[131]Set_locale      $CF[203]:$CF[95] Sets the local time/location                                                       $CF[203]#$CF[256]
     $CF[203]# : $CF[132]Ssd_config      $CF[203]:$CF[96] Configures system RW-schedule and enables trim                                     $CF[203]#$CF[256]
     $CF[203]# :                  :$CF[97] the schedule is set to deadline and trim is fstrim                                $CF[203]#$CF[256]
     $CF[203]# : $CF[133]Auto_aug         $CF[203]:$CF[98] is the auto config that runs: add_hostname : add_groups : add_admin : add_user    $CF[203]#$CF[256]
     $CF[203]# : $CF[134]Auto_tmpfs       $CF[203]:$CF[99] is a auto matic config for mounting tmp files to tmpfs                            $CF[203]#$CF[256]
     $CF[203]# : $CF[135]Auto_config     $CF[203]:$CF[105] runs all the above options {but not enable_services as it may not work}            $CF[203]#$CF[256]
     $CF[203]# : ################################################### : ################################################$CF[256]
     $CF[203]# : #-------------------------------------------------# : #----------------------------------------------#$CF[256]
     $CF[203]# : %B$CF[82]Enter The Option You Want {1..14} And Press <Enter> %b$CF[203]: $CF[256]"

### SECTION disk-config.sh 
msgdmenu="
     $CF[203]# : ################################### : ########## : ################################################$CF[256]
     $CF[203]# : ################################### :%B$CF[105] DISK MENU %b$CF[203]: ################################################$CF[256]
     $CF[203]# : ################################### : ########## : ################################################$CF[256]
     $CF[203]# : $CF[94]this is ment be used to configure Disks to prolong disk life-cycle.                              $CF[203]#$CF[256]
    $CF[203] # : $CF[95]this script should detect any mounted SSD's available on the system.                             $CF[203]#$CF[256]
     $CF[203]# : $CF[96]it has the ability to enable trim for active mount's if SSD's are detected.                      $CF[203]#$CF[256]
     $CF[203]# : ############################## : ################## : ############################################$CF[256]
     $CF[203]# : #----------------------------# :%B$CF[105] Option Description %b$CF[203]: #------------------------------------------#$CF[256]
     $CF[203]# : ############################## : ################## : ############################################$CF[256]
     $CF[203]# : $CF[136]disk_check$CF[203]     :$CF[98] this checks if a disk is rotational or not and returns a list                   $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[99] of SSD'd and non SSD's for future trim enabling.                               $CF[203]#$CF[256]
     $CF[203]# : $CF[137]disk_schedule$CF[203]  :$CF[105] enable R/W $udev/schedule.rule {noop,deadline,cfg} for Disks                    $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[104] this lets you chose between the 3 schedules available for SSD & HDD            $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[103] you will be able to have different schedule for SSD or HDD                     $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[102] Recommended schedule for SSD in general is {deadline} but some use {noop}.     $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[101] Recommended schedule for HDD in general is {cfg} but deadline works fine.      $CF[203]#$CF[256]
     $CF[203]# : $CF[138]fstri_mcro$CF[203]     :$CF[100] Fstrim by cron this enables TRIM thru a acron job that runs on a shedule        $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[94] that you will be prompted to set by default it is weekly.                      $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[95] i recommend you to run disk_check before running fstrimcron as it will be      $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[96] more automatic but if you want to put in the mount mountpoint your self        $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[97] you are welcome to do sow by just running fsrim_cron and no disk_check         $CF[203]#$CF[256]
     $CF[203]# : $CF[139]fstrim_systemd$CF[203] :$CF[98] this will enable trim for supported filesystem weekly! tru systemd$CF[203]              #$CF[256]
     $CF[203]# :                 :$CF[99] it should be able to detect any SSD's if the system has one mounted            $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[105] it should be smart about how it handles trim by not doing a TRIM operation     $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[104] when it is not needed even if the timer is up !! NEEDs Reboot to take effect!! $CF[203]#$CF[256]
     $CF[203]# :                 :$CF[103] !! Should not be enabled during install as it may not work !!                  $CF[203]#$CF[256]
     $CF[203]# : $CF[140]auto_conf$CF[203]     :$CF[102] Is a auto function that runs all the abowe options in order              $CF[203]        #$CF[256]
     $CF[203]# :                 :$CF[101] and let you chose TRIM type                                                    $CF[203]#$CF[256]
     $CF[203]# : ################################################## : #############################################$CF[256]
     $CF[203]# : #------------------------------------------------# : #-------------------------------------------#$CF[256]
     $CF[203]# : %B$CF[82]Enter The Option You Want {1..7} And Press <Enter> %b$CF[203]: $CF[256]"


sdmsg="
      $CF[203].__________________##:$CF[105] TEST DISK IF ROTATIONAL OR NOT $CF[203]:##__________________.$CF[256]
      $CF[203]:                                                                          :$CF[256]
      $CF[203]:  :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':  :$CF[256]
      $CF[203]:  :$CF[111] this will check if the partition that is mounted is an SSD or not. $CF[203]:  :$CF[256]
      $CF[203]:  :$CF[111] if a partition gets listed it will test for TRIM-Support,          $CF[203]:  :$CF[256]
      $CF[203]:  :$CF[111] if TRIM is supported then it will be Enabled thru cron,            $CF[203]:  :$CF[256]
      $CF[203]:  :$CF[111] you will be prompted to set it to daily, weekly or monthly,         $CF[203]:  :$CF[256]
      $CF[203]:  :$CF[111] I Recommend to do it weekly. anyway Happy Hacking!......~:          $CF[203]:  :$CF[256]
      $CF[203]:  :,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:  :$CF[256]
      $CF[203]:__________________________________________________________________________:$CF[256]
      "
crmsg1="
       $CF[203].----------------------------------------------------.$CF[256]
       $CF[203]:  :'''''''''''''''''''''''''''''''''''''''''''''':$lbcl[1]  :$CF[256]
       $CF[203]:  :$CF[105] fstrim-cron timer set to default $CF[203]:$CF[198] $crms $CF[203]: : :$CF[256]
       $CF[203]:  :,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:$lbcl[1]  :$CF[256]
       $CF[203]:____________________________________________________:$CF[256]
 "
crmsg2="
  $CF[203]############################################################################
  $CF[203]#  $CF[111]I recommend you 'weekly' to prevent performance drop by a unnecessary
  $CF[203]#  $CF[111]TRIM operation only do daily if needed mainly for servers or systems
  $CF[203]#  $CF[111]with high R/W pressure on drive{SSD/NVMe}
  $CF[203]#  $CF[111]file locations:
  $CF[203]#  $CF[111]daily=$daily | weekly=$weekly | monthly=$monthly
  $CF[203]#  $CF[111]default is weekly
  $CF[203]#  $CF[111]select your prefered cron shecduled timer for fstrim valid input {1..3} : $CF[256]"

fscrmsg1="
     $CF[203]##%B$CF[105] FSTRIM BY CRON %b$CF[203]#######################$CF[256]
     $CF[203]#$CF[111] is a script that will run as a cron job##$CF[256]
     $CF[203]#$CF[111] and enables trim for SSD's on supported ##$CF[256]
     $CF[203]#$CF[111] File system or not it is kind of manual ###$CF[256]
     $CF[203]#$CF[111] it needs the partition mount point      ##$CF[256]
     $CF[203]#$CF[111] like /home, /ROOT, /etc....            ##$CF[256]
      $CF[203]#########################################$CF[256]
"
fscrmsg2="
     $CF[203]#######################%B$CF[105] FSTRIM CRON MOUNTPOINTS %b$CF[203]###########################$CF[256]
     $CF[203]#$CF[111] enable trim chose where to enable it, it is on root by default          $CF[203]#$CF[256]
     $CF[203]#$CF[111] type inn partition path (where it is mounted) f.ex: mnt home media/data $CF[203]#$CF[256]
     $CF[203]#$CF[111] if something seems off edit or disable /etc/cron.daily/trim-ssd.sh      $CF[203]#$CF[256]
     $CF[203]###########################################################################$CF[256]
     "
shedmsg="$CF[198]Select your prefered disk R/W Shedule for $shmsg :$CF[256]"

hddcmsg="%B$CF[198]Partition /dev/$sd $CF[203]is an Hard Disk Drive giving it a NO for TRIM check %b$CF[256]"
ssdcmsg="%B$CF[198]/dev/$sd is$CF[82] an Solid State Devicegiving it a OK for TRIM check %b$CF[256]"
editmsg="
   $CF[1]### %B$CF[1] Warning ! %b$CF[203]#############################################$CF[256]
   $CF[1]# $CF[105]file alredy present do you want to prossed with editing$CF[203]: #$CF[256]
   $CF[1]#  $CF[198] $shmsg$CF[203]:$CF[198] $fileut $CF[203]#$CF[256]
   $CF[1]### $CF[111]please enter the correct number {yes 1..2 no} $CF[203]:$CF[256]"

### END SECTION disk-config.sh 

### SECTION desktop.sh
dtmsg="
     $CF[203]###%B$CF[105] What Desktop Environment do you want %b$CF[203]###$CF[256]
     $CF[203]##  options;                              ##$CF[256]
     $CF[203]#          Deepin   : Lxde   $CF[203]              #$CF[256]
     $CF[203]#          Gnome    : Cinnamon $CF[203]            #$CF[256]
     $CF[203]#          Kde      : Sugar $CF[203]               #$CF[256]
     $CF[203]#          Xfce $CF[203]                           #$CF[256]
     $CF[203]##                                        ##$CF[256]
     $CF[203]###                                      ###$CF[256]
"


### END SECTION desktop.sh

### SECTION boot.sh
kbomsg="
    $CF[203]# : ###############################%B$CF[105] Kernel Boot Options %b$CF[203]#####################################$CF[256]
    $CF[203]# : $CF[111]enable kernel boot options/parameters for more info visit links below;                  $CF[203]#$CF[256]
    $CF[203]# : $CF[198]https://www.kernel.org/doc/Documentation/admin-guide/kernel-parameters.txt      $CF[203]        #$CF[256]
    $CF[203]# : $CF[198]https://wiki.archlinux.org/index.php/Kernel_parameters                          $CF[203]        #$CF[256]
    $CF[203]# : $CF[111]usefull links if costumasing the kernel parameters.                                     $CF[203]#$CF[256]
    $CF[203]# : $CF[111]enable default or enable nvidia.drm.modeset=1 or input other custom options for systemd.$CF[203]#$CF[256]
    $CF[203]# : ################################# : ########### : #######################################$CF[256]
    $CF[203]# : #-------------------------------# : ########### : #-------------------------------------#$CF[256]
    $CF[203]# : ################################# : Description : #######################################$CF[256]
    $CF[203]# : $CF[111]if you enable nvidia.drm i recommand you to add                                     $CF[203]    #$CF[256]
    $CF[203]# : $CF[111]MODULES+=\"nvidia nvidia_modeset nvidia_uvm nvidia_drm\" : to $CF[198]/etc/mkinitcpio.conf  $CF[203]    #$CF[256]
    $CF[203]# : $CF[111]as it is stated at the Arch-Linux Wiki under                                        $CF[203]    #$CF[256]
    $CF[203]# : $CF[198]https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting $CF[203]                    #$CF[256]
    $CF[203]# : ################### : ###################################################################$CF[256]
    $CF[203]# : #-----------------# : #-----------------------------------------------------------------#$CF[256]
    $CF[203]# : $CF[82]Valid inputs {1..3} : $CF[256]"

## AUR KERNEL MENU
aurkmsg="
  $CF[203]# : ################################## : ################### : ###################################$CF[256]
  $CF[203]# : #-------------------------------## :$CF[105] A.U.R Linux Kernels $CF[203]: #---------------------------------#$CF[256]
  $CF[203]# : ################################## : ################### : ###################################$CF[256]
  $CF[203]# : # $CF[111]this script is ment to help you pick a kernel that fits your needs to some extend          #$CF[256]
  $CF[203]# : # $CF[198]more kernels and info at : https://wiki.archlinux.org/index.php/Kernels                    #$CF[256]
  $CF[203]# : ################################## : ################### : ###################################$CF[256]
  $CF[203]# : #--------------------------------# : $CF[105]Options Description : $CF[203]#---------------------------------#$CF[256]
  $CF[203]# : ################################## : ################### : ###################################$CF[256]
  $CF[203]# : $CF[198]Linux-rt  :$CF[111] Linux kernel with the realtime patch set. $CF[256]
  $CF[203]# :             :$CF[111] Improves latency and introduces hard realtime support# $CF[256]
  $CF[203]# : $CF[198]Linux-ck  :$CF[111] Linux Kernel built with Con Kolivas' ck1 patchset—see the $CF[256]
  $CF[203]# :             :$CF[111] #-ck section or the linux-ck page. Additional options which can be $CF[256]
  $CF[203]# :             :$CF[111] toggled on/off in the PKGBUILD include:BFQ scheduler, nconfig, localmodconfig $CF[256]
  $CF[203]# :             :$CF[111] and use running kernel's config. $CF[256]
  $CF[203]# :$CF[198] linux-Mainline :$CF[111] is the vanilla Linux kernel the mainline branch $CF[256]
  $CF[203]# :$CF[198] *-nvidia-*     :$CF[111] is the same as the kernel but a nvidia driver with rt or ck patches $CF[256]
  $CF[203]# :                :$CF[111] only to be selected if a nvidia card is available on system$CF[256]
  $CF[203]# : ################### : ###################################################################$CF[256]
  $CF[203]# : #-----------------# : #-----------------------------------------------------------------#$CF[256]
  $CF[203]# : $CF[82]Valid inputs {1..7} : $CF[256]"

"
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : #--------------------------------# : MENU NAME SET       : $CF[203]#---------------------------------#$CF[256]
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : #--------------------------------# : $CF[105]Options Description : $CF[203]#---------------------------------#$CF[256]
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : ################### : ###################################################################$CF[256]
    $CF[203]# : #-----------------# : #-----------------------------------------------------------------#$CF[256]
    $CF[203]# : $CF[82]Valid inputs {1..3} : $CF[256]"


modmsg="
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : #--------------------------------# : SET Kernel Modules  : $CF[203]#---------------------------------#$CF[256]
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : # select the modules you need to add to the MODULES line in mkinitcpio                       #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : #--------------------------------# : $CF[105]Options Description : $CF[203]#---------------------------------#$CF[256]
    $CF[203]# : ################################## : ################### : ###################################$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : options :                                                                                    #$CF[256]
    $CF[203]# : ################### : ###################################################################$CF[256]
    $CF[203]# : #-----------------# : #-----------------------------------------------------------------#$CF[256]
    $CF[203]# : $CF[82]Valid inputs {1..3} : $CF[256]"
modmsg1="set as active module for mkinitcpio.conf"
modmsg2="$CF[82]current added modules to line for MODULES in mkinitcpio.conf is:
     $CF[198]$mkmodules $CF[256]"
hookmsg=""
hookmsg1="set as active hook for mkinitcpio.conf"
hookmsg2="$CF[82]current added hooks to line for HOOKS in mkinitcpio.conf is:
     $CF[198]$mkhooks $CF[256]"
### END SECTION boot.sh

### GENERAL SECTION
menuinvalid="$CF[1]invalid input $CF[82]please input a number between $CF[256]"
menunext="$CF[82] Prosseding To The Next Step of The Operation $CF[256]"
menusbk="$CF[198] Back to Sub Menu $CF[256]"
menubk="$CF[202] Back to Main Menu $CF[256]"
menuex="$CF[202] Exiting Arch linux System Config Bye! $CF[256]"
menuvalid="$CF[198] $option $CF[82] is a valid option continuing $CF[256]"
menuclear="$CF[81] Clearing selection there is no shame in return$CF[256]"
## END GENERAL SECTION
