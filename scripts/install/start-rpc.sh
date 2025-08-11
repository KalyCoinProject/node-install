#!/bin/bash

# Besu 25.7.0 - RPC NODE
# Updated to match current RPC configuration with 25.7.0 compatibility fixes 

cd /etc/systemd/system
echo "Starting KalyChain..."
echo "
	[Unit]
	Description=Kaly Node Service
	[Service]
	Type=simple
	Restart=always
	RestartSec=1
	User=$USER
	Group=$USER
	LimitNOFILE=65536
	WorkingDirectory=/home/$USER/node/
	ExecStart=/home/$USER/besu/bin/besu --config-file=/home/$USER/node-install/configs/rpc/config.toml
	[Install]
	WantedBy=multi-user.target
" | sudo tee kaly.service

# Configure journald
if grep -q ForwardToSyslog=yes "/etc/systemd/journald.conf"; then
  sudo sed -i '/#ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
  sudo sed -i '/ForwardToSyslog=yes/c\ForwardToSyslog=no' /etc/systemd/journald.conf
elif ! grep -q ForwardToSyslog=no "/etc/systemd/journald.conf"; then
  echo "ForwardToSyslog=no" | sudo tee -a /etc/systemd/journald.conf
fi
cd -

# Start systemd Service
sudo systemctl force-reload systemd-journald
sudo systemctl daemon-reload
sudo systemctl start kaly.service
sudo systemctl enable kaly.service

read -n 1 -s -r -p "Service successfully started! Press any key to continue..."
echo
echo
