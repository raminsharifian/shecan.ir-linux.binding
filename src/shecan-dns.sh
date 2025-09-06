#!/bin/bash

set -e

# Check root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check for systemd
if [ ! -d /run/systemd ]; then
    echo "Error: This script requires systemd."
    exit 1
fi

# Check for systemd-resolved
if ! systemctl is-active systemd-resolved >/dev/null 2>&1; then
    echo "Error: systemd-resolved is not active. This script requires systemd-resolved."
    exit 1
fi

# Backup resolv.conf
backup_resolv() {
    if [ ! -f "/etc/resolv.conf.backup" ]; then
        cp /etc/resolv.conf /etc/resolv.conf.backup
        echo "Backup created: /etc/resolv.conf.backup"
    else
        echo "Backup already exists. Skipping to avoid overwriting."
    fi
}

# Configure systemd-resolved
configure_resolved() {
    local config_dir="/etc/systemd/resolved.conf.d"
    local shecan_conf="${config_dir}/shecan.conf"

    # Create config directory if it doesn't exist
    mkdir -p "$config_dir"

    # Create shecan configuration
    cat > "$shecan_conf" << EOF || { echo "Error: Failed to write $shecan_conf"; exit 1; }
[Resolve]
DNS=178.22.122.100 185.51.200.2
FallbackDNS=8.8.8.8
Domains=~.
EOF

    echo "Configuration created: $shecan_conf"
}

# Apply changes
apply_changes() {
    systemctl restart systemd-resolved || { echo "Error: Failed to restart systemd-resolved"; exit 1; }
    ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
    echo "Changes applied successfully"
}

# Main execution
main() {
    echo "Setting up Shecan DNS configuration..."
    backup_resolv
    configure_resolved
    apply_changes
    echo -e "\nVerification:"
    sleep 2
    resolvectl status
}

main "$@"