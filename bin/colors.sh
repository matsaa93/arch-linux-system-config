#!/bin/zsh
for (( i=1; i<=20; i++ )) ; do
echo "# color code $i
export CL[$i]=%F{$i}
export CB[$i]=%B%F{$i}" >> color-vars.sh
done
