#!/bin/zsh
cat $aretc/mkinitcpio.conf > $tmpdr/mkinitcpio.conf

echo "MODULES=\"btrfs\" #btrfs modules" >> $tmpdr/mkinitcpio.conf
echo "MODULES+=\"nvidia nvidia_modeset nvidia_uvm nvidia_drm\" #Nvivia modules" >> $tmpdr/mkinitcpio.conf
echo "MODULES+=\"nvme\" #Nvme modules" >> $tmpdr/mkinitcpio.conf

cp $aretc/nvidia.hook /etc/pacman.d/hooks/nvidia.hook

