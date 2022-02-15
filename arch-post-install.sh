#!/bin/bash

### Install minimal gnome session with additional frequently used applications. This script assumes that "archinstall" was used with the default xorg profile.

pacman -S gdm gnome-session gnome-control-center gnome-tweaks gnome-terminal nautilus gedit mc eog evince fish htop realtime-privileges xorg-xrandr xorg-xgamma flatpak firefox chromium vlc easyeffects zam-plugins mda.lv2 papirus-icon-theme 

### Enable services

systemctl enable gdm
systemctl enable bluetooth

### Add user to realtime group

usermod -aG realtime user

### Set the governor to performance

# Create new bash script in /usr/bin

cd /usr/bin
cat << EOF | tee > performance_gov
#!/bin/bash

echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
EOF

chmod +x performance_gov
# Create service file for performance_gov
cd /etc/systemd/system
cat << EOF | tee > performance_gov.service
[Unit]
Description=Set governor to performance
Requires=network.target

[Service]
Type=simple
ExecStart=/usr/bin/performance_gov

[Install]
WantedBy=multi-user.target
EOF

# Start service

systemctl enable performance_gov.service
