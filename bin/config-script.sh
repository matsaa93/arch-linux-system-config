#!/bin/zsh
### config-script
# arch=$(cd $(dirname "$0") && pwd)
inlog() {echo "Starting $0~: $x" >> $tmpdr/install.log }
utlog() {echo "Finished $0~: $x" >> $tmpdr/install.log }
usage() {
    echo "$msgus"
}
mlist=""
#
# Press_enter function reads out user input to variable
penter() {
    echo "$msg"
    echo -n "Press <Enter> to continue:"
    read input
}

press_enter() {
    inlog
    echo "$msg"
    echo -n "Write inn and Press <Enter> to continue:"
    read input
    utlog
}
#
# LOCATION Config
set_locale() {
    inlog
    #
	echo "set locale"
	set -e -u
	locgen=/etc/locale.gen
	zone="nn_NO nb_NO en_US"
	for e in $zone; do
		echo "$e.UTF-8 UTF-8" >> $locgen
		echo "$e ISO-8859-1" >> $locgen
	done
	# sed -i 's/#\(nn_NO\.UTF-8\)/\1/' /etc/locale.gen
	locale-gen
	echo LANG=nn_NO.UTF-8 >> /etc/locale.conf
	export LANG=nn_NO.UTF-8
	echo "set time"
	ln -sf /usr/share/zoneinfo/Europe/Oslo /etc/localtime
	hwclock --systohc --utc
    #
    utlog
}

ssd_config() {
    inlog
    #
ssd="run"
while [[ $ssd = "run" ]]; do
    echo -n "please enter yes or no ~:"
    read ssd
    case $ssd in
        y|Y|YES|yes) echo "starting to configure for SSD" && ./ssd-config.sh ;;
        n|N|NO|no) echo "OK NO SSD THEN YOU SHOULD THINK OF GETTING ONE" ;;
        *) echo "that is not yes or no!" && ssd="run" ;;
    esac
done
#
utlog
}

install_zsh() {
    inlog
    # sh
    echo "set zsh as shell"
    # usermod -s /usr/bin/zsh root
    chmod a+x $arbin/zsh-install.sh
    zsh $arbin/zsh-install.sh
    # ./zsh-install.sh
    # cd $arch
    #
    utlog
}

add_logo() {
    inlog
echo "
      # # # # # # # # # # # # # # # # # # # # # # # # # # ###
      ## # # # # # # # # # # # # # # # # # # # # # # # # # ##
      ### # # # # # # # # # # # # # # # # # # # # # # # # # #
      ## # # # # # # # # # # # # # # # # # # # # # # # # # ##
      ##             Costum Arch-Linux Install             ##
      ##                  Create Users.                    ##
      ##                                                   ##
      ## ##         /-------------------------\         ## ##
      ## ##  ______/---------------------------\______  ## ##
      #  ## # # # #\---------------------------/# # # # ##  #
      #  # # # # # #\-------------------------/# # # # # #  #
      ##%#################################################%##
"
utlog
}
add_groups() {
    inlog
    ### admin user config
    groupadd admin
    afolder="etc srv usr opt home media .snapshot"
    for fold in $afolder; do setfacl -m "g:admin:rwx" /$fold ; done
    ##standar user config
    gruopadd standar
    sfolder="media srv opt"
    for foldb in $sfolder; do setfacl -m "g:standar:rwx" /$foldb ; done
    #
    utlog
}
mlist+=" add_groups"

add_tmpfs() {
    inlog
    [[ -d $mountpt ]] || mkdir -p $mountpt
    echo "tmpfs                $mountpt    tmpfs defaults,noatime,mode=1777   0  0" >> /etc/fstab
    utlog
}

name_pass() {
    inlog
    #
    msg="add a user name to your accont"
    press_enter
    user="$input"
    msg="add password to your user use a strong one with atleast i number and sign"
    press_enter
    password="$input"
    #
    utlog
}

pw_root() {
    echo -n "password for root enter it:"
    read passrot
    usermod -p "$passrot" root
}
mlist+=" pw_root"

add_admin() {
    inlog
    #
    add_logo
    name_pass
    useradd -m -p "$password" -g admin -G "adm,audio,http,ftp,floppy,disk,log,network,rfkill,video,scanner,storage,optical,games,wheel,users,kvm,input" -s /usr/bin/zsh $user
    cp -aT /etc/skel/ /home/$user/
    mountpt="/root/.thumbnails"
    add_tmpfs
    #
    utlog
}
mlist+=" add_admin"

