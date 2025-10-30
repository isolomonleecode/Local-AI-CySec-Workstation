#!/bin/bash

# Start Stack Script
# Starts all Local AI Cybersecurity Workstation services

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "========================================="
echo " Local AI CySec Workstation - Start"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if service is running
check_service() {
    if systemctl is-active --quiet "$1"; then
        echo -e "${GREEN}✓${NC} $1 is running"
        return 0
    else
        echo -e "${RED}✗${NC} $1 is not running"
        return 1
    fi
}

# Function to start service
start_service() {
    echo -n "Starting $1... "
    if sudo systemctl start "$1"; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC}"
        return 1
    fi
}

# Check if services are already running
echo "Checking current service status..."
echo ""

LOCALAI_RUNNING=$(check_service "localai.service" && echo "true" || echo "false")
CHROMIUM_RUNNING=$(check_service "chromium-debug.service" && echo "true" || echo "false")
BIGAGI_RUNNING=$(check_service "big-agi.service" && echo "true" || echo "false")

echo ""

# Start services if not running
if [ "$LOCALAI_RUNNING" = "false" ]; then
    start_service "localai.service"
    echo "Waiting for LocalAI to initialize (30s)..."
    sleep 30
fi

if [ "$CHROMIUM_RUNNING" = "false" ]; then
    start_service "chromium-debug.service"
    sleep 5
fi

if [ "$BIGAGI_RUNNING" = "false" ]; then
    start_service "big-agi.service"
    echo "Waiting for big-AGI to start (15s)..."
    sleep 15
fi

echo ""
echo "========================================="
echo " Service Status"
echo "========================================="
echo ""

# Final status check
check_service "localai.service"
check_service "chromium-debug.service"
check_service "big-agi.service"

echo ""
echo "========================================="
echo " Endpoint Status"
echo "========================================="
echo ""

# Test endpoints
echo -n "LocalAI API (http://localhost:8080): "
if curl -s http://localhost:8080/readyz > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Online${NC}"
else
    echo -e "${RED}✗ Offline${NC}"
fi

echo -n "Chromium Debug (http://localhost:9222): "
if curl -s http://localhost:9222/json > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Online${NC}"
else
    echo -e "${RED}✗ Offline${NC}"
fi

echo -n "big-AGI Web UI (http://localhost:3000): "
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Online${NC}"
else
    echo -e "${RED}✗ Offline${NC}"
fi

echo ""
echo "========================================="
echo " GPU Status"
echo "========================================="
echo ""

if command -v rocm-smi &> /dev/null; then
    rocm-smi --showproductname --showuse
else
    echo -e "${YELLOW}⚠${NC} rocm-smi not found (GPU status unavailable)"
fi

echo ""
echo "========================================="
echo " Access Information"
echo "========================================="
echo ""
echo "🌐 big-AGI Web Interface: http://localhost:3000"
echo "🤖 LocalAI API Endpoint:  http://localhost:8080"
echo "🔍 Chromium Debug Port:   http://localhost:9222"
echo ""
echo "📊 View logs:"
echo "  sudo journalctl -u localai.service -f"
echo "  sudo journalctl -u big-agi.service -f"
echo ""
echo "🛑 Stop all services:"
echo "  $SCRIPT_DIR/stop-stack.sh"
echo ""
echo -e "${GREEN}Local AI Workstation is ready!${NC}"
echo ""
