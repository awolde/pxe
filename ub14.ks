text
install
url --url http://192.168.100.10/ubuntu14
user ubuntu --fullname "Ubuntu" --iscrypted --password $6$0xiDEePF$99RdU39bkp7X.Dlg74iW9fhhUe2jJijnyVt/8zMJYbAKQJ9DIAAk.cQLHwlGubDvO.WvynfOQvqYhshLMvee8/
auth --useshadow --enablemd5
bootloader --location=mbr

# Below is partitioning details. It assumes that you have at least 8GB disk assigned
# to your VM.
zerombr yes
clearpart --all --initlabel
part /boot --fstype=ext4 --size=200
part pv.01 --size=7200
volgroup vg01 pv.01
logvol swap --vgname=vg01 --size=1000 --name=swapvol
logvol / --vgname=vg01 --size=59000 --fstype=ext4  --name=rootvol
network --device=eth0 --onboot=yes --bootproto=dhcp --noipv6
firewall --disabled
%packages
ubuntu-minimal
openssh-server
#curl
#wget
#wireless-tools
#wpasupplicant
#linux-firmware
%post
# add normal apt source list
(
cat <<'EOP'
deb http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe
deb http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe
deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe
EOP
) >> /etc/apt/sources.list
apt-get update
#install zfs support
apt-get install software-properties-common
add-apt-repository ppa:zfs-native/stable
apt-get update
apt-get install ubuntu-zfs
apt-get install zfs-initramfs
/usr/sbin/usermod -g sudo ubuntu
#add ubuntu to sudo
echo "ubuntu ALL=(ALL) NOPASSWD:  ALL" >> /etc/sudoers
#reboot
