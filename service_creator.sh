#!/bin/bash

# Input

read -p "Please enter the name for the service that you would like to create:" NAME
read -p "Please enter a description for the service:" DESC
read -p "Please enter the name of the executable from /usr/bin/ :" EXEC

# Create service file

cd /etc/systemd/system
cat << EOF | tee > $NAME.service
[Unit]
Description=$DESC
Requires=network.target

[Service]
Type=simple
ExecStart=/usr/bin/$EXEC

[Install]
WantedBy=multi-user.target
EOF

# Start service

systemctl enable --now $NAME.service

