#!/bin/bash

# Besu 25.7.0 - REGULAR NODE
# For regular nodes that sync with the network

cd /etc/systemd/system
echo "Starting KalyChain Regular Node..."
echo "
	[Unit]
	Description=Kaly Regular Node Service
	After=network.target
	
	[Service]
	Type=simple
	Restart=always
	RestartSec=5
	User=$USER
	Group=$USER
	LimitNOFILE=65536
	WorkingDirectory=/home/$USER/node/
	ExecStart=/home/$USER/besu/bin/besu --config-file=/home/$USER/node-install/configs/regular/config.toml
	StandardOutput=journal
	StandardError=journal
	SyslogIdentifier=kaly-regular
	
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

echo "Regular node setup completed successfully!"
echo "Node type: REGULAR (sync only)"
echo "Database format: FOREST"
echo ""
echo "RPC APIs: Basic ETH,NET,WEB3"
echo "Mining: DISABLED"
echo "Discovery: ENABLED"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
echo
