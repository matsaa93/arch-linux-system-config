#!/bin/bash
### DESCRIPTION /etc/cron.daily/trim-ssd.sh
# this file enables trim for the partition's listed in here
# the service will run ones a day when the timer gets to ZERO
# to enable trim for other partition's just add them to the list of partitions
# like this fstrim -v /path/to/mount/point
# example: fstrim -v /home
#		 : fstrim -v /opt/games
##END
fstrim -v /
exit 0