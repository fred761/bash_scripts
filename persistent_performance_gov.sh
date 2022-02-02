#!/bin/bash

# Set the governor to performance

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

systemctl enable --now performance_gov.service
