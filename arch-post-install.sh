#!/bin/bash

### Install minimal gnome session with additional frequently used applications. This script assumes that "archinstall" was used with the default xorg profile.

	pacman -S gdm gnome-session gnome-control-center gnome-tweaks gnome-terminal gedit eog evince fish virt-manager dnsmasq chromium libreoffice-fresh gimp rawtherapee papirus-icon-theme

### Default gnome settings

	# Disable suspend when laptop lid is closed
	
	cd ~
	mkdir ".config"
	cd ".config"
	mkdir "autostart"
	cd autostart
	cat << EOF | tee > ignore-lid-switch-tweak.desktop
	[Desktop Entry]
	Type=Application
	Name=ignore-lid-switch-tweak
	Exec=/usr/lib/gnome-tweak-tool-lid-inhibitor
	EOF

	# Change default mouse acceleration profile to flat
	
	cat << EOF | tee > mouse-profile-flat.desktop
	[Desktop Entry]
	Type=Application
	Name=mouse-profile-flat
	Exec=gsettings  set  org.gnome.desktop.peripherals.mouse  accel-profile  flat
	EOF

### Enable services

	systemctl enable gdm
	systemctl enable bluetooth
	systemctl enable libvritd
	systemctl enable dnsmasq

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

### Install Yay

	pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si

	# Install additional software from the arch user repository
	
	yay -S reaper-bin

