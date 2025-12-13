# Local AI Cybersecurity Workstation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Security: CompTIA](https://img.shields.io/badge/Security-CompTIA%20Sec%2B-red)](https://www.comptia.org/certifications/security)

**GPU-accelerated, privacy-first AI workstation for cybersecurity professionals**

> 100% local AI processing • No cloud dependencies • Fully open source

---

## 🎯 Quick Start

```bash
# Clone the repository
git clone https://github.com/isolomonleecode/Local-AI-CySec-Workstation.git
cd Local-AI-CySec-Workstation

# Configure environment
cp .env.example .env
nano .env  # Edit with your settings

# Generate secure API keys
echo "LITELLM_MASTER_KEY=sk-$(openssl rand -hex 16)" >> .env
echo "LITELLM_SALT_KEY=sk-salt-$(openssl rand -hex 16)" >> .env

# Start AI services
docker-compose --profile ai up -d
```

**Access:**
- **big-AGI UI:** http://localhost:3000
- **Open-WebUI:** http://localhost:3001
- **LiteLLM API:** http://localhost:4000
- **LocalAI:** http://localhost:8080
- **n8n Automation:** http://localhost:5678

**📖 Complete deployment guide:** [DOCKER-COMPOSE-GUIDE.md](DOCKER-COMPOSE-GUIDE.md)

**📚 Full documentation and configs** are maintained in a centralized vault (not in this repo).

**Privacy Note:** Configuration files (systemd, LiteLLM, Prometheus, Promtail) have been moved to a private vault to protect environment-specific data.

---

## 🔥 Features

### 🤖 **Local AI Processing**
- **Privacy-First:** All AI processing on-premises
- **GPU-Accelerated:** AMD ROCm/HIP or NVIDIA CUDA for fast inference
- **Multi-Model:** Run multiple LLMs simultaneously
- **No API Costs:** Unlimited usage, zero per-token fees

### 🔐 **Security-Focused**
- **CVE Analysis:** AI-powered vulnerability assessment
- **Malware Analysis:** Safe local code analysis
- **Log Analysis:** Intelligent threat detection
- **Code Review:** Automated security audits
- **Incident Response:** Real-time alert automation

### 🛠️ **Integrated Stack**
- **LiteLLM:** Unified API for multiple AI models
- **LocalAI:** OpenAI-compatible local inference
- **big-AGI:** Advanced web interface
- **n8n:** Security automation workflows
- **Wazuh:** SIEM integration (optional)
- **Grafana:** Real-time dashboards (optional)

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│         Local AI CySec Workstation                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│  │ big-AGI  │─▶│ LiteLLM  │─▶│ LocalAI  │         │
│  │  (UI)    │  │ (Proxy)  │  │ (Engine) │         │
│  │  :3000   │  │  :4000   │  │  :8080   │         │
│  └──────────┘  └──────────┘  └────┬─────┘         │
│                                    │                │
│                                    ▼                │
│                        ┌────────────────────┐      │
│                        │   AMD/NVIDIA GPU   │      │
│                        │   AI Acceleration  │      │
│                        └────────────────────┘      │
│                                                     │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │   n8n    │─▶│  Wazuh   │─▶│ Grafana  │        │
│  │ :5678    │  │ (SIEM)   │  │  :3001   │        │
│  └──────────┘  └──────────┘  └──────────┘        │
└─────────────────────────────────────────────────────┘
```

---

## 📦 What's Included

### AI Models (Pre-configured)
- **qwen3-30b** - Complex analysis & reasoning
- **llama-3.1-8b** - Coding & general chat
- **mistral-7b** - Fast responses
- **qwen2.5-7b** - Function calling
- **whisper-1** - Voice transcription

### Security Automation (n8n workflows)
- **Automated CVE Scanning** - Daily vulnerability monitoring
- **Incident Response** - Real-time alert triage
- **Threat Hunting** - AI-powered log analysis
- **Security Dashboards** - Wazuh-Grafana integration
- **Claude Code Integration** - AI coding assistant via Telegram/Slack/Discord

---

## 🚀 Deployment

**Primary Method:** Docker Compose (recommended)

### Prerequisites

- **OS:** Linux (Arch, Ubuntu, Fedora)
- **GPU:** AMD with ROCm support (or NVIDIA with CUDA)
- **RAM:** 16GB minimum, 32GB recommended
- **Storage:** 100GB+ free space
- **Docker:** Docker Engine 20.10+ & Docker Compose V2

### Docker Compose Deployment (Recommended)

```bash
# 1. Clone and setup
git clone https://github.com/isolomonleecode/Local-AI-CySec-Workstation.git
cd Local-AI-CySec-Workstation
cp .env.example .env

