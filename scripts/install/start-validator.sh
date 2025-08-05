#!/bin/bash

# Besu 25.7.0 - BOOTNODE / VALIDATOR NODE
# For nodes that serve as bootnodes or validators
# Keeps existing database format, adds only essential new flags

cd /etc/systemd/system
echo "Starting KalyChain Bootnode+Validator (Conservative Upgrade)..."
echo "
	[Unit]
	Description=Kaly Bootnode+Validator Service
	After=network.target
	
	[Service]
	Type=simple
	Restart=always
	RestartSec=5
	User=$USER
	Group=$USER
	LimitNOFILE=65536
	WorkingDirectory=/home/$USER/node/
	ExecStart=/home/$USER/besu/bin/besu --config-file=/home/$USER/node-install/configs/validator/config.toml
	StandardOutput=journal
	StandardError=journal
	SyslogIdentifier=kaly-bootnode-validator
	
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

echo "Conservative bootnode+validator upgrade completed successfully!"
echo "Node type: BOOTNODE + VALIDATOR (with QBFT consensus)"
echo "Database format: UNCHANGED (keeping current format)"
echo "Parallel processing: DISABLED (can enable later)"
echo "EIP activation: SCHEDULED for future blocks"
echo ""
echo "RPC APIs enabled: ETH,NET,WEB3,QBFT,ADMIN,DEBUG,TRACE,TXPOOL"
echo "Mining: ENABLED (required for validators)"
echo "Discovery: ENABLED (required for bootnodes)"
echo "Max peers: 50 (higher for bootnodes)"
echo ""
read -n 1 -s -r -p "Press any key to continue..."
echo
