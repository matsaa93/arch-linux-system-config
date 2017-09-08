#!/bin/zsh
# file jused to generate color variables
#
for (( i=1; i<=255; i++ )) ; do
echo "# color code $i
CF[$i]=%F{$i}
CB[$i]=%K{$i}" >> color-vars.sh
print -P  "%F{$i}# color code $i %f"
done

echo "#resets color code 256
CF[256]=%f
CB[256]=%k
" >> color-vars.sh