# 2. Generate secure keys
echo "LITELLM_MASTER_KEY=sk-$(openssl rand -hex 16)" >> .env
echo "LITELLM_SALT_KEY=sk-salt-$(openssl rand -hex 16)" >> .env
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env

# 3. Start AI services
docker-compose --profile ai up -d

# 4. Verify
curl http://localhost:4000/health
curl http://localhost:8080/readyz
```

**Deployment Options:**
```bash
# AI only (core services)
docker-compose --profile ai up -d

# AI + monitoring
docker-compose --profile ai --profile monitoring up -d

# AI + monitoring + SAML lab
docker-compose --profile ai --profile monitoring --profile saml up -d
```

**📖 Complete guide:** [DOCKER-COMPOSE-GUIDE.md](DOCKER-COMPOSE-GUIDE.md)

### Alternative: Systemd Services (Optional)

For advanced users who prefer systemd:
1. See templates in `configs/systemd/`
2. Run `./scripts/configure-services.sh`
3. Follow `configs/systemd/README.md`

**Note:** Docker Compose is recommended for easier management and portability.

---

## 📖 Documentation

**Documentation is centralized** in a private vault (keeping the GitHub repo clean and portable).

### Key Guides
- **Quick Start Guide** - Get up and running fast
- **Installation Guide** - Complete setup instructions
- **Connection Guide** - big-AGI ↔ LiteLLM setup
- **n8n Integration** - Security automation workflows
- **Docker Network Fix** - Container networking solutions
- **Troubleshooting** - Common issues and solutions

### n8n Workflows

Ready-to-import security automation in [`n8n-workflows/`](n8n-workflows/):

#### Security Workflows
1. **vulnerability-scanner.json** - Daily CVE monitoring with AI analysis
2. **incident-response.json** - Real-time alert triage & automated response
3. **wazuh-grafana-integration.json** - Security metrics & dashboards
4. **wazuh-n8n-integration.xml** - Wazuh webhook configuration

#### Claude Code Integration
Located in `n8n-workflows/claude-code-integration/`:
1. **01-telegram-claude-code.json** - Telegram bot for coding assistance
2. **02-slack-claude-code.json** - Slack integration
3. **03-discord-claude-code.json** - Discord bot

#### Prompt Enhancement System
Located in `n8n-workflows/prompt-enhancement-system/`:
- Security-focused AI prompt templates (threat modeling, IR, compliance, pentesting)
- Three workflow variants (full pipeline, fast track, deep analysis)

---

## 🔧 Configuration

### Default Ports

| Service | Port | Purpose |
|---------|------|---------|
| big-AGI | 3000 | Web UI |
| Open-WebUI | 3001 | Alternative Web UI |
| LiteLLM | 4000 | AI API Proxy |
| n8n | 5678 | Workflow Automation |
| LocalAI | 8080 | Inference Engine |
| Prometheus | 9090 | Metrics |

### API Keys

All API keys should be generated securely using:

```bash
# LiteLLM Master Key
echo "LITELLM_MASTER_KEY=sk-$(openssl rand -hex 16)" >> .env

