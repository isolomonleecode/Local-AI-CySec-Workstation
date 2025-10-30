#!/bin/bash

# Stop Stack Script
# Stops all Local AI Cybersecurity Workstation services

set -e

echo "========================================="
echo " Local AI CySec Workstation - Stop"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to stop service
stop_service() {
    echo -n "Stopping $1... "
    if sudo systemctl stop "$1" 2>/dev/null; then
        echo -e "${GREEN}✓${NC}"
        return 0
    else
        echo -e "${RED}✗${NC} (may not be running)"
        return 1
    fi
}

# Stop all services
stop_service "big-agi.service"
stop_service "chromium-debug.service"
stop_service "localai.service"

echo ""
echo -e "${GREEN}All services stopped.${NC}"
echo ""
echo "To start again, run:"
echo "  ./scripts/start-stack.sh"
echo ""
