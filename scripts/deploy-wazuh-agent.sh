#!/bin/bash
# Wazuh Agent 4.14.1 Deployment Script for Arch-based Systems
# Usage: sudo ./deploy-wazuh-agent.sh

set -e

WAZUH_MANAGER="192.168.0.52"
WAZUH_VERSION="4.14.1"

echo "=========================================="
echo "Wazuh Agent $WAZUH_VERSION Installer"
echo "Manager: $WAZUH_MANAGER"
echo "=========================================="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

# Check if already installed
if [ -d /var/ossec ] && [ -f /var/ossec/bin/wazuh-control ]; then
    echo "Wazuh already installed:"
    /var/ossec/bin/wazuh-control info | head -3
    read -p "Reinstall? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    /var/ossec/bin/wazuh-control stop 2>/dev/null || true
fi

# Download
echo ""
echo "[1/5] Downloading Wazuh Agent..."
cd /tmp
rm -f wazuh-agent_${WAZUH_VERSION}-1_amd64.deb
curl -sO https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_${WAZUH_VERSION}-1_amd64.deb
echo "Downloaded: $(ls -lh wazuh-agent_${WAZUH_VERSION}-1_amd64.deb | awk '{print $5}')"

# Extract
echo ""
echo "[2/5] Extracting package..."
rm -rf /tmp/wazuh-extract
mkdir -p /tmp/wazuh-extract
cd /tmp/wazuh-extract
ar x ../wazuh-agent_${WAZUH_VERSION}-1_amd64.deb
tar xzf data.tar.gz

# Install
echo ""
echo "[3/5] Installing to /var/ossec..."
cp -r var/ossec /var/

# Create user/group
echo ""
echo "[4/5] Setting up wazuh user..."
groupadd -r wazuh 2>/dev/null || true
useradd -r -g wazuh -d /var/ossec -s /sbin/nologin wazuh 2>/dev/null || true
chown -R wazuh:wazuh /var/ossec

# Configure
echo ""
echo "[5/5] Configuring agent..."
sed -i "s|<address>MANAGER_IP</address>|<address>$WAZUH_MANAGER</address>|g" /var/ossec/etc/ossec.conf

# Create systemd service
cat > /etc/systemd/system/wazuh-agent.service << 'EOF'
[Unit]
Description=Wazuh agent
Documentation=https://documentation.wazuh.com
After=network.target

[Service]
Type=forking
ExecStart=/var/ossec/bin/wazuh-control start
ExecStop=/var/ossec/bin/wazuh-control stop
ExecReload=/var/ossec/bin/wazuh-control reload
PIDFile=/var/ossec/var/run/wazuh-agentd.pid
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable wazuh-agent

# Start agent
echo ""
echo "Starting Wazuh agent..."
/var/ossec/bin/wazuh-control start

# Cleanup
rm -rf /tmp/wazuh-extract /tmp/wazuh-agent_${WAZUH_VERSION}-1_amd64.deb

echo ""
echo "=========================================="
echo "Installation complete!"
echo ""
/var/ossec/bin/wazuh-control info | head -3
/var/ossec/bin/wazuh-control status
echo ""
echo "Agent will auto-register with manager at $WAZUH_MANAGER"
echo "=========================================="
