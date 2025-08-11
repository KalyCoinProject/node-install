#!/bin/bash

# KalyChain Node Backup Script
# Creates backups of important node data and configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BACKUP_DIR="$HOME/backups"
DATE=$(date +%Y%m%d_%H%M%S)
SERVICE_NAME="kaly"

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

create_backup_dir() {
    log_info "Creating backup directory..."
    mkdir -p "$BACKUP_DIR"
    log_success "Backup directory created: $BACKUP_DIR"
}

backup_configuration() {
    log_info "Backing up configuration files..."
    
    # Create config backup directory
    mkdir -p "$BACKUP_DIR/config_$DATE"
    
    # Backup node configuration
    if [ -d "$HOME/node-install/configs" ]; then
        cp -r "$HOME/node-install/configs" "$BACKUP_DIR/config_$DATE/"
        log_success "Configuration files backed up"
    else
        log_warning "Configuration directory not found"
    fi
    
    # Backup systemd service file
    if [ -f "/etc/systemd/system/$SERVICE_NAME.service" ]; then
        sudo cp "/etc/systemd/system/$SERVICE_NAME.service" "$BACKUP_DIR/config_$DATE/"
        log_success "Service file backed up"
    fi
}

backup_keys() {
    log_info "Backing up validator keys (if present)..."
    
    if [ -d "$HOME/node/data" ]; then
        mkdir -p "$BACKUP_DIR/keys_$DATE"
        
        # Backup validator keys
        if [ -f "$HOME/node/data/key" ]; then
            cp "$HOME/node/data/key" "$BACKUP_DIR/keys_$DATE/"
            cp "$HOME/node/data/key.pub" "$BACKUP_DIR/keys_$DATE/" 2>/dev/null || true
            cp "$HOME/node/data/nodeAddress" "$BACKUP_DIR/keys_$DATE/" 2>/dev/null || true
            log_success "Validator keys backed up"
        else
            log_info "No validator keys found (regular node)"
        fi
    else
        log_warning "Node data directory not found"
    fi
}

backup_genesis() {
    log_info "Backing up genesis file..."
    
    if [ -f "$HOME/node/genesis.json" ]; then
        mkdir -p "$BACKUP_DIR/genesis_$DATE"
        cp "$HOME/node/genesis.json" "$BACKUP_DIR/genesis_$DATE/"
        log_success "Genesis file backed up"
    else
        log_warning "Genesis file not found"
    fi
}

create_backup_info() {
    log_info "Creating backup information file..."
    
    cat > "$BACKUP_DIR/backup_info_$DATE.txt" << EOF
KalyChain Node Backup Information
================================
Date: $(date)
Node Type: $(if [ -f "$HOME/node/data/key" ]; then echo "Validator"; else echo "Regular/RPC"; fi)
Service Status: $(systemctl is-active $SERVICE_NAME.service 2>/dev/null || echo "unknown")
Besu Version: $($HOME/besu/bin/besu --version 2>/dev/null | head -1 || echo "unknown")
System: $(uname -a)

Backup Contents:
- Configuration files: $([ -d "$BACKUP_DIR/config_$DATE" ] && echo "Yes" || echo "No")
- Validator keys: $([ -d "$BACKUP_DIR/keys_$DATE" ] && echo "Yes" || echo "No")
- Genesis file: $([ -d "$BACKUP_DIR/genesis_$DATE" ] && echo "Yes" || echo "No")

Restore Instructions:
1. Stop the node service: sudo systemctl stop $SERVICE_NAME.service
2. Restore configuration: cp -r config_$DATE/configs/* ~/node-install/configs/
3. Restore keys (validators): cp keys_$DATE/* ~/node/data/
4. Restore genesis: cp genesis_$DATE/genesis.json ~/node/
5. Start the service: sudo systemctl start $SERVICE_NAME.service
EOF

    log_success "Backup information file created"
}

cleanup_old_backups() {
    log_info "Cleaning up old backups (keeping last 7 days)..."
    
    find "$BACKUP_DIR" -name "*_*" -type d -mtime +7 -exec rm -rf {} + 2>/dev/null || true
    find "$BACKUP_DIR" -name "backup_info_*.txt" -mtime +7 -delete 2>/dev/null || true
    
    log_success "Old backups cleaned up"
}

# Main execution
main() {
    log_info "Starting KalyChain node backup..."
    echo "========================================"
    
    create_backup_dir
    backup_configuration
    backup_keys
    backup_genesis
    create_backup_info
    cleanup_old_backups
    
    echo "========================================"
    log_success "Backup completed successfully!"
    log_info "Backup location: $BACKUP_DIR"
    log_info "Backup timestamp: $DATE"
    
    # Show backup size
    backup_size=$(du -sh "$BACKUP_DIR" | cut -f1)
    log_info "Total backup size: $backup_size"
}

# Run main function
main "$@"
