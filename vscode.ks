%post --log=/root/ks-post.log
set -x

rpm --import https://packages.microsoft.com/keys/microsoft.asc || echo "rpm --import failed" >> /root/ks-post.log

cat > /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
autorefresh=1
type=rpm-md
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

dnf check-update || true

dnf -y install code || echo "dnf install code failed" >> /root/ks-post.log

%end
