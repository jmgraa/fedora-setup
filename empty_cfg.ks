lang en_US.UTF-8
keyboard pl

timezone Europe/Warsaw

# Network -- use DHCP on the primary interface
network --bootproto=dhcp --device=link --onboot=on --ipv6=auto

network --hostname=<HOSTNAME>

user --name=<USERNAME> --password=<PASSWORD> --gecos="<FULLNAME>" --groups=wheel --plaintext

reboot

# Use LVM on the whole disk (will destroy existing data)
# Adjust --size, --grow, --maxsize, or replace with custom partitions if needed.
autopart --type=lvm

# Clear the Master Boot Record and partitions
clearpart --all --initlabel

# Bootloader (use GRUB2, default)
bootloader --timeout=5 --location=mbr

# Security: enable SELinux, enable firewall and SSH
selinux --enforcing
firewall --enabled --service=ssh

# System services to enable (example: enable NetworkManager by default)
services --enabled="NetworkManager"

%packages
@^workstation-product-environment
gdm
nautilus
gnome-terminal
@core
%end

# Post-install scripts: enable graphical target, enable GDM, do basic cleanup
%post --log=/root/ks-post.log
# Ensure system boots to graphical target
/usr/bin/systemctl set-default graphical.target

# Enable GDM (GNOME Display Manager)
if [ -x /usr/bin/systemctl ]; then
  /usr/bin/systemctl enable gdm.service || true
fi

# Basic dnf clean (if network available)
if [ -x /usr/bin/dnf ]; then
  /usr/bin/dnf -y makecache || true
  /usr/bin/dnf -y clean all || true
fi

# Touch a file so you can see post log existence
echo "Kickstart completed on $(date)" > /root/ks-installed
%end

# Finally, show the anaconda GUI during install (optional)
# %display --progress --timeout=0