add_user() {
    inlog
    #
    add_logo
    name_pass
    useradd -m -p "$password" -g standar -G "users,http,audio,ftp,disk,network,storage,video,game,scanner,kvm,input" -s /usr/bin/zsh $user
    cp -aT /etc/skel/ /home/$user/
    mountpt="/home/$user/.thumbnails"
    add_tmpfs
    #
    utlog
}
mlist+=" add_user"

add_hostname() {
    inlog
    #
    read host
    echo "GNU-Arch-Linux-$host" > /etc/hostname
    echo -e "127.0.1.1 GNU-Arch-Linux-$host" >> /etc/hosts
    #
    utlog
}

enable_services() {
    inlog
    #
echo "
      # # # # # # # # # # # # # # # # # # # # # # # # # # ###
      ## # # # # # # # # # # # # # # # # # # # # # # # # # ##
      ### # # # # # # # # # # # # # # # # # # # # # # # # # #
      ## # # # # # # # # # # # # # # # # # # # # # # # # # ##
      ##             Costum Arch-Linux Install             ##
      ##                  Enable services                  ##
      ##                     SystemCTL                     ##
      ## ##         /-------------------------\         ## ##
      ## ##  ______/---------------------------\______  ## ##
      #  ## # # # #\---------------------------/# # # # ##  #
      #  # # # # # #\-------------------------/# # # # # #  #
      ##%################################################%##
"
systemctl enable pacman-init.service choose-mirror.service
systemctl set-default multi-user.target
#
utlog
}

auto_aug() {
    inlog
    #
    echo "Automatic setup for admin & user's and groups & hostname"
    add_groups && sleep 1
    add_admin && sleep 1
    add_user && sleep 1
    add_hostname
    #
    utlog
}

auto_tmpfs() {
    inlog
     #
#    echo "proc                 /proc                proc defaults              0 0" >> /etc/fstab
#    echo "sysfs                /sys                 sysfs noauto               0 0" >> /etc/fstab
#    echo "debugfs              /sys/kernel/debug    debugfs noauto             0 0" >> /etc/fstab
#    echo "usbfs                /proc/bus/usb        usbfs noauto               0 0" >> /etc/fstab
#    echo "devpts               /dev/pts             devpts mode=0620,gid=5     0 0" >> /etc/fstab
    echo "## tmpfs section"  >> /etc/fstab
#    echo "tmpfs                /ramdisk             tmpfs nodev,nosuid,noatime,mode=1777,size=100M 0 0" >> /etc/fstab
    mountpt="/tmp" && add_tmpfs
    mountpt="/var/spool" && add_tmpfs
    mountpt="/var/tmp" && add_tmpfs
    #
    utlog
}

auto_config() {
    inlog
    #
    echo "this a auto function for install and may fail if something fails check the files for typos"
    echo "starting auto config in 5 sec if you wish to stop and do it manual hit [ctrl] + [c] "
    sleep 5
    set_locale && sleep 1
    ssd_config  && sleep 1
    autoaug
    #
    autotmpfs
    utlog
}

#mlist="zsh_install set_locale ssd_config pwroot add_groups add_admin add_user add_hostname auto_tmpfs auto_aug auto_config enable_services back exit"
menu() {
    clear
    PS3="$msgus"
    #
    select x in set_locale install_zsh ssd_config add_groups pw_root add_admin add_user add_hostname auto_aug auto_tmpfs auto_config enable_services back exit
    do
        clear
        case $x in
            back) echo "back to main menu" && break ;;
            exit) echo "exiting $0 menu Bye!" && exit 0 ;;
            *_*) echo "$x is a valid option continuing" && echo "executing the command_function $x" >> $tmpdr/install.log
                $x
                msg="finished $x from menu config-script.sh"
                penter && echo "$msg" >> $tmpdr/install.log
                ;;
            *) echo "Warning please enter a valid number: { 1..14 }" ;;
        esac
    done
}

$1

#for c in $@; do $c; done
#grub-install --recheck /dev/sd
#grub-binconfig -o /boot/grub/grub.cfg
