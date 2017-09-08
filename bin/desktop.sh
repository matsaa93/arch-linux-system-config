#!/bin/zsh
#
echo "Initialing $0"
echo "What library do you whant "
echo "Wayland or Xorg"
echo -n "~:"
xwmenu() {
PS3="$xmenu"
select desk in xorg wayland desktop back exit
do
    clear
    case $desk in
        xorg) echo "Installing Xorg" && pacman -S xorg-server xterm xorg-server-utils ;;
        wayland) echo "Installing Wayland" && pacman -S wayland weston xorg-server-xwayland xterm xorg-xinit ;;
        desktop) desktopenv ;;
        back) echo "back to main menu" && break ;;
        exit) echo "You are now exiting. Bye!" && exit 0 ;;
        *) echo "warning invalid input please enter between { 1..5 }" ;;
    esac
done
}

desktopenv() {
PS3="$dtmenu"
select dt in deepin gnome kde lxde cinnamon sugar xfce back back-main-menu exit
do
    clear
    case $dt in
        deepin) echo "Installing Deepin Desktop Environment" && pacman -S  deepin deepin-extra ;;
        gnome) echo "Installing Gnome Desktop Environment" && pacman -S gnome gnome-extra gnome-initial-setup ;;
        kde) echo "Installing KDE Desktop Environment" && pacman -S plasma kde-applications plasma-wayland-session ;;
        lxde) echo "Installing LXDE Desktop Environment" && pacman -S lxde ;;
        cinnamon) echo "Installing Cinnamon Desktop Environment" && pacman -S cinnamon ;;
        xfce) echo "Installing XFCE Desktop Environment" && pacman -S xfce4 xfce-goodies ;;
        sugar) echo "Installing Sugar Desktop Environment" && pacman -S sugar sugar-fructose sugar-runner ;;
        back-main-menu) echo "Back to Main Menu " && break 2 ;;
        back) echo "back to Desktop-menu" && break ;;
        exit) echo "You are now exiting. Bye!" && exit 0 ;;
        *) echo "warning invalid input please enter between { 1..10 }" ;;
    esac
done
}
$1
echo "finished $0"