# LiteLLM Salt Key
echo "LITELLM_SALT_KEY=sk-salt-$(openssl rand -hex 16)" >> .env
```

**Never commit API keys to version control!**

---

## 🎓 Use Cases

### Security Professionals
- ✅ CVE Analysis & vulnerability research
- ✅ Malware analysis (safe local environment)
- ✅ Incident response automation
- ✅ Threat hunting & log analysis
- ✅ Security report generation

### Developers
- ✅ Security code review
- ✅ Penetration testing assistance
- ✅ Security architecture review
- ✅ Compliance guidance (GDPR/HIPAA/PCI-DSS)

### SOC Teams
- ✅ Alert triage automation
- ✅ Threat intelligence enrichment
- ✅ Incident documentation
- ✅ Playbook execution

---

## 🛡️ Security & Privacy

- ✅ **100% Local:** No data sent to cloud
- ✅ **No Telemetry:** Zero external tracking
- ✅ **GDPR Compliant:** Data sovereignty
- ✅ **Air-Gap Ready:** Can run fully offline
- ✅ **Encrypted Storage:** All data encrypted at rest
- ✅ **Audit Logs:** Complete activity logging

---

## 🐛 Troubleshooting

### GPU not detected
```bash
# Check GPU visibility
docker exec local-ai rocm-smi    # For AMD
docker exec local-ai nvidia-smi  # For NVIDIA

# Verify container GPU access
docker exec local-ai env | grep HSA_OVERRIDE_GFX_VERSION
```

### Can't connect to LiteLLM
```bash
# Test LiteLLM health
curl http://localhost:4000/health

# Check if running
docker ps | grep litellm
```

### big-AGI connection refused

**Problem:** Using `localhost:4000` fails from inside Docker network

**Solution:** Use container name instead:
```
http://ai-litellm-1:4000
```

See documentation: `DOCKER_NETWORK_FIX.md`

### n8n can't reach LocalAI

**Problem:** LocalAI not on same Docker network

**Solution:** Use host IP address:
```
http://192.168.0.x:8080  # Replace x with your host IP
```

---

## 📜 License

MIT License - See [LICENSE](LICENSE)

---

## 🗂️ Project Structure

```
Local-AI-CySec-Workstation/
├── docker-compose.yml           # Primary deployment method
├── .env.example                 # Environment template
├── scripts/                     # Setup & management scripts
│   └── configure-services.sh
├── n8n-workflows/               # Security automation workflows
│   ├── claude-code-integration/ # AI coding assistant bots
│   ├── prompt-enhancement-system/  # Security prompt templates
│   ├── vulnerability-scanner.json
│   ├── incident-response.json
│   └── wazuh-grafana-integration.json
├── configs/                     # Example configurations
│   └── systemd/                 # Systemd service templates
├── DOCKER-COMPOSE-GUIDE.md      # Deployment guide
├── .gitignore
├── README.md
└── LICENSE
```

**Note:** Detailed configuration files and documentation are maintained in a private vault for security and portability.

---

## 🚦 Getting Help

### Common Issues
1. **GPU not detected** - Check ROCm/CUDA installation
2. **Port conflicts** - Change ports in `.env` file
3. **Network issues** - See `DOCKER_NETWORK_FIX.md`
4. **Permission errors** - Check Docker user groups

### Resources
- **Documentation Vault** - Complete guides and configurations
- **n8n Workflows** - Pre-built automation templates
- **Issue Tracker** - Report bugs and request features

---

## 🙏 Acknowledgments

Built with:
- [LocalAI](https://localai.io/) - Local inference engine
- [LiteLLM](https://github.com/BerriAI/litellm) - Unified AI API
- [big-AGI](https://github.com/enricoros/big-AGI) - Advanced UI
- [n8n](https://n8n.io/) - Workflow automation
- [Wazuh](https://wazuh.com/) - Security monitoring
- [Grafana](https://grafana.com/) - Visualization platform

---

**Last Updated:** December 13, 2025
