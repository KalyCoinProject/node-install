# Prerequisites

Before installing any KalyChain node, ensure your system meets the following requirements.

## System Requirements

### Operating System
- **Ubuntu 20.04 LTS 64-bit** (recommended)
- Other Linux distributions may work but are not officially supported

### Hardware Requirements

| Component | Minimum | Recommended | Enterprise |
|-----------|---------|-------------|------------|
| **CPU** | 2 cores | 4 cores | 8+ cores |
| **RAM** | 4 GB | 8 GB | 16+ GB |
| **Storage** | 100 GB SSD | 500 GB SSD | 1+ TB NVMe |
| **Network** | 10 Mbps | 100 Mbps | 1+ Gbps |

### Software Requirements

- **Java 21** (OpenJDK recommended)
- **Git** (for cloning repositories)
- **Wget** or **Curl** (for downloading files)
- **Unzip** (for extracting archives)

## Network Configuration

### Required Ports

#### All Node Types
| Port | Protocol | Direction | Purpose |
|------|----------|-----------|---------|
| 30303 | TCP/UDP | Inbound/Outbound | P2P networking and discovery |

#### RPC Nodes (Additional)
| Port | Protocol | Direction | Purpose |
|------|----------|-----------|---------|
| 8545 | TCP | Inbound | HTTP RPC API |
| 8546 | TCP | Inbound | WebSocket RPC API |

### Firewall Configuration

Ensure your firewall allows the required ports. For Ubuntu with UFW:

```bash
# Allow SSH (adjust port if using custom SSH port)
sudo ufw allow 22/tcp

# Allow P2P networking
sudo ufw allow 30303

# For RPC nodes, also allow:
sudo ufw allow 8545
sudo ufw allow 8546

# Enable firewall
sudo ufw enable
```

## Security Considerations

> **⚠️ Important:** Always complete the [Server Setup](server-setup.md) guide before installing any node type.

### Essential Security Steps
1. **Disable root login** and use a non-root user with sudo privileges
2. **Use SSH key authentication** instead of passwords
3. **Configure firewall** to only allow necessary ports
4. **Enable automatic security updates**
5. **Install fail2ban** to prevent brute force attacks

### For Validator Nodes
- **Secure private keys** - Validator keys are not encrypted by default
- **Regular backups** of keys and configuration
- **Monitor node uptime** to avoid penalties
- **Use hardware security modules** for production environments

## Installation Order

1. **Server Setup** - Complete security hardening first
2. **Choose Node Type** - Validator, Regular, or RPC
3. **Follow Installation Guide** - Use the appropriate guide for your node type
4. **Configure Monitoring** - Set up logging and monitoring
5. **Test Configuration** - Verify everything works correctly

## Next Steps

Once you've verified your system meets these prerequisites:

1. [🛡️ Server Setup](server-setup.md) - Security hardening (required)
2. Choose your installation guide:
   - [🔐 Validator Node](validator-node.md)
   - [🌐 Regular Node](regular-node.md)
   - [🔌 RPC Node](rpc-node.md)

## Support

If you encounter issues with prerequisites:
- 💬 [Discord Community](https://discord.gg/bvtm6dUf)
- 📱 [Telegram Support](https://t.me/+yj8Ae9lNXmg1Yzkx)
- 🐛 [GitHub Issues](https://github.com/KalyCoinProject/node-install/issues)
