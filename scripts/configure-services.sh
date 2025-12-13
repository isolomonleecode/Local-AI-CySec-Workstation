#!/bin/bash
# Configure systemd service files from templates
# This script replaces placeholders with actual values

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SYSTEMD_DIR="$PROJECT_DIR/configs/systemd"

echo -e "${GREEN}=== Systemd Service Configuration ===${NC}\n"

# Detect current user
CURRENT_USER="${USER:-$(whoami)}"
echo "Current user: $CURRENT_USER"

# Auto-detect big-AGI path
echo -e "\n${YELLOW}Searching for big-AGI installation...${NC}"

BIG_AGI_PATH=""
# Common locations to check
SEARCH_PATHS=(
    "$HOME/localAI/big-AGI"
    "$HOME/big-AGI"
    "/opt/big-AGI"
    "$(find "$HOME" -maxdepth 3 -name "big-AGI" -type d 2>/dev/null | head -1)"
)

for path in "${SEARCH_PATHS[@]}"; do
    if [ -d "$path" ] && [ -f "$path/package.json" ]; then
        BIG_AGI_PATH="$path"
        echo -e "${GREEN}Found big-AGI at: $BIG_AGI_PATH${NC}"
        break
    fi
done

if [ -z "$BIG_AGI_PATH" ]; then
    echo -e "${YELLOW}big-AGI not found automatically.${NC}"
    read -p "Enter big-AGI path (or press Enter to skip): " BIG_AGI_PATH
fi

# Process each template file
echo -e "\n${YELLOW}Processing service templates...${NC}"

for template in "$SYSTEMD_DIR"/*.template; do
    if [ -f "$template" ]; then
        # Get output filename (remove .template extension)
        output="${template%.template}"
        filename=$(basename "$output")

        echo -e "\n📝 Processing: $filename"

        # Read template
        content=$(cat "$template")

        # Replace placeholders
        content="${content//\{\{USER\}\}/$CURRENT_USER}"

        if [ -n "$BIG_AGI_PATH" ]; then
            content="${content//\{\{BIG_AGI_PATH\}\}/$BIG_AGI_PATH}"
        fi

        # Write output file
        echo "$content" > "$output"
        echo -e "${GREEN}✓ Generated: $output${NC}"

        # Show what was replaced
        echo "  User: $CURRENT_USER"
        if [ -n "$BIG_AGI_PATH" ]; then
            echo "  big-AGI path: $BIG_AGI_PATH"
        fi
    fi
done

echo -e "\n${GREEN}=== Configuration Complete ===${NC}\n"

# Instructions
echo "Next steps:"
echo "1. Review the generated .service files in: $SYSTEMD_DIR"
echo "2. Copy to systemd directory:"
echo "   sudo cp $SYSTEMD_DIR/*.service /etc/systemd/system/"
echo "3. Reload systemd:"
echo "   sudo systemctl daemon-reload"
echo "4. Enable and start services:"
echo "   sudo systemctl enable big-AGI-service chromium-debug"
echo "   sudo systemctl start big-AGI-service chromium-debug"
echo ""
echo -e "${YELLOW}Note: These .service files are in .gitignore and won't be committed.${NC}"
