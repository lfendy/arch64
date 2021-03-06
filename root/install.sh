#!/bin/bash

DISK="/dev/$1"
PARTITION="${DISK}1"

echo DISK="$DISK", PARTITION="$PARTITION"

parted -s "$DISK" mklabel msdos
parted -s -a optimal "$DISK" mkpart primary ext4 0% 100%
parted -s "$DISK" set 1 boot on
mkfs.ext4 -F "$PARTITION"

# you can find your closest server from: https://www.archlinux.org/mirrorlist/all/
echo 'Server = http://mirror.internode.on.net/pub/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
mount "$PARTITION" /mnt
pacman -Syy

# would recommend to use linux-lts kernel if you are running a server environment, otherwise just use "linux"
pacstrap /mnt $(pacman -Sqg base | sed 's/^linux$/&-lts/') base-devel grub openssh sudo ntp wget vim tmux git docker
genfstab -p /mnt >> /mnt/etc/fstab

cp ./chroot.sh /mnt
cp ~/.ssh/authorized_keys /mnt
arch-chroot /mnt ./chroot.sh "$DISK"
rm /mnt/chroot.sh
rm /mnt/authorized_keys

umount -R /mnt
systemctl reboot
