#!/bin/bash
# Fix Local AI CySec Workstation Services
# Addresses issues found in verification report

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "=========================================="
echo "Local AI CySec Workstation - Service Fixes"
echo "=========================================="
echo ""

# Check if running as root for systemd operations
if [[ $EUID -ne 0 && "$1" != "--user-fixes" ]]; then
   echo -e "${YELLOW}⚠${NC}  Some fixes require root privileges"
   echo "Run with sudo for full fixes, or --user-fixes for user-level only"
   echo ""
fi

echo "Verification Summary:"
echo "✅ LocalAI Docker container: Running"
echo "✅ Chromium debug service: Working"
echo "❌ big-AGI service: Path error"
echo ""

# Fix 1: Find big-AGI installation
echo "=================================================="
echo "Fix 1: Locate big-AGI Installation"
echo "==================================================  "
echo ""

BIG_AGI_SEARCH=$(find /run/media/ssjlox/gamer -name "big-AGI" -type d 2>/dev/null | head -1)

if [ -n "$BIG_AGI_SEARCH" ]; then
    echo -e "${GREEN}✓${NC} Found big-AGI at: $BIG_AGI_SEARCH"
    BIG_AGI_PATH="$BIG_AGI_SEARCH"
elif [ -d "/run/media/ssjlox/gamer/localAI/big-AGI" ]; then
    echo -e "${GREEN}✓${NC} big-AGI exists at expected path"
    BIG_AGI_PATH="/run/media/ssjlox/gamer/localAI/big-AGI"
else
    echo -e "${RED}✗${NC} big-AGI not found"
    echo ""
    echo "Would you like to install big-AGI? (y/n)"
    read -r INSTALL_CHOICE

    if [[ "$INSTALL_CHOICE" =~ ^[Yy]$ ]]; then
        echo "Installing big-AGI..."
        mkdir -p /run/media/ssjlox/gamer/localAI
        cd /run/media/ssjlox/gamer/localAI
        git clone https://github.com/enricoros/big-AGI.git
        cd big-AGI
        npm install
        echo -e "${GREEN}✓${NC} big-AGI installed"
        BIG_AGI_PATH="/run/media/ssjlox/gamer/localAI/big-AGI"
    else
        echo "Skipping big-AGI installation"
        BIG_AGI_PATH=""
    fi
fi

# Fix 2: Update big-AGI service file
if [ -n "$BIG_AGI_PATH" ] && [[ $EUID -eq 0 ]]; then
    echo ""
    echo "=================================================="
    echo "Fix 2: Update big-AGI Service Path"
    echo "=================================================="
    echo ""

    echo "Updating big-AGI service file..."

    cat > /etc/systemd/system/big-agi.service <<EOF
[Unit]
Description=big-AGI Web Application
After=network.target localai.service

[Service]
Type=simple
User=ssjlox
WorkingDirectory=$BIG_AGI_PATH
Environment="NODE_ENV=production"
ExecStart=/usr/bin/npm run dev
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    echo -e "${GREEN}✓${NC} Service file updated with correct path"

    systemctl daemon-reload
    echo -e "${GREEN}✓${NC} Systemd reloaded"
fi

# Fix 3: Update LocalAI service image tag
if [[ $EUID -eq 0 ]]; then
    echo ""
    echo "=================================================="
    echo "Fix 3: Update LocalAI Service Image Tag"
    echo "=================================================="
    echo ""

    echo "Updating LocalAI service to match running container..."

    cat > /etc/systemd/system/localai.service <<EOF
[Unit]
Description=LocalAI Docker Container
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStartPre=-/usr/bin/docker stop local-ai
ExecStartPre=-/usr/bin/docker rm local-ai
ExecStart=/usr/bin/docker run --name local-ai -p 8080:8080 --device=/dev/kfd --device=/dev/dri --group-add=video localai/localai:latest-gpu-hipblas
ExecStop=/usr/bin/docker stop local-ai
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

    echo -e "${GREEN}✓${NC} LocalAI service updated with correct image tag"

    systemctl daemon-reload
    echo -e "${GREEN}✓${NC} Systemd reloaded"
fi

# Fix 4: Enable services
if [[ $EUID -eq 0 ]]; then
    echo ""
    echo "=================================================="
    echo "Fix 4: Enable Services"
    echo "=================================================="
    echo ""

    echo "Enabling LocalAI service..."
    systemctl enable localai.service
    echo -e "${GREEN}✓${NC} LocalAI service enabled"

    if [ -n "$BIG_AGI_PATH" ]; then
        echo "Starting big-AGI service..."
        systemctl start big-agi.service
        sleep 3

        if systemctl is-active --quiet big-agi.service; then
            echo -e "${GREEN}✓${NC} big-AGI service started successfully"
        else
            echo -e "${YELLOW}⚠${NC}  big-AGI service failed to start"
            echo "Check logs: journalctl -u big-agi.service -n 50"
        fi
    fi
fi

# Fix 5: Sync service configs to project
echo ""
echo "=================================================="
echo "Fix 5: Sync Service Configs to Project"
echo "=================================================="
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

if [[ $EUID -eq 0 ]]; then
    echo "Copying service files to project configs..."

    mkdir -p "$PROJECT_DIR/configs/systemd"

    cp /etc/systemd/system/localai.service "$PROJECT_DIR/configs/systemd/"
    cp /etc/systemd/system/big-agi.service "$PROJECT_DIR/configs/systemd/"
    cp /etc/systemd/system/chromium-debug.service "$PROJECT_DIR/configs/systemd/"

    chown ssjlox:ssjlox "$PROJECT_DIR/configs/systemd/"*.service

    echo -e "${GREEN}✓${NC} Service files synced to project"
else
    echo -e "${YELLOW}⚠${NC}  Skipping sync (requires root)"
    echo "Run with sudo to sync service files"
fi

# Summary
echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""

if [[ $EUID -eq 0 ]]; then
    echo "Services Status:"
    systemctl is-active localai.service && echo -e "${GREEN}✓${NC} LocalAI: Active" || echo -e "${YELLOW}⚠${NC}  LocalAI: Inactive"
    systemctl is-active chromium-debug.service && echo -e "${GREEN}✓${NC} Chromium: Active" || echo -e "${RED}✗${NC} Chromium: Inactive"
    systemctl is-active big-agi.service && echo -e "${GREEN}✓${NC} big-AGI: Active" || echo -e "${YELLOW}⚠${NC}  big-AGI: Inactive"
    echo ""

    echo "Enabled Status:"
    systemctl is-enabled localai.service && echo -e "${GREEN}✓${NC} LocalAI: Enabled" || echo -e "${YELLOW}⚠${NC}  LocalAI: Disabled"
    systemctl is-enabled chromium-debug.service && echo -e "${GREEN}✓${NC} Chromium: Enabled" || echo -e "${YELLOW}⚠${NC}  Chromium: Disabled"
    systemctl is-enabled big-agi.service && echo -e "${GREEN}✓${NC} big-AGI: Enabled" || echo -e "${YELLOW}⚠${NC}  big-AGI: Disabled"
else
    echo "Run with sudo to see service status"
fi

echo ""
echo "Next Steps:"
echo "1. Test LocalAI: curl http://localhost:8080/v1/models"
echo "2. Test Chromium: curl http://localhost:9222/json/version"
if [ -n "$BIG_AGI_PATH" ]; then
    echo "3. Test big-AGI: Open http://localhost:3000 in browser"
fi
echo ""
echo "For detailed report, see: VERIFICATION_REPORT.md"
echo ""
