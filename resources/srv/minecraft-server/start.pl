#!/usr/bin/perl

# INSTALLING THE SCRIPT
# Install "screen" if you don't already have it {on arch: pacman -S screen } 
# Download java-server form java.com and extract at /srv/minecraft-server/java-server
# OR edit{ $JAVACMD = "/to/your/java/path" } usualy "/usr/bin/java/ or just "java" depends on your system
#
# Edit the SETTINGS variables (down below) to fit your environment.
# Place this file in /srv/minecraft-server/ or in the server directory
#
# USING THE SCRIPT
# Usage: /srv/minecraft-server/start.pl {option}
# (Backup makes a .tar.gz archive of the world folder in the backup directory
# (Cleanup deletes backups older than [days] given in the backup directory)

### BEGIN INIT INFO
# Provides:   minecraft-server
# Required-Start: $local_fs $remote_fs
# Required-Stop:  $local_fs $remote_fs
# Should-Start:   $network
# Should-Stop:    $network
# Default-Start:  2 3 4 5
# Default-Stop:   0 1 6
# Short-Description:    Minecraft server
# Description:    Starts the minecraft server
### END INIT INFO

# SETTINGS
# ( ͡° ͜ʖ ͡°)
# JAVA SETTINGS
# garbege collection early and late
# G1GC for New gen java 8 and higther
#print "initiating config";
$GGC = "-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC"; # general  G1GC options
$GCnew = "-XX:G1NewSizePercent=35 -XX:G1MaxNewSizePercent=60"; # new size
$GCvar = "-XX:TargetSurvivorRatio=90 -XX:InitiatingHeapOccupancyPercent=45 -XX:G1MixedGCLiveThresholdPercent=50"; # thresholds
$GCmil = "-XX:MaxGCPauseMillis=200";  # max milli second between pause on "GC"
$GCT = "-XX:PermSize=512m -XX:ParallelGCThreads=12 -XX:ConcGCThreads=5"; # threads and size
# $GC = "$GGC $GCnew $GCvar $GCmil $GCT"; # activation of G1GC
#
# additional JAVA_ARGUMENTS
$fmlo = "-Dfml.queryResult=confirm"; # auto confirm fml forge remove missing block
$JAVA_PARAMETERS = "-server -Duser.language=en -d64 -XX:+UseAdaptiveSizePolicy"; # standar java argument
# JAVA PATH java executable
$JAVACMD = "/srv/minecraft-server/java-server/jre/bin/java"; # path to java
## SERVER spesific settings
$SETTINGSP = "/srv/minecraft-server/settings";
$SERVERJAR = "server.jar";	# Name of the minecraft-server jar file or forge-server jar file
$SERVICENAME = "minecraftsrv";	    # Name of the service
$SERVICENAMEBKRB = "minecraftsrvbkrb";    # Name of the backup reboot service
$SERVERBKRB = "backup-restart.pl";        # Name of script for backup and reboot
$SERVERPATH = "/srv/minecraft-server";		# Directory where the server lives or sub dir 
$BACKUPDIR = "backups";					# Name of backup directory
$USERNAME = "$USER";				# User that the server should run
#$JAVASTART = "$JAVACMD -Xms4096M -Xmx16384M $GC $JAVA_PARAMETERS $fmlo -jar $SERVERJAR nogui";
#print "config finalised";
print "";
chomp($CURRENTUSER = `whoami`);	# Determines what user is running the command to see if password is required
sub show {
    if( status() ) {
        `screen -r $SERVICENAME`;
    } else {
        print "$SERVICENAME is not running minecraft-server";
    }
}

sub startup {
    print "Starting the server $SERVICENAME\n", sleep (2), start();
    print "Starting backup & reboot service $SERVICENAMEBKRB\n", sleep (2), bkrbstart();
}

sub stopservices {
    print "Stopping backup service \n", sleep (2), bkrbstop();
    print "Stopping Minecraft Server\n", sleep (2), stop(); 
}

sub start {
	if( status() ) {
		print "Service is already running (pid $pid)\n";
	} else {
		if( $CURRENTUSER eq $USERNAME ) {
			`cd $SERVERPATH && screen -dmS $SERVICENAME $JAVACMD -Xms4096M -Xmx16384M $GGC $GCT $GCvar $GCnew $GCmil $JAVA_PARAMETERS $fmlo -jar $SERVERJAR nogui`;
		} else {
			print "Enter password for user $USERNAME\n";
			`cd $SERVERPATH && su - $USERNAME -c "screen -dmS $SERVICENAME $JAVACMD -Xms4096M -Xmx16384M $GGC $GCT $GCvar $GCnew $GCmil $JAVA_PARAMETERS $fmlo -jar $SERVERJAR nogui"`;
		}
	}
}

sub stop {
	if( status() ) {
		command("stop");
	} else {
		print "Service is already stopped.\n";
	}
}

