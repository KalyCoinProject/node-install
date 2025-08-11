# Configuration Files

This directory contains configuration files for different types of KalyChain nodes.

## Directory Structure

```
configs/
├── regular/          # Regular node configurations
├── validator/        # Validator node configurations
├── rpc/             # RPC node configurations
└── README.md        # This file
```

## Configuration Files

Each node type directory contains:

- **`config.toml`** - Main Besu configuration file
- **`genesis.json`** - Network genesis configuration
- **`log-config.xml`** - Logging configuration (optional)

## Node Types

### Regular Node (`regular/`)
- Syncs with the KalyChain network
- Maintains a copy of the blockchain
- Does not participate in consensus
- Basic RPC APIs enabled for local use

### Validator Node (`validator/`)
- Participates in network consensus
- Earns block rewards
- Requires validator keys
- Enhanced RPC APIs including QBFT consensus APIs

### RPC Node (`rpc/`)
- Provides public RPC/WebSocket APIs
- Optimized for high throughput
- Enhanced logging and monitoring
- Suitable for application backends

## Usage

### Using Configuration Files

1. **Copy the appropriate genesis file:**
   ```bash
   cp configs/[node-type]/genesis.json ~/node/genesis.json
   ```

2. **Reference in systemd service:**
   ```bash
   ExecStart=/home/$USER/besu/bin/besu --config-file=/home/$USER/node-install/configs/[node-type]/config.toml
   ```

3. **Enable logging (optional):**
   ```bash
   Environment=LOG4J_CONFIGURATION_FILE=/home/$USER/node-install/configs/[node-type]/log-config.xml
   ```

### Customization

You can customize these configurations for your specific needs:

1. **Network Settings:** Modify bootnodes, network ID, ports
2. **RPC APIs:** Enable/disable specific API modules
3. **Performance:** Adjust memory, cache sizes, thread pools
4. **Logging:** Configure log levels, rotation, output formats

### Important Notes

- **Never modify genesis.json** unless instructed by the KalyChain team
- **Backup configurations** before making changes
- **Test changes** on testnet before applying to mainnet
- **Keep configurations in sync** across your infrastructure

## Configuration Parameters

### Common Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `network-id` | KalyChain network identifier | 3888 |
| `p2p-port` | P2P networking port | 30303 |
| `data-path` | Blockchain data directory | data |
| `genesis-file` | Genesis configuration file | ./genesis.json |

### RPC Parameters

| Parameter | Description | Validator | Regular | RPC |
|-----------|-------------|-----------|---------|-----|
| `rpc-http-enabled` | Enable HTTP RPC | ✓ | ✓ | ✓ |
| `rpc-http-port` | HTTP RPC port | 8545 | 8545 | 8545 |
| `rpc-ws-enabled` | Enable WebSocket RPC | ✗ | ✗ | ✓ |
| `rpc-ws-port` | WebSocket RPC port | - | - | 8546 |

### API Modules

| Module | Description | Validator | Regular | RPC |
|--------|-------------|-----------|---------|-----|
| `ETH` | Ethereum JSON-RPC API | ✓ | ✓ | ✓ |
| `NET` | Network information | ✓ | ✓ | ✓ |
| `WEB3` | Web3 client version | ✓ | ✓ | ✓ |
| `QBFT` | QBFT consensus APIs | ✓ | ✗ | ✗ |
| `ADMIN` | Administrative APIs | ✓ | ✗ | ✗ |
| `DEBUG` | Debug APIs | ✓ | ✗ | ✗ |
| `TRACE` | Transaction tracing | ✓ | ✗ | ✓ |
| `TXPOOL` | Transaction pool APIs | ✓ | ✗ | ✓ |

## Security Considerations

- **Restrict RPC access** to trusted networks only
- **Use firewall rules** to limit port access
- **Enable authentication** for sensitive APIs
- **Monitor API usage** for unusual activity
- **Keep configurations updated** with security patches

## Support

For configuration help:
- 📖 [Documentation](../docs/)
- 💬 [Discord Community](https://discord.gg/bvtm6dUf)
- 🐛 [GitHub Issues](https://github.com/KalyCoinProject/node-install/issues)
