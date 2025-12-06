# Local AI Cybersecurity Workstation

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Security: CompTIA](https://img.shields.io/badge/Security-CompTIA%20Sec%2B-red)](https://www.comptia.org/certifications/security)

**Author:** isolomonlee | **Certifications:** CompTIA Security+

**GPU-accelerated, privacy-first AI workstation for cybersecurity professionals**

> 100% local AI processing • No cloud dependencies • Fully open source

---

## 🎯 Quick Start

```bash
# Clone the repository
git clone https://github.com/isolomonleecode/Local-AI-CySec-Workstation.git
cd Local-AI-CySec-Workstation

# Run setup script
./scripts/setup.sh

# Start services (Docker Compose required)
docker-compose up -d
```

**Access:**
- **big-AGI UI:** http://localhost:3000
- **LiteLLM API:** http://localhost:4000
- **LocalAI:** http://localhost:8080

**📚 Full documentation** is stored in centralized vault (not in this repo to reduce clutter):
```
/run/media/ssjlox/gamer/Documentation/Projects/Local-AI-CySec-Workstation/
```

---

## 🔥 Features

### 🤖 **Local AI Processing**
- **Privacy-First:** All AI processing on-premises
- **GPU-Accelerated:** AMD ROCm/HIP for fast inference
- **Multi-Model:** Run multiple LLMs simultaneously
- **No API Costs:** Unlimited usage, zero per-token fees

### 🔐 **Security-Focused**
- **CVE Analysis:** AI-powered vulnerability assessment
- **Malware Analysis:** Safe local code analysis
- **Log Analysis:** Intelligent threat detection
- **Code Review:** Automated security audits

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
│                        │   AMD GPU (ROCm)   │      │
│                        │   AI Acceleration  │      │
│                        └────────────────────┘      │
└─────────────────────────────────────────────────────┘
```

---

## 📦 What's Included

### AI Models (Pre-configured)
- **qwen3-30b** - Complex analysis & reasoning
- **llama-3.1-8b** - Coding & general chat
- **mistral-7b** - Fast responses
- **qwen2.5-7b** - Function calling

### Security Automation (n8n workflows)
- **Automated CVE Scanning** - Daily vulnerability monitoring
- **Incident Response** - Real-time alert triage
- **Threat Hunting** - AI-powered log analysis
- **Security Dashboards** - Wazuh-Grafana integration

---

## 🚀 Installation

### Prerequisites

- **OS:** Linux (Arch, Ubuntu, Fedora)
- **GPU:** AMD with ROCm support (or NVIDIA with CUDA)
- **RAM:** 16GB minimum, 32GB recommended
- **Storage:** 100GB+ free space
- **Docker:** Docker & Docker Compose installed

### Quick Install

```bash
# 1. Clone repository
git clone https://github.com/isolomonleecode/Local-AI-CySec-Workstation.git
cd Local-AI-CySec-Workstation

# 2. Run setup (creates docker-compose.yml if needed)
chmod +x scripts/setup.sh
./scripts/setup.sh

# 3. Start all services
docker-compose up -d

# 4. Verify installation
curl http://localhost:4000/health
```

**Note:** Setup script will check for systemd services but deployment uses Docker Compose.

---

## 📖 Documentation

**Documentation is centralized** in Obsidian vault (cleaner GitHub repo):

```
/run/media/ssjlox/gamer/Documentation/Projects/Local-AI-CySec-Workstation/
```

### Key Guides
- **Quick Start Guide** - Get up and running fast
- **Installation Guide** - Complete setup instructions
- **Connection Guide** - big-AGI ↔ LiteLLM setup
- **n8n Integration** - Security automation workflows
- **Troubleshooting** - Common issues

### n8n Workflows
Ready-to-import security automation in [`n8n-workflows/`](n8n-workflows/):
1. **vulnerability-scanner.json** - Daily CVE monitoring with AI analysis
2. **incident-response.json** - Real-time alert triage & automated response
3. **wazuh-grafana-integration.json** - Security metrics & dashboards
4. **wazuh-n8n-integration.xml** - Wazuh webhook configuration

---

## 🔧 Configuration

### Default Ports

| Service | Port | Purpose |
|---------|------|---------|
| big-AGI | 3000 | Web UI |
| LiteLLM | 4000 | AI API Proxy |
| LocalAI | 8080 | Inference Engine |

### API Keys

**LiteLLM Master Key:** `sk-^XZX64qiUwZo*S`
*(Change in production - see documentation vault)*

---

## 🎓 Use Cases

### Security Professionals
- ✅ CVE Analysis & vulnerability research
- ✅ Malware analysis (safe local environment)
- ✅ Incident response automation
- ✅ Threat hunting & log analysis

### Developers
- ✅ Security code review
- ✅ Penetration testing assistance
- ✅ Security architecture review
- ✅ Compliance guidance (GDPR/HIPAA)

---

## 🛡️ Security & Privacy

- ✅ **100% Local:** No data sent to cloud
- ✅ **No Telemetry:** Zero external tracking
- ✅ **GDPR Compliant:** Data sovereignty
- ✅ **Air-Gap Ready:** Can run fully offline

---

## 🐛 Troubleshooting

### GPU not detected
```bash
docker exec local-ai rocm-smi
```

### Can't connect to LiteLLM
```bash
curl http://localhost:4000/health
```

### big-AGI connection refused
Use container name `http://ai-litellm-1:4000` instead of `localhost`.
See documentation: `DOCKER_NETWORK_FIX.md`

---

## 📜 License

MIT License - See [LICENSE](LICENSE)

---

## 🗂️ Project Structure

```
Local-AI-CySec-Workstation/
├── configs/           # Configuration files
├── scripts/           # Setup scripts
├── n8n-workflows/     # Automation workflows
├── tools/             # Helper utilities
├── .gitignore         # Excludes docs/, .obsidian/
├── README.md          # This file
└── LICENSE
```

**Documentation vault:** `/run/media/ssjlox/gamer/Documentation/Projects/Local-AI-CySec-Workstation/`

---

## 🙏 Acknowledgments

- LocalAI, LiteLLM, big-AGI, Wazuh, n8n

---

**Author:** isolomonlee | **Certifications:** CompTIA Security+

**Last Updated:** December 6, 2025
