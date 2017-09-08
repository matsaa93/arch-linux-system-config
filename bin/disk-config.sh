#!/bin/zsh
## DESCRIPTION
# this is a config script for SSD
# that will make the system more on page with the SSD's R/W
# It will enable trim daily and set the R/W-Schedule to DEADLINE
# this will improve performance on most systems
# on some systems you may need to disable the fstrim service
# and enable discard mount option ps: do not enable discard on NVM-SSD
# for stability set noatime as mount option on the ssd's it spares the SSD
# by limiting logging
## END
usage() {
    echo "$msgdmenu"
}

### START MESSAGES SECTION
# is moved to message.sh
### END MESSAGES SECTION

### START FUNCTION SECTION
disk_check(){
    ### disk Check
    # this checks if a disk is rotational or not
    # and retuns true or false
    ##END
    partgetmtp=$(lsblk -o "MOUNTPOINT" /dev/$sd | grep -i "/")
    partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-11")
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
                ssdmtp="$ssdmtp $partgetmtp"
                echo "# /dev/$sd was on $partgetmtp during install" >> $tmpdr/$sd.txt
                ;;
            *) ## ROTATIONAL CONFIRM {HDD}
                echo "Partition /dev/$sd is an Hard Disk Drive"
                echo "giving it a NO for TRIM check"
                echo "# /dev/$sd was on $partgetmtp during install" >> $tmpdr/$sd.txt
             ;;
     esac
     sleep 2
     clear
 done
 echo "$ssdpart"

}

penter(){
    echo -n "$msg"
    echo -n "| Press {ENTER} And Continue $~:"
    read nothing
}

Press(){
    echo -n "$msg"
    echo -n "| Write Inn And Pres {ENTER} $~:"
    read ssdr
}
editconfirm(){
    #
    ### confirm to edit file
    #
    press
    case ssdr in
        yes) echo "OK then we edit the file"
            cat $filein.$rule > $fileut
            ;;
        no) echo "OK proseeding no edit" ;;
        *) echo "yes or no!" && editconfirm ;;
    esac
}
shedrule(){
    #
    ### select R/W schedule rule variable
    #
    PS3="Select your prefered disk R/W Shedule for $shmsg :"
    select sdru in deadline noop cfg
    do
        case sdru in
            deadline) rule="deadline" && break ;;
            noop) rule="noop" && break ;;
            cfg) rule="cfg" && break ;;
            *) echo "not a valid option {1..3}";;
        esac
    done
}
disk_schedule() {
    #
    ### file variables
    #
    ssdshed="$arudev/60-ssd-schedulers"
    hddshed="$arudev/60-hdd-schedulers"
    ussdshed="$udev/60-ssd-scheduler.rules"
    uhddshed="$udev/60-hdd-scheduler.rules"
    #
    ### enable R/W schedule.rule for SSD {noop,deadline,cfg}
    #
    shmsg="SSD's/NVMe"
    shedrule
	if [ -f $ussdsched ]; then
        msg="file alredy present do you want to prossed with editing: $ussdshed"
        filein="$ssdshed" && fileut="$ussdshed" && editconfirm
	else
		echo "enabling $rule for ssd & NVMe"
		cat $ssdsched.$rule > $ussdsched
	fi
    #
    ### enable R/W schedule.rule for HDD {deadline,cfg,noop}
    #
    shmsg="HDD's"
    shedrule
    if [ -f $uhddsched ]; then
        msg="file alredy present do you want to prossed with editing: $uhddshed"
        filein="$hddshed" && fileut="$uhddshed" && editconfirm
    else
        echo " enabling $rule for HDD's "
        cat $hddsched.$rule > $uhddsched
    fi
}

crcase() { ## cron choise
    daily="/etc/cron.daily" && weekly="/etc/cron.weekly" && monthly="/etc/cron.monthly"
    PS3="$crmsg2"
    #
    ### select cron job
    #
    select cr in daily weekly monthly
    do
        clear
        case $cr in
            daily) crms=" daily " && echo -e "$crmsg1" && crond="$daily" && break ;;
            weekly) crms="weekly " && echo -e "$crmsg1" && crond="$weekly" && break ;;
            monthly) crms="monthly" && echo -e "$crmsg1" && crond="$monthly" && break ;;
            *) crms="weekly " && echo -e "$crmsg1" && crond="/etc/cron.weekly" && break ;;
        esac
    done
}

fstrim_cron() {
    crcase
	cronfile="$crond/trim-ssd.sh"
	orgcrond="$resources/$crond"
	orgcronfile="$orgcrond/trim-ssd.sh"
    if [ $ssdmtp = ]; then
        echo "no ssd detected by disk check or disk chesk has not yet been run"
    else
        echo "ssd detected and has an active partition/s at $ssdmtp"
        fl="$ssdmtp"
    fi
	echo "$fscrmsg1"
	if [ -f $cronfile ]; then
		echo "file is there all ok"
		else
			echo "file needs to be created"
			cat $orgcronfile > $cronfile
			chmod +x $cronfile
	fi

	if [ $fl = ]; then
		echo "$fscrmsg2"
		msg="Remember to NOT Input / at start--"
		Press
		fl="$ssdr"
	fi

	if [ $fl = ]; then
		echo "nothing"
	else
		sed '$ d' $crond/trim-ssd.sh > tmp.txt
		for c in $fl; do
			 echo "fstrim -v $c" >> tmp.txt
			 fspath="$fspath: $c"
		done
		echo "exit 0" >> tmp.txt
		cat tmp.txt > $cronfile
		chmod +x $cronfile
		rm tmp.txt
		echo "Enabled fstrim on : $fspath:"
		echo "finished $0~: $i"
	fi
}

fsrtim_systemd() {
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
    disk_schedule
    disk_check
    optfs="enter one of thease option for Trim deamon : cron | systemd :"
    read trimc
    case $trimc in
        cron) fstrim_cron
            ;;
        systemd) fstrim_systemd
            ;;
        *) echo "please enter the correct option"
            echo "$optfs"
            ;;
    esac

}
### END AUTO_FUNCTION SECTION
menu() {
    #
    ### DISK MENU FUNCTION
    #
    usage
    clear
    PS3="$msgdmenu"
    #
    # MENU
    #
    select dmenu in disk_check disk_schedule fstrim_cron fsrtim_systemd auto_config back exit
    do
        clear
        case dm in
            back) echo "back to main menu" && break ;;
            exit) echo "exiting disk-script menu Bye!" && exit 0 ;;
            *_*) echo "$dm is a valid option continuing" && echo "executing the command_function $dm" >> $tmpdr/install.log
                $dm
                msg="finished $dm from menu disk-script.sh"
                penter && echo "$msg" >> $tmpdr/install.log
                ;;
            *) echo "Warning please enter a valid number: { 1..7 }" ;;
        esac
    done
}

### START INPUT ARGUMENTS SECTION
# for i in $@; do
    $1
# done
### END INPUT ARGUMENTS SECTION
