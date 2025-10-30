# Automation Scripts

This directory contains automation and management scripts for the Local AI Cybersecurity Workstation.

## Available Scripts

### Service Management

#### `start-stack.sh`
Starts all Local AI workstation services and verifies they're running.

**Usage:**
```bash
./scripts/start-stack.sh
```

**What it does:**
- Starts LocalAI, Chromium, and big-AGI services
- Waits for services to initialize
- Tests API endpoints
- Shows GPU status
- Displays access URLs

---

#### `stop-stack.sh`
Stops all Local AI workstation services.

**Usage:**
```bash
./scripts/stop-stack.sh
```

**What it does:**
- Gracefully stops all services
- Verifies shutdown

---

#### `restart-stack.sh`
Restarts all services (useful after config changes).

**Usage:**
```bash
./scripts/restart-stack.sh
```

---

### Installation & Setup

#### `install-dependencies.sh`
Installs all required dependencies for the workstation.

**Usage:**
```bash
./scripts/install-dependencies.sh
```

**What it installs:**
- Docker
- Node.js and NPM
- Chromium
- AMD ROCm drivers (if on supported distro)
- Git and build tools

**Supported OS:**
- Arch Linux
- Ubuntu 22.04+
- Debian 12+
- Fedora 38+

---

#### `install-rocm.sh`
Installs AMD ROCm drivers for GPU acceleration.

**Usage:**
```bash
./scripts/install-rocm.sh
```

**Note:** Requires reboot after installation.

---

### Model Management

#### `download-models.sh`
Downloads AI models from Hugging Face.

**Usage:**
```bash
./scripts/download-models.sh <model-name>
```

**Examples:**
```bash
# Download Llama 3.1 8B (recommended)
./scripts/download-models.sh llama-3.1-8b

# Download CodeLlama for security code review
./scripts/download-models.sh codellama-13b

# Download Mistral 7B (fast general purpose)
./scripts/download-models.sh mistral-7b

# Download all recommended models
./scripts/download-models.sh all
```

**Available Models:**
- `llama-3.1-8b` - General purpose (4.6GB)
- `llama-3.1-70b` - Advanced reasoning (38GB, requires 48GB+ VRAM)
- `codellama-7b` - Code analysis (4.1GB)
- `codellama-13b` - Advanced code analysis (7.3GB)
- `mistral-7b` - Fast general purpose (4.1GB)
- `deepseek-coder-6.7b` - Security code analysis (3.8GB)

---

#### `list-models.sh`
Lists all installed models and their sizes.

**Usage:**
```bash
./scripts/list-models.sh
```

---

### Maintenance

#### `update-stack.sh`
Updates all components to latest versions.

**Usage:**
```bash
./scripts/update-stack.sh
```

**What it updates:**
- LocalAI Docker image
- big-AGI from Git
- NPM dependencies
- System packages

**Includes:**
- Automatic backup before update
- Rollback option if update fails

---

#### `backup-configs.sh`
Backs up all configuration files.

**Usage:**
```bash
./scripts/backup-configs.sh
```

**What it backs up:**
- Systemd service files
- big-AGI `.env` file
- LocalAI model configs
- Custom personas
- Claude settings

**Backup location:** `~/.local/share/ai-workstation-backups/YYYY-MM-DD-HHMMSS/`

---

#### `restore-configs.sh`
Restores configuration from backup.

**Usage:**
```bash
# List available backups
./scripts/restore-configs.sh list

# Restore specific backup
./scripts/restore-configs.sh 2025-01-30-143022
```

---

### Diagnostics

#### `check-health.sh`
Performs comprehensive health check of the workstation.

**Usage:**
```bash
./scripts/check-health.sh
```

**Checks:**
- Service status
- API endpoint availability
- GPU detection and utilization
- Model availability
- Disk space
- Memory usage
- Network connectivity

**Output:** Detailed report with recommendations

---

#### `check-gpu.sh`
Detailed GPU diagnostics for troubleshooting.

**Usage:**
```bash
./scripts/check-gpu.sh
```

**Checks:**
- ROCm installation
- GPU detection
- Driver version
- VRAM availability
- Docker GPU passthrough
- Kernel modules

---

#### `show-logs.sh`
Display logs from all services.

**Usage:**
```bash
# Show all logs
./scripts/show-logs.sh

# Show specific service
./scripts/show-logs.sh localai
./scripts/show-logs.sh big-agi
./scripts/show-logs.sh chromium

# Follow logs (live tail)
./scripts/show-logs.sh localai --follow
```

---

### Benchmarking

#### `benchmark-inference.sh`
Benchmarks AI inference performance.

**Usage:**
```bash
./scripts/benchmark-inference.sh <model-name>
```

**Example:**
```bash
./scripts/benchmark-inference.sh llama-3.1-8b
```

**Measures:**
- Tokens per second
- First token latency
- Average response time
- VRAM usage
- GPU utilization

---

### Security Tools Integration

#### `ai-security-scan.sh`
Uses AI to analyze security scan results.

**Usage:**
```bash
# Analyze Trivy scan
./scripts/ai-security-scan.sh --trivy findings/adminer-scan.txt

# Analyze Nmap scan
./scripts/ai-security-scan.sh --nmap nmap-output.txt

# Analyze log file
./scripts/ai-security-scan.sh --logs /var/log/syslog
```

**Output:** AI-generated security analysis with:
- Vulnerability summary
- Risk assessment
- Remediation recommendations
- Detection signatures

---

## Script Development

### Adding New Scripts

1. Create script in `scripts/` directory
2. Add shebang: `#!/bin/bash`
3. Set executable: `chmod +x scripts/your-script.sh`
4. Add usage documentation in header
5. Update this README

### Script Template

```bash
#!/bin/bash
#
# Script Name - Brief description
#
# Usage: ./script-name.sh [options]
#
# Options:
#   -h, --help    Show help message
#   -v, --verbose Enable verbose output
#
# Examples:
#   ./script-name.sh
#   ./script-name.sh --verbose
#

set -e  # Exit on error

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            echo "Usage: $0 [options]"
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Script logic here
echo "Running script..."
```

### Best Practices

- ✅ Use `set -e` for error handling
- ✅ Validate inputs before execution
- ✅ Provide clear error messages
- ✅ Use colors for better readability
- ✅ Include usage documentation
- ✅ Make scripts idempotent where possible
- ✅ Test on multiple systems before committing

---

## Troubleshooting Scripts

### Script Permission Denied

```bash
# Make script executable
chmod +x scripts/script-name.sh
```

### Script Not Found

```bash
# Ensure you're in project root
cd ~/Local-AI-CySec-Workstation

# Or use absolute path
/full/path/to/scripts/script-name.sh
```

### Script Fails with "Command Not Found"

Check dependencies are installed:
```bash
./scripts/check-health.sh
```

---

## Contributing

When adding new scripts:
1. Follow the template above
2. Test thoroughly
3. Update this README
4. Add example usage
5. Document all options

---

## Related Documentation

- [Installation Guide](../docs/installation.md)
- [Configuration Guide](../configs/README.md)
- [Troubleshooting](../docs/troubleshooting.md)
