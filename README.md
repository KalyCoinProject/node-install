<div align="center">

# 🔗 KalyChain Node Installation & Management

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![KalyChain](https://img.shields.io/badge/KalyChain-v25.7.0-blue.svg)](https://github.com/KalyCoinProject/kalychain)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%20LTS-orange.svg)](https://ubuntu.com/)
[![Java](https://img.shields.io/badge/Java-21-red.svg)](https://openjdk.org/)

**Professional installation and management tools for KalyChain blockchain nodes**

[🌐 KalyChain Website](https://kalychain.io/) • [📊 Block Explorer](http://kalyscan.io) • [💬 Discord](https://discord.gg/bvtm6dUf) • [📱 Telegram](https://t.me/+yj8Ae9lNXmg1Yzkx)

</div>

---

## 📋 Table of Contents

- [🔗 KalyChain Node Installation \& Management](#-kalychain-node-installation--management)
  - [📋 Table of Contents](#-table-of-contents)
  - [🎯 Overview](#-overview)
  - [📁 Repository Structure](#-repository-structure)
  - [⚙️ System Requirements](#️-system-requirements)
    - [Hardware Specifications](#hardware-specifications)
    - [Network Ports](#network-ports)
  - [🚀 Quick Start](#-quick-start)
  - [📖 Documentation](#-documentation)
  - [🛠️ Scripts \& Tools](#️-scripts--tools)
  - [🔧 Configuration Files](#-configuration-files)
  - [🔗 Important Links](#-important-links)
  - [🤝 Contributing](#-contributing)
  - [📞 Support](#-support)
  - [📄 License](#-license)

---

## 🎯 Overview

This repository provides comprehensive installation and management tools for KalyChain blockchain nodes. Whether you're setting up a validator, regular node, or RPC service, this toolkit includes everything you need for a professional deployment.

**Supported Node Types:**
- 🔐 **Validator Nodes** - Participate in consensus and earn rewards
- 🌐 **Regular Nodes** - Sync with the network and maintain blockchain data
- 🔌 **RPC Nodes** - Provide API access for applications and services

---

## 📁 Repository Structure

```
📦 kalychain-node-install/
├── 📚 docs/                    # Comprehensive documentation
│   ├── 🛠️ installation/        # Installation guides
│   ├── 🔧 maintenance/         # Upgrade and maintenance guides
│   └── ⚙️ configuration/       # Configuration documentation
├── 🚀 scripts/                 # Automation scripts
│   ├── 📦 install/             # Installation scripts
│   ├── ⬆️ upgrade/             # Upgrade scripts
│   └── 🔧 maintenance/         # Maintenance utilities
├── ⚙️ configs/                 # Configuration files
│   ├── 🔐 validator/           # Validator node configs
│   ├── 🌐 regular/             # Regular node configs
│   └── 🔌 rpc/                 # RPC node configs
├── 📋 templates/               # Service templates
│   └── 🖥️ systemd/            # SystemD service files
├── 📄 README.md                # This file
└── 📜 LICENSE                  # License information
```

---

## ⚙️ System Requirements

### Hardware Specifications

| Component | Minimum | Recommended | Enterprise |
|-----------|---------|-------------|------------|
| **CPU** | 2 cores | 4 cores | 8+ cores |
| **RAM** | 4 GB | 8 GB | 16+ GB |
| **Storage** | 100 GB SSD | 500 GB SSD | 1+ TB NVMe |
| **Network** | 10 Mbps | 100 Mbps | 1+ Gbps |

**Operating System:** Ubuntu 20.04 LTS 64-bit (recommended)

### Network Ports

#### Validator Nodes
| Port | Protocol | Direction | Purpose |
|------|----------|-----------|---------|
| 30303 | TCP/UDP | Inbound/Outbound | P2P networking and discovery |

#### Regular/RPC Nodes
| Port | Protocol | Direction | Purpose |
|------|----------|-----------|---------|
| 30303 | TCP/UDP | Inbound/Outbound | P2P networking and discovery |
| 8545 | TCP | Inbound | HTTP RPC API |
| 8546 | TCP | Inbound | WebSocket RPC API |

---

## 🚀 Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/KalyCoinProject/node-install.git
   cd node-install
   ```

2. **Set up your server** (security hardening)
   ```bash
   # Follow the server setup guide
   cat docs/installation/server-setup.md
   ```

3. **Choose your node type and follow the guide:**
   - 🔐 [Validator Node](docs/installation/validator-node.md)
   - 🌐 [Regular Node](docs/installation/regular-node.md)
   - 🔌 [RPC Node](docs/installation/rpc-node.md)

---

## 📖 Documentation

| Guide | Description |
|-------|-------------|
| [🛡️ Server Setup](docs/installation/server-setup.md) | Security hardening and server preparation |
| [🔐 Validator Node](docs/installation/validator-node.md) | Complete validator setup and configuration |
| [🌐 Regular Node](docs/installation/regular-node.md) | Standard node installation |
| [🔌 RPC Node](docs/installation/rpc-node.md) | RPC service setup with SSL |
| [⬆️ Upgrade Guide](docs/maintenance/upgrade-guide.md) | Node upgrade procedures |
| [🔧 Troubleshooting](docs/maintenance/troubleshooting.md) | Common issues and solutions |

---

## 🛠️ Scripts & Tools

| Script | Purpose |
|--------|---------|
| [`scripts/install/start-validator.sh`](scripts/install/start-validator.sh) | Validator node startup script |
| [`scripts/install/start-rpc.sh`](scripts/install/start-rpc.sh) | RPC node startup script |
| [`scripts/upgrade/upgrade.sh`](scripts/upgrade/upgrade.sh) | Automated upgrade script |

---

## 🔧 Configuration Files

Pre-configured files for different node types:

- **Validator:** [`configs/validator/`](configs/validator/)
- **Regular:** [`configs/regular/`](configs/regular/)
- **RPC:** [`configs/rpc/`](configs/rpc/)

Each configuration includes:
- `config.toml` - Besu configuration
- `genesis.json` - Network genesis file
- `log-config.xml` - Logging configuration

---

## 🔗 Important Links

| Resource | URL |
|----------|-----|
| 🌐 **KalyChain Website** | [kalychain.io](https://kalychain.io/) |
| 📊 **Mainnet Explorer** | [kalyscan.io](http://kalyscan.io) |
| 🧪 **Testnet Explorer** | [testnet.kalyscan.io](http://testnet.kalyscan.io/) |
| 📦 **Latest Release** | [GitHub Releases](https://github.com/KalyCoinProject/kalychain/releases/latest) |
| 💬 **Discord Community** | [Join Discord](https://discord.gg/bvtm6dUf) |
| 📱 **Telegram** | [Join Telegram](https://t.me/+yj8Ae9lNXmg1Yzkx) |

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📞 Support

Need help? We're here for you:

- 💬 **Discord:** [KalyChain Community](https://discord.gg/bvtm6dUf)
- 📱 **Telegram:** [Support Group](https://t.me/+yj8Ae9lNXmg1Yzkx)
- 🐛 **Issues:** [GitHub Issues](https://github.com/KalyCoinProject/node-install/issues)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ by the KalyChain Community**

[⭐ Star this repository](https://github.com/KalyCoinProject/node-install) if it helped you!

</div>
