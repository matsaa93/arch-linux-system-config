#!/usr/bin/perl
#use strict;
use warnings;
#this is a backup and reboot loop script for minecraft servers on linux
#made by matsaa93
$MASTER = "start.pl";
# BACKUP MINECRAFT SERVER
sub backup {
    print "doing backup\n";
    `./$MASTER backup`;
}
# RESTART MINECRAFT SERVER
sub restart {
    print "doing server restart";
    `./$MASTER restart`;
}
# SERVICE COUNTER LOOP
my $counter = 0;
 while($counter < 12) {
     print ("$counter\n");
     backup();
     # count up
     $counter++;
     # pause for 2hours
     sleep(7200); 
     # pause for 1hours 
     # sleep(3600)
     #
     #sleep(2); # test timer
     if ($counter == 12) {
         print "you have done the last backup for this sesion\n";
         restart();
         $counter = 0;
     }
 }
