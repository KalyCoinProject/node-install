#!/bin/bash

# KalyChain Node Status Checker
# Provides comprehensive status information about your node

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SERVICE_NAME="kaly"

echo -e "${BLUE}=== KalyChain Node Status Check ===${NC}"
echo ""

# Check service status
echo -e "${BLUE}Service Status:${NC}"
if systemctl is-active --quiet "$SERVICE_NAME.service"; then
    echo -e "  Status: ${GREEN}RUNNING${NC}"
    uptime=$(systemctl show -p ActiveEnterTimestamp "$SERVICE_NAME.service" --value)
    echo -e "  Uptime: $uptime"
else
    echo -e "  Status: ${RED}STOPPED${NC}"
fi
echo ""

# Check system resources
echo -e "${BLUE}System Resources:${NC}"
echo -e "  CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo -e "  Memory Usage: $(free | grep Mem | awk '{printf("%.1f%%", $3/$2 * 100.0)}')"
echo -e "  Disk Usage: $(df -h / | awk 'NR==2{printf "%s", $5}')"
echo ""

# Check network connectivity
echo -e "${BLUE}Network Connectivity:${NC}"
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "  Internet: ${GREEN}CONNECTED${NC}"
else
    echo -e "  Internet: ${RED}DISCONNECTED${NC}"
fi

# Test bootnode connectivity
echo -e "  Bootnode 1: $(timeout 3 bash -c '</dev/tcp/169.197.143.193/30303' && echo -e "${GREEN}REACHABLE${NC}" || echo -e "${RED}UNREACHABLE${NC}")"
echo -e "  Bootnode 2: $(timeout 3 bash -c '</dev/tcp/169.197.143.209/30303' && echo -e "${GREEN}REACHABLE${NC}" || echo -e "${RED}UNREACHABLE${NC}")"
echo ""

# Check RPC if enabled
echo -e "${BLUE}RPC Status:${NC}"
if curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545 &> /dev/null; then
    block_number=$(curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://localhost:8545 | jq -r '.result')
    block_decimal=$((16#${block_number#0x}))
    echo -e "  RPC: ${GREEN}ACTIVE${NC}"
    echo -e "  Current Block: $block_decimal"
else
    echo -e "  RPC: ${RED}INACTIVE${NC}"
fi
echo ""

# Check recent logs
echo -e "${BLUE}Recent Logs (last 5 lines):${NC}"
sudo journalctl -u "$SERVICE_NAME.service" -n 5 --no-pager | tail -n 5
echo ""

# Check data directory size
if [ -d "$HOME/node/data" ]; then
    echo -e "${BLUE}Data Directory:${NC}"
    echo -e "  Size: $(du -sh $HOME/node/data | cut -f1)"
    echo -e "  Location: $HOME/node/data"
fi

echo ""
echo -e "${BLUE}=== Status Check Complete ===${NC}"
