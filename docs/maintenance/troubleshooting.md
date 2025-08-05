# Troubleshooting Guide

This guide covers common issues and their solutions when running KalyChain nodes.

## Common Issues

### Node Won't Start

#### Symptoms
- Service fails to start
- Immediate exit after startup
- Error messages in logs

#### Solutions

1. **Check Java Version**
   ```bash
   java -version
   # Should show OpenJDK 21
   ```
   If wrong version, install Java 21:
   ```bash
   sudo apt update
   sudo apt install openjdk-21-jre-headless -y
   ```

2. **Verify File Permissions**
   ```bash
   # Check besu binary permissions
   ls -la ~/besu/bin/besu
   # Should be executable (-rwxr-xr-x)
   
   # Fix if needed
   chmod +x ~/besu/bin/besu
   ```

3. **Check Configuration Files**
   ```bash
   # Verify genesis file exists
   ls -la ~/node/genesis.json
   
   # Verify config file path in service
   sudo systemctl cat kaly.service
   ```

### Sync Issues

#### Node Not Syncing

1. **Check Network Connectivity**
   ```bash
   # Test bootnode connectivity
   telnet 169.197.143.193 30303
   telnet 169.197.143.209 30303
   ```

2. **Verify Bootnodes**
   ```bash
   # Check if bootnodes are in config
   grep -i bootnode ~/node-install/configs/*/config.toml
   ```

3. **Check Disk Space**
   ```bash
   df -h
   # Ensure sufficient space for blockchain data
   ```

#### Slow Sync

1. **Check System Resources**
   ```bash
   # Monitor CPU and memory usage
   htop
   
   # Check I/O wait
   iostat -x 1
   ```

2. **Optimize Configuration**
   - Increase memory allocation if available
   - Use SSD storage for better performance
   - Ensure stable internet connection

### RPC Issues

#### RPC Not Responding

1. **Check Service Status**
   ```bash
   sudo systemctl status kaly.service
   ```

2. **Test RPC Endpoint**
   ```bash
   curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
        http://localhost:8545
   ```

3. **Check Firewall**
   ```bash
   sudo ufw status
   # Ensure ports 8545 and 8546 are allowed
   ```

#### SSL Certificate Issues (RPC Nodes)

1. **Renew Let's Encrypt Certificate**
   ```bash
   sudo certbot renew
   sudo systemctl reload nginx
   ```

2. **Check Certificate Status**
   ```bash
   sudo certbot certificates
   ```

### Validator Issues

#### Not Earning Rewards

1. **Check Validator Status**
   ```bash
   # Get node info
   curl -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":1}' \
        http://localhost:8545
   ```

2. **Verify Validator Registration**
   - Check if your validator address appears on [KalyScan](https://kalyscan.io)
   - Ensure you've been voted in by existing validators

3. **Monitor Uptime**
   ```bash
   # Check service uptime
   sudo systemctl status kaly.service
   
   # Check logs for errors
   sudo journalctl -u kaly.service -f
   ```

## Log Analysis

### Viewing Logs

```bash
# Real-time logs
sudo journalctl -u kaly.service -f

# Last 100 lines
sudo journalctl -u kaly.service -n 100

# Logs from specific time
sudo journalctl -u kaly.service --since "2024-01-01 00:00:00"
```

### Common Log Messages

#### Normal Operation
```
INFO | PersistBlockTask | Imported block
INFO | EthScheduler | Block processing completed
```

#### Warning Signs
```
WARN | P2PNetwork | Peer disconnected
ERROR | BesuController | Failed to start
```

## Performance Optimization

### System Tuning

1. **Increase File Descriptors**
   ```bash
   # Add to /etc/security/limits.conf
   echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
   echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf
   ```

2. **Optimize Network Settings**
   ```bash
   # Add to /etc/sysctl.conf
   echo "net.core.rmem_max = 134217728" | sudo tee -a /etc/sysctl.conf
   echo "net.core.wmem_max = 134217728" | sudo tee -a /etc/sysctl.conf
   sudo sysctl -p
   ```

### Database Optimization

1. **Use SSD Storage**
   - Move data directory to SSD if using HDD
   - Ensure sufficient IOPS for database operations

2. **Regular Maintenance**
   ```bash
   # Check database size
   du -sh ~/node/data
   
   # Monitor growth rate
   df -h
   ```

## Recovery Procedures

### Corrupted Database

1. **Stop Node**
   ```bash
   sudo systemctl stop kaly.service
   ```

2. **Backup Current Data**
   ```bash
   mv ~/node/data ~/node/data.backup.$(date +%Y%m%d)
   ```

3. **Resync from Genesis**
   ```bash
   mkdir ~/node/data
   sudo systemctl start kaly.service
   ```

### Lost Configuration

1. **Restore from Repository**
   ```bash
   # Re-clone repository
   git clone https://github.com/KalyCoinProject/node-install.git
   
   # Copy configuration files
   cp node-install/configs/[node-type]/* ~/node/
   ```

## Getting Help

### Before Asking for Help

1. **Check logs** for error messages
2. **Verify system requirements** are met
3. **Test basic connectivity** to bootnodes
4. **Review recent changes** to configuration

### Support Channels

- 💬 **Discord:** [KalyChain Community](https://discord.gg/bvtm6dUf)
- 📱 **Telegram:** [Support Group](https://t.me/+yj8Ae9lNXmg1Yzkx)
- 🐛 **GitHub Issues:** [Report Bugs](https://github.com/KalyCoinProject/node-install/issues)

### Information to Include

When asking for help, please provide:
- Node type (validator/regular/RPC)
- Operating system and version
- Hardware specifications
- Error messages from logs
- Steps you've already tried
