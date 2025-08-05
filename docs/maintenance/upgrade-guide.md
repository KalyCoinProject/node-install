# KalyChain Node Upgrade Guide

This guide provides comprehensive instructions for upgrading your KalyChain node to the latest version.

> **⚠️ Important:** Always backup your node data and configuration before performing any upgrade!

## 📋 Table of Contents

- [Prerequisites](#prerequisites)
- [Backup Procedures](#backup-procedures)
- [Upgrade Methods](#upgrade-methods)
  - [Automated Upgrade (Recommended)](#automated-upgrade-recommended)
  - [Manual Upgrade](#manual-upgrade)
- [Post-Upgrade Verification](#post-upgrade-verification)
- [Troubleshooting](#troubleshooting)
- [Rollback Procedures](#rollback-procedures)

---

## Prerequisites

### System Requirements

- **Java 21** (OpenJDK recommended)
- **Sufficient disk space** (at least 10GB free)
- **Network connectivity** to download new binaries
- **Root/sudo access** for service management

### Pre-Upgrade Checklist

- [ ] Node is currently running and synced
- [ ] Recent backup of validator keys (if applicable)
- [ ] Backup of current configuration
- [ ] Maintenance window scheduled
- [ ] Monitoring alerts configured

---

## Backup Procedures

### Automated Backup

Use our backup script for comprehensive backup:

```bash
# Run the backup script
./scripts/maintenance/backup-node.sh
```

### Manual Backup

If you prefer manual backup:

```bash
# Create backup directory
mkdir -p ~/backups/$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=~/backups/$(date +%Y%m%d_%H%M%S)

# Backup configuration
cp -r ~/node-install/configs $BACKUP_DIR/
cp /etc/systemd/system/kaly.service $BACKUP_DIR/

# Backup validator keys (if applicable)
if [ -f ~/node/data/key ]; then
    cp ~/node/data/key* $BACKUP_DIR/
    cp ~/node/data/nodeAddress $BACKUP_DIR/
fi

# Backup genesis file
cp ~/node/genesis.json $BACKUP_DIR/
```

---

## Upgrade Methods

### Automated Upgrade (Recommended)

The automated upgrade script handles the entire process safely:

```bash
# Navigate to repository
cd ~/node-install

# Run the upgrade script
./scripts/upgrade/upgrade.sh
```

**What the script does:**
1. ✅ Checks prerequisites (Java 21, disk space)
2. ✅ Creates automatic backups
3. ✅ Downloads latest Besu binary
4. ✅ Stops the node service safely
5. ✅ Replaces binary and libraries
6. ✅ Updates configuration if needed
7. ✅ Starts the service
8. ✅ Verifies successful upgrade

### Manual Upgrade

For advanced users who prefer manual control:

#### Step 1: Prepare for Upgrade

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install/verify Java 21
sudo apt install openjdk-21-jre-headless -y
java -version  # Should show OpenJDK 21
```

#### Step 2: Download New Binary

```bash
# Download latest Besu release
cd /tmp
wget https://github.com/KalyCoinProject/kalychain/releases/download/25.7.0/besu-25.7.0.zip

# Verify download
ls -la besu-25.7.0.zip

# Extract archive
unzip besu-25.7.0.zip
```

#### Step 3: Stop Node Service

```bash
# Stop the node service
sudo systemctl stop kaly.service

# Verify it's stopped
sudo systemctl status kaly.service
```

#### Step 4: Backup Current Installation

```bash
# Backup current binary
sudo cp ~/besu/bin/besu ~/besu/bin/besu.backup.$(date +%Y%m%d)

# Backup current libraries
sudo cp -r ~/besu/lib ~/besu/lib.backup.$(date +%Y%m%d)
```

#### Step 5: Install New Binary

```bash
# Remove old binary and libraries
sudo rm -rf ~/besu/bin ~/besu/lib

# Install new binary and libraries
sudo cp -r /tmp/besu-25.7.0/bin ~/besu/
sudo cp -r /tmp/besu-25.7.0/lib ~/besu/

# Fix permissions
sudo chown -R $USER:$USER ~/besu/bin ~/besu/lib
sudo chmod +x ~/besu/bin/besu
```

#### Step 6: Update Configuration

```bash
# Update genesis file if needed (check release notes)
# cp ~/node-install/configs/[node-type]/genesis.json ~/node/genesis.json

# Update service configuration if needed
# sudo systemctl daemon-reload
```

#### Step 7: Start Node Service

```bash
# Start the service
sudo systemctl start kaly.service

# Enable auto-start
sudo systemctl enable kaly.service
```

---

## Post-Upgrade Verification

### Check Service Status

```bash
# Verify service is running
sudo systemctl status kaly.service

# Check recent logs
sudo journalctl -u kaly.service -n 20 --no-pager
```

### Verify Node Operation

```bash
# Check node status
./scripts/maintenance/check-status.sh

# Test RPC (if enabled)
curl -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
     http://localhost:8545
```

### Monitor Sync Progress

```bash
# Watch logs in real-time
sudo journalctl -u kaly.service -f

# Look for sync progress messages
# Expected: "Imported block" messages
```

---

## Troubleshooting

### Service Won't Start

1. **Check Java version:**
   ```bash
   java -version
   # Should show OpenJDK 21
   ```

2. **Verify binary permissions:**
   ```bash
   ls -la ~/besu/bin/besu
   # Should be executable
   ```

3. **Check configuration paths:**
   ```bash
   sudo systemctl cat kaly.service
   # Verify all paths are correct
   ```

### Node Not Syncing

1. **Check network connectivity:**
   ```bash
   # Test bootnode connectivity
   telnet 169.197.143.193 30303
   telnet 169.197.143.209 30303
   ```

2. **Verify genesis file:**
   ```bash
   # Compare with repository version
   diff ~/node/genesis.json ~/node-install/configs/[node-type]/genesis.json
   ```

### Performance Issues

1. **Check system resources:**
   ```bash
   # Monitor CPU and memory
   htop

   # Check disk I/O
   iostat -x 1
   ```

2. **Review configuration:**
   - Ensure adequate memory allocation
   - Verify SSD storage usage
   - Check network bandwidth

---

## Rollback Procedures

If the upgrade fails, you can rollback to the previous version:

### Automatic Rollback

```bash
# Stop current service
sudo systemctl stop kaly.service

# Restore from backup
sudo cp ~/besu/bin/besu.backup.* ~/besu/bin/besu
sudo cp -r ~/besu/lib.backup.* ~/besu/lib

# Fix permissions
sudo chown -R $USER:$USER ~/besu/bin ~/besu/lib
sudo chmod +x ~/besu/bin/besu

# Start service
sudo systemctl start kaly.service
```

### Verify Rollback

```bash
# Check service status
sudo systemctl status kaly.service

# Verify version
~/besu/bin/besu --version
```

---

## Support

Need help with upgrades?

- 📖 **Documentation:** [Troubleshooting Guide](troubleshooting.md)
- 💬 **Discord:** [KalyChain Community](https://discord.gg/bvtm6dUf)
- 📱 **Telegram:** [Support Group](https://t.me/+yj8Ae9lNXmg1Yzkx)
- 🐛 **Issues:** [GitHub Issues](https://github.com/KalyCoinProject/node-install/issues)

---

## Version History

| Version | Release Date | Key Changes |
|---------|--------------|-------------|
| 25.7.0 | 2024-01-XX | Latest stable release |
| 22.10.3 | 2023-XX-XX | Previous stable release |

> **Note:** Always check the [release notes](https://github.com/KalyCoinProject/kalychain/releases) for version-specific upgrade instructions.