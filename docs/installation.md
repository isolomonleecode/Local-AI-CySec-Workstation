# Installation Guide

This guide provides detailed step-by-step instructions for setting up the Local AI Cybersecurity Workstation.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [System Preparation](#system-preparation)
3. [AMD ROCm Installation](#amd-rocm-installation)
4. [Docker Setup](#docker-setup)
5. [LocalAI Installation](#localai-installation)
6. [big-AGI Installation](#big-agi-installation)
7. [Chromium Headless Setup](#chromium-headless-setup)
8. [Systemd Services Configuration](#systemd-services-configuration)
9. [Model Download](#model-download)
10. [Verification](#verification)
11. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Hardware Requirements
- **CPU:** 6+ cores (8+ recommended)
- **RAM:** 16GB minimum (32GB+ recommended)
- **GPU:** AMD Radeon RX 5000+ series with 8GB+ VRAM
- **Storage:** 100GB+ available SSD space
- **Network:** Internet connection for initial setup

### Software Requirements
- **OS:** Linux (Arch, Ubuntu 22.04+, Debian 12+, Fedora 38+)
- **Kernel:** 5.15+ (6.0+ recommended)
- **Docker:** 24.0+
- **Node.js:** 18.0+ (for big-AGI)
- **NPM:** 9.0+

### Supported AMD GPUs

**Tested:**
- RX 7900 XTX/XT
- RX 6900 XT
- RX 6800 XT/6800
- RX 5700 XT

**Should Work:**
- Any RDNA 2/3 GPU (RX 6000/7000 series)
- RDNA 1 GPUs (RX 5000 series) with limitations

**Not Recommended:**
- Vega series (limited ROCm support)
- Polaris (RX 400/500 series) - no ROCm support

---

## System Preparation

### Update System

**Arch Linux:**
```bash
sudo pacman -Syu
```

**Ubuntu/Debian:**
```bash
sudo apt update && sudo apt upgrade -y
```

**Fedora:**
```bash
sudo dnf upgrade -y
```

### Install Base Dependencies

**Arch Linux:**
```bash
sudo pacman -S base-devel git curl wget unzip docker nodejs npm chromium
```

**Ubuntu/Debian:**
```bash
sudo apt install -y build-essential git curl wget unzip docker.io nodejs npm chromium-browser
```

**Fedora:**
```bash
sudo dnf install -y @development-tools git curl wget unzip docker nodejs npm chromium
```

---

## AMD ROCm Installation

ROCm provides GPU acceleration for AMD graphics cards.

### Arch Linux

```bash
# Install ROCm from AUR (use yay or your preferred AUR helper)
yay -S rocm-hip-sdk rocm-opencl-sdk rocm-smi

# Add user to video and render groups
sudo usermod -aG video,render $USER

# Reboot to apply group changes
sudo reboot
```

### Ubuntu 22.04

```bash
# Add ROCm repository
wget https://repo.radeon.com/amdgpu-install/6.0/ubuntu/jammy/amdgpu-install_6.0.60000-1_all.deb
sudo apt install ./amdgpu-install_6.0.60000-1_all.deb

# Install ROCm
sudo amdgpu-install --usecase=rocm

# Add user to groups
sudo usermod -aG video,render $USER

# Reboot
sudo reboot
```

### Fedora 38+

```bash
# Add ROCm repository
sudo tee /etc/yum.repos.d/rocm.repo <<EOF
[ROCm]
name=ROCm
baseurl=https://repo.radeon.com/rocm/yum/6.0
enabled=1
gpgcheck=1
gpgkey=https://repo.radeon.com/rocm/rocm.gpg.key
EOF

# Install ROCm
sudo dnf install rocm-hip-sdk rocm-opencl-sdk rocm-smi

# Add user to groups
sudo usermod -aG video,render $USER

# Reboot
sudo reboot
```

### Verify ROCm Installation

```bash
# Check ROCm version
rocm-smi --version

# List GPUs
rocm-smi

# Check ROCm info
/opt/rocm/bin/rocminfo | grep "Agent"

# Expected output:
# Agent 1
#   Name:                    gfx1100 (or your GPU architecture)
#   ...
```

---

## Docker Setup

### Enable and Start Docker

```bash
# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add user to docker group (avoid sudo)
sudo usermod -aG docker $USER

# Reboot or re-login
newgrp docker

# Test Docker
docker run hello-world
```

### Configure Docker for AMD GPU

```bash
# Verify Docker can access GPU
docker run --rm --device=/dev/kfd --device=/dev/dri rocm/rocm-terminal rocm-smi

# Expected: Should show your GPU information
```

---

## LocalAI Installation

### Pull LocalAI Container

```bash
# Pull GPU-accelerated LocalAI image
docker pull localai/localai:latest-aio-gpu-hipblas

# Verify image
docker images | grep localai
```

### Test LocalAI (Manual Start)

```bash
# Run LocalAI manually for testing
docker run -d \
  --name local-ai-test \
  -p 8080:8080 \
  --device=/dev/kfd \
  --device=/dev/dri \
  --group-add=video \
  localai/localai:latest-aio-gpu-hipblas

# Check logs
docker logs -f local-ai-test

# Test API
curl http://localhost:8080/readyz

# Should return: OK

# Stop test container
docker stop local-ai-test
docker rm local-ai-test
```

---

## big-AGI Installation

### Clone big-AGI

```bash
# Create workspace directory
mkdir -p ~/ai-workstation
cd ~/ai-workstation

# Clone big-AGI repository
git clone https://github.com/enricoros/big-AGI.git
cd big-AGI

# Switch to v2-dev branch (latest features)
git checkout v2-dev
```

### Install Dependencies

```bash
# Install Node.js packages
npm install

# This may take 5-10 minutes
```

### Configure Environment

```bash
# Copy environment template
cp ~/Local-AI-CySec-Workstation/configs/big-agi/.env.example .env

# Edit configuration
vim .env

# Set:
# LOCALAI_API_HOST=http://127.0.0.1:8080
# LOCALAI_API_KEY=local-ai-key
# PUPPETEER_WSS_ENDPOINT=ws://localhost:9222
```

### Test big-AGI (Manual Start)

```bash
# Start development server
npm run dev

# Access at: http://localhost:3000

# Press Ctrl+C to stop
```

---

## Chromium Headless Setup

Chromium provides web browsing capabilities for OSINT and automated research.

### Install Chromium

Already installed in System Preparation step. Verify:

```bash
# Check Chromium version
chromium --version

# Should output: Chromium 120.0.xxxx
```

### Test Headless Mode

```bash
# Start Chromium in headless debug mode
chromium --remote-debugging-port=9222 --user-data-dir=/tmp/chromium-test --headless=new &

# Test connection
curl http://localhost:9222/json

# Should return JSON with browser info

# Kill test process
pkill chromium
```

---

## Systemd Services Configuration

Systemd services ensure all components start automatically on boot.

### Copy Service Files

```bash
# Copy service files from repository
cd ~/Local-AI-CySec-Workstation
sudo cp configs/systemd/*.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload
```

### Configure Service Paths

If your big-AGI path differs, edit the service file:

```bash
# Edit big-AGI service
sudo vim /etc/systemd/system/big-AGI-service.service

# Update WorkingDirectory to your path:
# WorkingDirectory=/home/YOUR_USER/ai-workstation/big-AGI
```

### Enable and Start Services

```bash
# Enable services (start on boot)
sudo systemctl enable localai.service
sudo systemctl enable chromium-debug.service
sudo systemctl enable big-AGI-service.service

# Start services
sudo systemctl start localai.service
sudo systemctl start chromium-debug.service
sudo systemctl start big-AGI-service.service
```

### Verify Services

```bash
# Check service status
systemctl status localai.service
systemctl status chromium-debug.service
systemctl status big-AGI-service.service

# All should show: active (running)

# Check logs
journalctl -u localai.service -f
journalctl -u big-AGI-service.service -f
```

---

## Model Download

### Download Models via LocalAI

```bash
# List available models
curl http://localhost:8080/v1/models

# Install Llama 3.1 8B (recommended for starting)
curl http://localhost:8080/models/apply \
  -X POST \
  -d '{"id": "huggingface@thebloke__llama-2-7b-chat-gguf__llama-2-7b-chat.Q4_K_M.gguf"}'

# Wait for download to complete (check logs)
docker logs -f local-ai
```

### Manual Model Download

```bash
# Create models directory
mkdir -p ~/.local/share/localai/models

# Download from Hugging Face
cd ~/.local/share/localai/models

# Llama 3.1 8B Instruct (Q4 quantization, ~4.6GB)
wget https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/resolve/main/llama-2-7b-chat.Q4_K_M.gguf

# CodeLlama 13B (for security code analysis, ~7.3GB)
wget https://huggingface.co/TheBloke/CodeLlama-13B-GGUF/resolve/main/codellama-13b.Q4_K_M.gguf

# Mistral 7B (fast general purpose, ~4.1GB)
wget https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_K_M.gguf
```

### Configure Models in LocalAI

```bash
# Create model config
cat > ~/.local/share/localai/models/llama-3.1-8b.yaml <<EOF
name: llama-3.1-8b-instruct
parameters:
  model: llama-2-7b-chat.Q4_K_M.gguf
  temperature: 0.7
  top_k: 40
  top_p: 0.9
  context_size: 4096
gpu_layers: 35
EOF

# Restart LocalAI to load models
sudo systemctl restart localai.service
```

---

## Verification

### Complete System Check

```bash
# 1. Check all services are running
systemctl status localai.service chromium-debug.service big-AGI-service.service

# 2. Test LocalAI API
curl http://localhost:8080/readyz
curl http://localhost:8080/v1/models

# 3. Test Chromium debug port
curl http://localhost:9222/json

# 4. Test big-AGI web interface
curl http://localhost:3000

# 5. Verify GPU usage
rocm-smi

# While running inference, GPU utilization should be >0%
```

### Web Interface Test

1. Open browser to `http://localhost:3000`
2. Click settings (gear icon)
3. Navigate to "AI Providers"
4. Select "LocalAI"
5. Enter: `http://localhost:8080`
6. Save settings
7. Start a new chat
8. Select a model from dropdown
9. Send a test message: "Hello, who are you?"

**Expected:** AI responds within 5-15 seconds (depending on model and GPU)

---

## Troubleshooting

### LocalAI Not Starting

**Check Docker logs:**
```bash
docker logs local-ai
journalctl -u localai.service -f
```

**Common issues:**
- **Port 8080 in use:** `sudo ss -tlnp | grep 8080`
- **GPU not accessible:** Check ROCm installation
- **Out of memory:** Reduce model size or gpu_layers

### big-AGI Connection Failed

**Check:**
```bash
# Verify LocalAI is accessible
curl http://localhost:8080/v1/models

# Check big-AGI logs
journalctl -u big-AGI-service.service -f

# Verify environment variables
cat ~/ai-workstation/big-AGI/.env
```

**Solution:**
- Restart big-AGI: `sudo systemctl restart big-AGI-service.service`
- Check `.env` file has correct LocalAI URL
- Ensure no firewall blocking localhost

### GPU Not Utilized

**Check ROCm:**
```bash
rocm-smi
/opt/rocm/bin/rocminfo

# Verify Docker GPU access
docker run --rm --device=/dev/kfd --device=/dev/dri rocm/rocm-terminal rocm-smi
```

**Solution:**
- Ensure user is in `video` and `render` groups: `groups $USER`
- Reboot after adding to groups
- Check kernel module: `lsmod | grep amdgpu`

### Model Loading Slow

**Optimize:**
- Use Q4 quantized models (faster, less VRAM)
- Reduce `context_size` in model config (2048 instead of 4096)
- Increase `gpu_layers` if you have VRAM headroom

### Out of Memory

**Solutions:**
- Use smaller models (7B instead of 13B/70B)
- Reduce `gpu_layers` in model config
- Close other GPU-intensive applications
- Increase system swap space

---

## Post-Installation

### Security Hardening

```bash
# Bind LocalAI to localhost only (edit service file)
sudo vim /etc/systemd/system/localai.service

# Change:
# -p 8080:8080
# To:
# -p 127.0.0.1:8080:8080

# Restart
sudo systemctl daemon-reload
sudo systemctl restart localai.service
```

### Performance Tuning

See [docs/performance-tuning.md](performance-tuning.md) for advanced optimization.

### Backup Configuration

```bash
# Create backup
./scripts/backup-configs.sh

# Backups saved to: ~/.local/share/ai-workstation-backups/
```

---

## Next Steps

- [Security Use Cases](security-use-cases.md) - Example cybersecurity workflows
- [Model Comparison](model-comparison.md) - Choose the right model
- [Performance Tuning](performance-tuning.md) - Optimize inference speed
- [API Integration](api-integration.md) - Integrate with security tools

---

**Installation Complete!** 🎉

You now have a fully functional local AI workstation for cybersecurity work.

Access big-AGI at: **http://localhost:3000**
