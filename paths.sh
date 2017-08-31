#!/bin/zsh
## PATH script
## BASE DIR ARCH
echo "Initiate paths.sh"
base=$(cd $(dirname "$0") && pwd)
export arch="$base"
## tmp/
export artmp="$arch/tmp"
## bin/*
export arbin="$arch/bin"
## resources/*
export resources="$arch/resources"
export arzsh="$resources/zsh"
export aretc="$resources/etc"
## rules.d
export arudev="$aretc/udev/rules.d"
export udev="/etc/udev/rules.d"


### END PATH script
echo "Finished Paths.sh"
