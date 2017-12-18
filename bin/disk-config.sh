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



### START MESSAGES SECTION
# is moved to message.sh
### END MESSAGES SECTION

### START FUNCTION SECTION
disktypetest() {
    #
    # this checks for NVMe in system by checking for availability of
    # block /dev/nvme0n1 or /dev/nvme0n2 as that's the default location
    # if dev is available it sets the $partget variable-command to support NVMe
    # since lsblk has limitations of how it outputs the code and when it
    # has a nvme there is more characters in the name and needs correction
    #
    testnvme1="/dev/nvme0n1p1"
    testnvme2="/dev/nvme0n1p2"
    testnvme3="/dev/nvme0n2p1"
    testnvme4="/dev/nvme0n2p2"
    if [ -b $testnvme1 ] ; then
       partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-16")
       echo "nvme ssd detected"
       elif [ -b $testnvme2 ] ; then
          partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-16")
          echo "nvme ssd detected"
       elif [ -b $testnvme3 ] ; then
              partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-16")
              echo "nvme ssd detected"
       elif [ -b $testnvme4 ] ; then
              partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-16")
              echo "nvme ssd detected"
       else
       partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-11")
       echo "normal check no NVMe"
    fi
    echo "$partget"

}

disk_check(){
    ### disk Check
    # this checks if a disk is rotational or not
    # and retuns true or false
    ##END
    disktypetest
    partgetmtp=$(lsblk -o "MOUNTPOINT" /dev/$sd | grep -i "/")
    #partget=$(lsblk -o "NAME,MOUNTPOINT" | grep -i "/" | cut -c "7-11")
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
                print -P "$ssdcmsg"
                ssdpart="$ssdpart $sd"
                ssdmtp="$ssdmtp $partgetmtp"
                echo "# /dev/$sd was on $partgetmtp during install" >> $tmpdr/$sd.txt
                ;;
            *) ## ROTATIONAL CONFIRM {HDD}
                print -P "$hddcmsg"
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

DPress(){
    echo -n "$msg"
    echo -n "| Write Inn And Pres {ENTER} $~:"
    read ssdr
}

editconfirm(){
    #
    ### confirm to edit file
    #
    PS3="$editmsg"
    select ed in do-edit dont-edit
    do
        case $ed in
        do-edit) echo "OK then we edit the file"
            cat $filein-$rule.rules > $fileut && break
            ;;
        *) echo "OK proseeding no edits for $fileut" && break
        ;;
    esac
    done
}

shedrule(){
    #
    ### select R/W schedule rule variable
    #
    PS3="$shedmsg"
    select sdru in deadline noop cfg
    do
        case $sdru in
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
    ssdshed="$arudev/60-ssd"
    hddshed="$arudev/60-hdd"
    ussdshed="$udev/60-ssd-scheduler.rules"
    uhddshed="$udev/60-hdd-scheduler.rules"
    #
    ### enable R/W schedule.rule for SSD {noop,deadline,cfg}
    #
    shmsg="SSD's/NVMe"
    shedrule
	if [ -f $ussdsched ]; then
        filein="$ssdshed" && fileut="$ussdshed" && editconfirm
	else
		echo "enabling $rule for ssd & NVMe"
		cat $ssdsched-$rule.rules > $ussdsched
	fi
    #
    ### enable R/W schedule.rule for HDD {deadline,cfg,noop}
    #
    shmsg="HDD's"
    shedrule
    if [ -f $uhddsched ]; then
        filein="$hddshed" && fileut="$uhddshed" && editconfirm
    else
        echo " enabling $rule for HDD's "
        cat $hddsched-$rule.rules > $uhddsched
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
            daily) crms=" daily " && print -P "$crmsg1" && crond="$daily" && break ;;
            weekly) crms="weekly " && print -P "$crmsg1" && crond="$weekly" && break ;;
            monthly) crms="monthly" && print -P "$crmsg1" && crond="$monthly" && break ;;
            *) crms="weekly " && print -P "$crmsg1" && crond="/etc/cron.weekly" && break ;;
        esac
    done
}

fstrim_cron() {
    crcase
	cronfile="$crond/trim-ssd.sh"
	orgcronfile="$orgcrond/trim-ssd.sh"
    if [ $ssdmtp = ]; then
        echo "no ssd detected by disk check or disk chesk has not yet been run"

    else
        echo "ssd detected and has an active partition/s at $ssdmtp"
        fl="$ssdmtp"
    fi
	print -P "$fscrmsg1"
	if [ -f $cronfile ]; then
		echo "file is there all ok"
		else
			echo "file needs to be created"
			cat $orgcronfile > $cronfile
			chmod +x $cronfile
	fi

	if [ $fl = ]; then
		print -P "$fscrmsg2"
		msg="Remember to NOT Input / at start--"
		DPress
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
	print -P "this will enable trim for supported filesystem weekly!"
	systemctl enable fstrim.service
	systemctl enable fstrim.timer
	systemctl status fstrim.service
	echo "finished $0~: $i"
	}
### END FUNCTION SECTION

### START AUTO_FUNCTION SECTION
auto_conf() {
    print -P "$damsg"
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
Disk_menu() {
    #
    ### DISK MENU FUNCTION
    #
    clear
    PS3="$msgdmenu"
    #
    # MENU
    #
    select option in disk_check disk_schedule fstrim_cron fsrtim_systemd auto_config back exit
    do
        clear
        x=$option
        case $option in
            back)
                print -P "$menubk"  && break
            ;;
            exit)
                print -P "$menuex"  && exit 0
            ;;
            *_*)
                minlog
                $option
                msg="finished $dm from Disk Menu"
                DPress && echo "$msg" >> $tmpdr/install.log
            ;;
            *)
                print -P "$CF[1] Warning please enter a valid number: { 1..7 }%f"
            ;;
        esac
    done
}

### START INPUT ARGUMENTS SECTION
# for i in $@; do
# done
### END INPUT ARGUMENTS SECTION
