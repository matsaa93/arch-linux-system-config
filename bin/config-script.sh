### config-script
# arch=$(cd $(dirname "$0") && pwd)
usage() {
    echo "Usage:$0 [options]"
    echo "      options: ssd_config | install_zsh | add_groups | add_user | add_logo "
    echo "             : add_admin | add_hostname | set_locale | services"
    echo "# this is ment to be used to configure arhlinux and it's shell"
    echo "# and adding the users & admins you want to add"
    echo "Option Description;"
    echo "  # install_zsh  : install zsh & oh-my-zsh powerline and sets zsh as root-shell"
    echo "  #                : install powerline &-font and powerlevel9k theme"
    echo "  #                : configure zsh to use powerlevel9k and special font"
    echo "  # add_hostmane : adds hostname to system domain"
    echo "  # add_groups   : Adds standar & admin groups and sets their permissions"
    echo "  # add_admin    : Add's a admin user to system near root permission"
    echo "  # add_user     : Add's a standar user to system"
    echo "  # services     : Enables default to multi-user & services thru systemctl"
    echo "  # set_locale   : Sets the local time/location"
    echo "  # ssd_config   : Configures system RW-schedule and enables trim"
    echo "  #                : the schedule is set to deadline and trim is fstrim"
}
#
# Press_enter function reads out user input to variable
press_enter() {
    echo "$msg"
    echo -n "Write inn and press enter to continue:"
    read input
}
#
# LOCATION Config
set_locale() {
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
}
ssd_config() {
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
}
install_zsh() {
echo "set zsh as shell"
# usermod -s /usr/bin/zsh root
cd $arbin/zsh/
chmod a+x zsh-install.sh
./zsh-install.sh
cd $arch
}
add_logo() {
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
}
add_groups() {
    ### admin user config
    groupadd admin
    afolder="etc srv usr opt home media .snapshot"
    for fold in $afolder; do setfacl -m "g:admin:rwx" /$fold ; done
    ##standar user config
    gruopadd standar
    sfolder="media srv opt"
    for foldb in $sfolder; do setfacl -m "g:standar:rwx" /$foldb ; done
}
name_pass() {
    msg="add a user name to your accont"
    press_enter
    user="$input"
    msg="add password to your user use a strong one with atleast i number and sign"
    press_enter
    password="$input"
}
add_admin() {
    add_logo
    name_pass
    useradd -m -p "$password" -g admin -G "adm,audio,http,ftp,floppy,disk,log,network,rfkill,video,scanner,storage,optical,games,wheel,users,kvm,input" -s /usr/bin/zsh $user
    cp -aT /etc/skel/ /home/$user/
}
add_user() {
    add_logo
    name_pass
    useradd -m -p "$password" -g standar -G "users,http,audio,ftp,disk,network,storage,video,game,scanner,kvm,input" -s /usr/bin/zsh $user
    cp -aT /etc/skel/ /home/$user/
}
add_hostname() {
    read host
echo "GNU-Arch-Linux-$host" > /etc/hostname
echo -e "127.0.1.1 GNU-Arch-Linux-$host" >> /etc/hosts
}
services() {
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
}
auto_config() {
    echo "this a auto function for install and may fail if something fails check the files for typos"
    echo "starting auto config in 5 sec if you wish to stop and do it manual hit [ctrl] + [c] "
    sleep 5 && set_locale && sleep 1 && ssd_config  && sleep 1 && services && sleep 1 && add_groups && sleep 1 && add_admin && sleep 1 && add_user && sleep 1 && add_hostname
}
for c in $@; do $c; done
#grub-install --recheck /dev/sd
#grub-binconfig -o /boot/grub/grub.cfg
