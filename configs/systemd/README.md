# Systemd Service Templates

This directory contains **template** files for systemd services. These templates use placeholders that are replaced with your system-specific values during configuration.

## Why Templates?

- **Privacy:** Don't commit usernames and paths to public repos
- **Portability:** Works on different systems with different paths
- **Security:** No hardcoded personal information

## Quick Start

### 1. Generate Service Files

Run the configuration script:

```bash
./scripts/configure-services.sh
```

This will:
- Auto-detect your username
- Search for big-AGI installation
- Generate `.service` files from templates
- Show you what was configured

### 2. Install Services

```bash
# Copy to systemd directory
sudo cp configs/systemd/*.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable services
sudo systemctl enable big-AGI-service chromium-debug

# Start services
sudo systemctl start big-AGI-service chromium-debug
```

### 3. Verify Services

```bash
# Check status
systemctl status big-AGI-service
systemctl status chromium-debug

# View logs
journalctl -u big-AGI-service -f
```

## Template Variables

Templates use these placeholders:

| Placeholder | Description | Example |
|-------------|-------------|---------|
| `{{USER}}` | Your username | `john` |
| `{{BIG_AGI_PATH}}` | big-AGI installation path | `/home/john/big-AGI` |

## Files

### Templates (committed to git)
- `big-AGI-service.service.template` - big-AGI web UI service
- `chromium-debug.service.template` - Headless Chromium service

### Generated (NOT committed to git)
- `big-AGI-service.service` - Your customized service
- `chromium-debug.service` - Your customized service

**Note:** `.service` files are in `.gitignore` to protect your privacy.

## Manual Configuration

If you prefer to configure manually:

### 1. Copy Template

```bash
cp configs/systemd/big-AGI-service.service.template \
   configs/systemd/big-AGI-service.service
```

### 2. Edit Variables

Open the file and replace:
- `{{USER}}` with your username
- `{{BIG_AGI_PATH}}` with your big-AGI path

### 3. Install

```bash
sudo cp configs/systemd/big-AGI-service.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable big-AGI-service
sudo systemctl start big-AGI-service
```

## Troubleshooting

### Service fails to start

```bash
# Check status
systemctl status big-AGI-service

# View detailed logs
journalctl -u big-AGI-service -n 50

# Check paths in service file
cat /etc/systemd/system/big-AGI-service.service
```

### Wrong user or path

1. Edit the `.service` file in `configs/systemd/`
2. Reinstall:
   ```bash
   sudo cp configs/systemd/big-AGI-service.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl restart big-AGI-service
   ```

### Auto-detection fails

Run the script with manual path input:

```bash
./scripts/configure-services.sh
# When prompted, enter your big-AGI path
```

## Docker vs Systemd

**Note:** This project primarily uses **Docker Compose** for deployment. Systemd services are optional and mainly for:

- Development environments
- Custom setups
- Systems without Docker

For production deployment, use Docker Compose instead:

```bash
docker-compose up -d
```

## Security Notes

- `.service` files contain your username and paths
- These files are **excluded from git** via `.gitignore`
- Only `.template` files are committed to the repository
- Never commit customized `.service` files to public repos

---

**Generated service files are user-specific and kept private.**
