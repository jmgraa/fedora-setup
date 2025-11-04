lang en_US.UTF-8
keyboard pl
timezone Europe/Warsaw

# Network -- use DHCP on the primary interface
network --bootproto=dhcp --device=link --onboot=on --ipv6=auto

network --hostname=<HOSTNAME>

user --name=<USERNAME> --password=<PASSWORD> --gecos="<FULLNAME>" --groups=wheel --plaintext

reboot

# Bootloader (use GRUB2, default)
bootloader --timeout=5 --location=mbr

%packages
@^workstation-product-environment
gdm
nautilus
gnome-terminal
@core
%end

# vscode
%include https://raw.githubusercontent.com/jmgraa/fedora-setup/refs/heads/main/vscode.ks

# flathub
%include https://raw.githubusercontent.com/jmgraa/fedora-setup/refs/heads/main/flathub.ks

%post --log=/root/ks-post.log
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
