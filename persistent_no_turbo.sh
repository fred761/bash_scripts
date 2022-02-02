#!/bin/bash

# Disable Intel Turbo Boost

# Create bash new bash script in /usr/bin

cd /usr/bin
cat << EOF | tee > no_turbo
#!/bin/bash

echo "1" | tee /sys/devices/system/cpu/intel_pstate/no_turbo
EOF

chmod +x no_turbo

# Create service file for no_turbo

cd /etc/systemd/system
cat << EOF | tee > no_turbo.service
[Unit]
Description=Disable Intel Turbo Boost
Requires=network.target

[Service]
Type=simple
ExecStart=/usr/bin/no_turbo

[Install]
WantedBy=multi-user.target
EOF

# Start service

systemctl enable --now no_turbo.service