sub restart {
	if( status() ) {
        command("say server will restart in 5 min( ͡° ͜ʖ ͡°)");
        sleep(150);
        command("say server will restart in 2,5 min( ͡° ͜ʖ ͡°)");
        sleep(60);
        command("say server will restart in 1,5 min( ͡° ͜ʖ ͡°)");
        sleep(30);
        command("say server will restart in 1 min( ͡° ͜ʖ ͡°)");
        sleep(30);
        command("say server will restart in 45sec( ͡° ͜ʖ ͡°)");
        sleep(15);
        command("say server will restart in 30sec( ͡° ͜ʖ ͡°)");
        command("say Warning log out now or be kicked out by restart");
        sleep(15);
        command("say you realy wanty to log out now only 15 sec left");
        command("say until reboot please!!");
        sleep(15);
		stop();

		while(&status == 1) {
			sleep(1);
		}

		start();
		print "Service has been restarted\n";
	} else {
		print "Service is not currently running.\n";
	}
}

sub status {
	#Returns 1 if service is running and 0 if it is not running.
	my $process = `ps ax | grep -v grep | grep -v -i SCREEN | grep $SERVERJAR`;	

	if( $process eq '' ) {
		return 0;
	} else {
		#Strips out process PID number
		if ($process =~ m/(\d+)/) {
			$pid = $1;
		}

		return 1;
	}
}
sub bkrbstart { 
     if( bkrbstatus() ) {
         print "Service is already running (pid $pidbr)\n";
     } else {
         if( $CURRENTUSER eq $USERNAME ) {
             `cd $SERVERPATH && screen -dms $SERVICENAMEBKRB ./$SERVERBKRB`;
         } else {
             `cd $SERVERPATH && su - $USERNAME -c "screen -dms $SERVICENAMEBKRB ./$SERVERBKRB"`;
         }
     }
}

sub bkrbstop {
    if( bkrbstatus() ) {
        `kill $pid1`
    } else {
        print "Backup service is already stopped.\n";
    }
}

sub bkrbstatus {
    #Returns 1 if bkrbservice is running and 0 if it is not running.
    my $process = `ps ax | grep -v grep | grep -v -i SCREEN | grep $SERVERBKRB`;

    if( $process eq '' ) {
        return 0;
    } else{
        if ($process =~ m/(\d+)/) {
            $pid1 = $1;
        }
    
    }
}

sub command {
	if( $CURRENTUSER eq $USERNAME ) {
		`screen -p 0 -S $SERVICENAME -X eval 'stuff \"$_[0]\"\r'`;
	} else {
		my $CMD = "`screen -p 0 -S $SERVICENAME -X eval 'stuff \"$_[0]\"\r'`";
		print "Enter password for user $USERNAME\n";
		`su - $USERNAME -c "$CMD"`;
	}
}

sub give {
	my ( $user, $item_id, $amount )=@_;

	# Distributes item amount evenly into 64 chunks
	while($amount > 0) {
		if($amount > 64) {
			command("give $user $item_id 64");
			$amount -= 64;
		} else {
			command("give $user $item_id $amount");
			$amount = 0;
		}
	}
}

sub backup {
	my $filename = "world_`date +%y-%m-%d_%H-%M-%S`.tar.gz";

	command("save-off");
	command("save-all");

	sleep(2);

	command("say Mineserv is making a world backup.");

	`cd $SERVERPATH && tar -czf $BACKUPDIR/$filename world`;

	command("save-on");
}

sub cleanup {
	print("Deleted backups older that $_[0] days.\n");
	`cd "$SERVERPATH" && find "$BACKUPDIR" -mtime "+$_[0]" -type f -exec rm -rf \{\} \\;`;
}

#Command tree
my ($command)=@ARGV;

if($command eq "startup") {
    startup();
} elsif($command eq "stopserver") {
    stopservices();
} elsif($command eq "start") {
	start();
} elsif( $command eq "stop" ) {
	stop();
} elsif( $command eq "restart" ) {
	restart();
} elsif( $command eq "status" ) {
	if( status() ) {
		print "Minecraft server is running (pid $pid).\n";
	} else {
		print "Minecraft server is not running.\n";
	}
}elsif ($command eq "bkrbstart") {
    bkrbstart()
}elsif ($command eq "bkrbstop") {
    bkrbstop()
}elsif ($command eq "bkrbstatus") {
    if(bkrbstatus() ) {
        print "World backup is running (pid $pid1).\n";
    }else{
        print "World backup is not running.\n";
    }
} elsif( $command eq "command" ) {
	command($ARGV[1]);
} elsif( $command eq "give" ) {
	give($ARGV[1], $ARGV[2], $ARGV[3]);
} elsif( $command eq "backup" ) {
	backup();
} elsif( $command eq "cleanup" ) {
	cleanup($ARGV[1]);
} elsif( $command eq "show" ) {
    show();
} else {
	print "\nUsage: /minecraft-server/start.pl {show|startup|stopserver|start|stop|restart|status|backup|cleanup [days]}\n";
	print "(Backup makes a .tar.gz archive of the world folder in \"$BACKUPDIR\")\n";
	print "(Cleanup deletes backups older than [days] given in \"$BACKUPDIR\")\n\n";
    print "To start server on auto-reboot and -backup service: startup \n{to stop do option stopserver}\n";
    print " ";
	print "To send command to console:  command \"your command\"\n\n";
    print "To send give command to console: give {playername} {itemstack_id} {amount}"
	print "To bring up the server console run: show \n(Make sure run as user: $USERNAME)\n\n";
}
