#!/bin/bash

# Besu 25.7.0 Upgrade Script
# Run this script on each server after updating genesis.json and start scripts
# Usage: ./upgrade.sh

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BESU_VERSION="25.7.0"
BESU_URL="https://github.com/KalyCoinProject/kalychain/releases/download/${BESU_VERSION}/besu-${BESU_VERSION}.zip"
BESU_HOME="$HOME/besu"
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

check_prerequisites() {
    log_info "Checking prerequisites..."
    
    # Check if running as correct user (not root)
    if [ "$EUID" -eq 0 ]; then
        log_error "Do not run this script as root!"
        exit 1
    fi
    
    # Check if Java 21 is installed
    if ! java -version 2>&1 | grep -q "openjdk version \"21"; then
        log_warning "Java 21 not detected. Installing..."
        sudo apt update
        sudo apt install openjdk-21-jre-headless -y
        log_success "Java 21 installed"
    else
        log_success "Java 21 already installed"
    fi
    
    # Check if besu directory exists
    if [ ! -d "$BESU_HOME" ]; then
        log_error "Besu directory not found at $BESU_HOME"
        exit 1
    fi
    
    # Check if service exists
    if ! systemctl list-units --full -all | grep -Fq "$SERVICE_NAME.service"; then
        log_error "Service $SERVICE_NAME.service not found"
        exit 1
    fi
}

backup_current_installation() {
    log_info "Creating backup of current installation..."
    
    # Backup current binary and lib
    if [ -f "$BESU_HOME/bin/besu" ]; then
        sudo cp "$BESU_HOME/bin/besu" "$BESU_HOME/bin/besu.backup.$(date +%Y%m%d_%H%M%S)"
        log_success "Binary backed up"
    fi
    
    if [ -d "$BESU_HOME/lib" ]; then
        sudo cp -r "$BESU_HOME/lib" "$BESU_HOME/lib.backup.$(date +%Y%m%d_%H%M%S)"
        log_success "Lib directory backed up"
    fi
}

download_besu() {
    log_info "Downloading Besu $BESU_VERSION..."
    
    cd /tmp
    
    # Remove any existing download
    rm -f "besu-${BESU_VERSION}.zip"
    rm -rf "besu-${BESU_VERSION}"
    
    # Download new version
    wget "$BESU_URL"
    
    if [ ! -f "besu-${BESU_VERSION}.zip" ]; then
        log_error "Failed to download Besu $BESU_VERSION"
        exit 1
    fi
    
    # Extract
    unzip "besu-${BESU_VERSION}.zip"
    
    if [ ! -d "besu-${BESU_VERSION}" ]; then
        log_error "Failed to extract Besu $BESU_VERSION"
        exit 1
    fi
    
    log_success "Besu $BESU_VERSION downloaded and extracted"
}

stop_service() {
    log_info "Stopping $SERVICE_NAME service..."
    
    sudo systemctl stop "$SERVICE_NAME.service"
    
    # Wait a moment for clean shutdown
    sleep 3
    
    # Verify it's stopped
    if systemctl is-active --quiet "$SERVICE_NAME.service"; then
        log_error "Failed to stop $SERVICE_NAME service"
        exit 1
    fi
    
    log_success "Service stopped"
}

upgrade_besu() {
    log_info "Upgrading Besu installation..."
    
    # Remove old binary directory
    sudo rm -rf "$BESU_HOME/bin"
    
    # Copy new binary directory
    sudo cp -r "/tmp/besu-${BESU_VERSION}/bin" "$BESU_HOME/"
    
    # Remove old lib directory
    sudo rm -rf "$BESU_HOME/lib"
    
    # Copy new lib directory
    sudo cp -r "/tmp/besu-${BESU_VERSION}/lib" "$BESU_HOME/"
    
    # Fix permissions
    sudo chown -R $USER:$USER "$BESU_HOME/bin"
    sudo chown -R $USER:$USER "$BESU_HOME/lib"
    
    # Make binary executable
    sudo chmod +x "$BESU_HOME/bin/besu"
    
    log_success "Besu installation upgraded"
}

start_service() {
    log_info "Starting $SERVICE_NAME service with new configuration..."
    
    # Check if start script exists and is executable
    if [ -f "./scripts/install/start-validator.sh" ]; then
        chmod +x ./scripts/install/start-validator.sh
        ./scripts/install/start-validator.sh
        log_success "Service started with validator script"
    elif [ -f "./scripts/install/start-rpc.sh" ]; then
        chmod +x ./scripts/install/start-rpc.sh
        ./scripts/install/start-rpc.sh
        log_success "Service started with RPC script"
    else
        # Fallback to systemctl start
        sudo systemctl start "$SERVICE_NAME.service"
        log_success "Service started"
    fi
    
    # Wait for service to start
    sleep 5
}

verify_upgrade() {
    log_info "Verifying upgrade..."
    
    # Check service status
    if systemctl is-active --quiet "$SERVICE_NAME.service"; then
        log_success "Service is running"
    else
        log_error "Service failed to start!"
        log_info "Checking logs..."
        sudo journalctl -u "$SERVICE_NAME.service" -n 20 --no-pager
        exit 1
    fi
    
    # Check Besu version
    if "$BESU_HOME/bin/besu" --version | grep -q "$BESU_VERSION"; then
        log_success "Besu version verified: $BESU_VERSION"
    else
        log_warning "Could not verify Besu version"
    fi
    
    # Show recent logs
    log_info "Recent logs:"
    sudo journalctl -u "$SERVICE_NAME.service" -n 10 --no-pager
}

cleanup() {
    log_info "Cleaning up temporary files..."
    
    cd /tmp
    rm -f "besu-${BESU_VERSION}.zip"
    rm -rf "besu-${BESU_VERSION}"
    
    log_success "Cleanup completed"
}

# Main execution
main() {
    log_info "Starting Besu $BESU_VERSION upgrade process..."
    echo "========================================"
    
    check_prerequisites
    backup_current_installation
    download_besu
    stop_service
    upgrade_besu
    start_service
    verify_upgrade
    cleanup
    
    echo "========================================"
    log_success "Besu upgrade completed successfully!"
    log_info "Your node is now running Besu $BESU_VERSION"
    log_info "Monitor logs with: sudo journalctl -u $SERVICE_NAME.service -f"
}

# Run main function
main "$@"
