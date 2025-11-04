%pre
cat > /tmp/flathub-apps.list <<'EOF'
org.gnome.Extensions
com.spotify.Client
com.discordapp.Discord
com.calibre_ebook.calibre
EOF
%end

%post --log=/root/flathub-post.log
set -xe

LOG=/root/flathub-install.log
exec >> "$LOG" 2>&1

echo "--- Start Flathub installation ($(date -Iseconds)) ---"

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "Installing apps from /tmp/flathub-apps.list..."

while read -r app; do
  [ -z "$app" ] && continue

  echo "Processing $app..."

  if flatpak list --columns=application | grep -qx "$app"; then
    echo "$app already installed — skipping."
    continue
  fi

  attempts=0
  success=0
  while [ $attempts -lt 3 ]; do
    attempts=$((attempts+1))
    echo "Attempt $attempts to install $app..."
    if flatpak install -y --system flathub "$app"; then
      echo "Successfully installed $app."
      success=1
      break
    fi
    echo "Failed attempt $attempts for $app, retrying in 3s..."
    sleep 3
  done

  if [ $success -eq 0 ]; then
    echo "ERROR: Could not install $app after $attempts attempts."
  fi

done < /tmp/flathub-apps.list

echo "--- Flathub installation finished ($(date -Iseconds)) ---"
%end
