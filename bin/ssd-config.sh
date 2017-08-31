#!/bin/zsh
## DESCRIPTION
# this is a config script for SSD
# that will make the system more on page with the SSD's R/W
# It will enable trim daily and set the R/W-Schedule to DEADLINE
# this will improve performance on most systems
# on some systems you may need to disable the fstrim service
# and enable discard mount option ps: do not enable discard on NVM-SSD
# for stability set noatime as mount option on the ssd's it spares the SSD
# by limiting logging and some other protective things
## END

### START MESSAGES SECTION
lbcl[1]="\e[1;44m;95m" # magenta-fg blue-bg
lbcl[2]="\e[1;104;95m" # magenta-fg light-blue-bg
lbcl[3]="\e[0m"      # reset color
lbcl[4]="\e[1;41;93m"  # yellow-fg red-bg
lbcl[5]="\e[1;102;94m"
sdmsg="
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
crmsg1="
      $lbcl[1].----------------------------------------------------.$lbcl[3]
      $lbcl[1]:  $lbcl[2]:'''''''''''''''''''''''''''''''''''''''''''''':$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]: fstrim-cron timer set to default $lbcl[4]: $crms :$lbcl[2] :$lbcl[1]  :$lbcl[3]
      $lbcl[1]:  $lbcl[2]:,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,:$lbcl[1]  :$lbcl[3]
      $lbcl[1]:____________________________________________________:$lbcl[3]
"
### END MESSAGES SECTION

### START FUNCTION SECTION
disk_check(){
    ### disk Check
    # this checks if a disk is rotational or not
    # and retuns true or false
    ##END
    #partgetnvm=$(lsblk -o "NAME" | grep -i "nvm" | cut -c "7-10")
    partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-10")
    # echo "$partget"
    for e in $partget; do
        mntcheck=$(lsblk -o "UUID,MOUNTPOINT,FSTYPE" /dev/$e | grep -i "/")
        part="$part $e"
        echo "listing /dev/$e as active partition for fstab creation"
        echo "UUID=$mntcheck" > $tmpdr/$e.txt
    done
    ###################
    for sd in $part; do
        echo "$sdmsg"
        smcmd=$(smartctl -i /dev/$sd | grep -i "Solid State Device" | cut -c "19-36")
        case $smcmd in
            "Solid State Device") ## NON ROTATIONAL CONFIRM {SSD/NVMe}
                echo "/dev/$sd is an Solid State Device"
                echo "giving it a OK for TRIM check"
                ssdpart="$ssdpart $sd"
                ;;
            *) ## ROTATIONAL CONFIRM {HDD}
                echo "Partition /dev/$sd is an Hard Disk Drive"
                echo "giving it a NO for TRIM check"
             ;;
     esac
     sleep 2
     clear
 done
 echo "$ssdpart"
}

Press(){
    echo -n "$msg"
    echo -n "| Write Inn And Pres {ENTER} $~:"
    read ssdr
}

diskschedule() {
    ### enable deadline schedule for SSD
	if [ -f $udev/60-ssd-scheduler.rules ]; then
		echo "deadline alredy enabled"
	else
		echo "enabling deadline for ssd & NVMe"
		cp $arudev/60-ssd-schedulers.rules /etc/udev/rules.d/60-ssd-scheduler.rules
	fi
    ### enable deadline schedule for HDD
    if [ -f $udev/60-hdd-scheduler.rules ]; then
        echo "deadline alredy enabled"
    else
        echo "enabling deadline for ssd & NVMe"
        cp $arudev/60-hdd-schedulers.rules /etc/udev/rules.d/60-hdd-scheduler.rules
    fi
}

crcase() { ## cron choise
    daily="/etc/cron.daily" && weekly="/etc/cron.weekly" && monthly="/etc/cron.monthly"
    read cr
    case $cr in
        daily) crms=" daily " && echo -e "$crmsg1" && crond="$daily" ;;
        weekly) crms="weekly " && echo -e "$crmsg1" && crond="$weekly" ;;
        monthly) crms="monthly" && echo -e "$crmsg1" && crond="$monthly" ;;
        *) crms="weekly " && echo -e "$crmsg1" && crond="/etc/cron.weekly" ;;
    esac
}

fstrimcron() {
    crcase
	cronfile="$crond/trim-ssd.sh"
	orgcrond="$resources/$crond"
	orgcronfile="$orgcrond/trim-ssd.sh"
	echo "
	 ## FSTRIM BY CRON #######################
	# is a script that will run as a cron job##
	# and enables trim for SSD's on supported ##
	# File system or not it is kind of manual ###
	# it needs the partition mount point      ##
	# like /home, /ROOT, /etc....            ##
	 ## END ##################################
	"
	if [ -f $cronfile ]; then
		echo "file is there all ok"
		else
			echo "file needs to be created"
			cat $orgcronfile > $cronfile
			chmod +x $cronfile
	fi

	if [ $fl = ]; then
		echo "enable trim chose where to enable it, it is on root by default"
		echo "type inn partition path (where it is mounted) f.ex: mnt home media/data"
		echo "if something seems off edit or disable /etc/cron.daily/trim-ssd.sh"
		msg="Remember to NOT Input / at start--"
		Press
		fl="$ssdr"
	fi

	if [ $fl = ]; then
		echo "nothing"
	else
		sed '$ d' $crond/trim-ssd.sh > tmp.txt
		for c in $fl; do
			 echo "fstrim -v /$c" >> tmp.txt
			 fspath="$fspath: /$c"
		done
		echo "exit 0" >> tmp.txt
		cat tmp.txt > $cronfile
		chmod +x $cronfile
		rm tmp.txt
		echo "Enabled fstrim on : $fspath:"
		echo "finished $0~: $i"
	fi
}

fsrtimsystemd() {
	echo "enabling fstrim thru systemd"
	echo "this will enable trim for supported filesystem weekly!"
	systemctl enable fstrim.service
	systemctl enable fstrim.timer
	systemctl status fstrim.service
	echo "finished $0~: $i"
	}
### END FUNCTION SECTION

### START AUTO_FUNCTION SECTION
auto_conf() {
    echo "$damsg"
}
### END AUTO_FUNCTION SECTION

### START INPUT ARGUMENTS SECTION
for i in $@; do
    $i
done
### END INPUT ARGUMENTS SECTION
