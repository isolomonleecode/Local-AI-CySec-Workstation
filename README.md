# Local AI Cybersecurity Workstation

**Author:** ssjlox
**Status:** Production
**Certifications:** CompTIA Security+
**Focus Areas:** AI-Enhanced Security Operations, Security Automation, Threat Intelligence

## Project Overview

A fully local, GPU-accelerated AI workstation designed for cybersecurity professionals who need privacy, control, and cutting-edge AI capabilities for security research, automation, and analysis—without relying on cloud APIs.

**Key Capabilities:**
- 🔒 **100% Local & Private:** All AI processing on-premises with AMD GPU acceleration
- 🤖 **Multi-Model Support:** Run multiple open-source LLMs simultaneously
- 🔐 **Security-Focused:** Designed for sensitive security work and research
- ⚡ **GPU-Accelerated:** AMD ROCm/HIP for high-performance inference
- 🛠️ **Cybersecurity Tooling:** Integrated with security automation workflows

## Why Local AI for Cybersecurity?

### Privacy & Compliance
- ✅ **Data Sovereignty:** Sensitive security data never leaves your infrastructure
- ✅ **No Cloud Dependency:** No API rate limits, no service outages
- ✅ **Compliance-Ready:** GDPR, HIPAA, SOC 2 compliant by design
- ✅ **Confidential Research:** Analyze malware, vulnerabilities, exploits privately

### Cost & Control
- ✅ **Zero API Costs:** No per-token pricing or monthly subscriptions
- ✅ **Unlimited Usage:** Run as many queries as your hardware allows
- ✅ **Custom Models:** Fine-tune models on your security datasets
- ✅ **Full Control:** Choose models, parameters, and configurations

### Security Use Cases
- 🔍 **Vulnerability Analysis:** Analyze CVEs and security advisories with AI
- 📝 **Security Documentation:** Auto-generate security reports and runbooks
- 🔬 **Malware Analysis:** Safely analyze suspicious code and binaries
- 🤖 **Security Automation:** AI-powered incident response and triage
- 📊 **Log Analysis:** Intelligent log parsing and threat detection
- 💻 **Code Review:** Automated security code review and SAST
- 🎯 **Threat Intelligence:** Process and analyze threat feeds locally

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Local AI Workstation                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐     ┌──────────────┐    ┌──────────────┐ │
│  │   big-AGI    │────▶│   LocalAI    │◀───│ AMD GPU      │ │
│  │   Web UI     │     │   Server     │    │ HIP/ROCm     │ │
│  │  (Port 3000) │     │  (Port 8080) │    │ Acceleration │ │
│  └──────────────┘     └──────────────┘    └──────────────┘ │
│         │                     │                              │
│         │                     ▼                              │
│         │            ┌──────────────────┐                   │
│         │            │   LLM Models     │                   │
│         │            │   (.gguf files)  │                   │
│         │            └──────────────────┘                   │
│         │                                                    │
│         ▼                                                    │
│  ┌──────────────┐                                           │
│  │  Chromium    │  (Web scraping & browser automation)      │
│  │  Headless    │                                           │
│  │  (Port 9222) │                                           │
│  └──────────────┘                                           │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │ Security Tools   │
                    │ & Automation     │
                    └──────────────────┘
```

## Components

### 1. LocalAI Server
**Purpose:** GPU-accelerated local LLM inference server
**Technology:** LocalAI (OpenAI-compatible API)
**Hardware Acceleration:** AMD ROCm/HIP (GPU passthrough)
**Port:** 8080
**Container:** `localai/localai:latest-aio-gpu-hipblas`

**Features:**
- OpenAI-compatible API endpoints
- Multiple model support (GGUF format)
- GPU acceleration for fast inference
- Text generation, embeddings, image generation
- Compatible with OpenAI SDKs and tools

**Supported Models:**
- Llama 3.1/3.2 (8B, 70B)
- Mistral/Mixtral
- CodeLlama (for security code analysis)
- DeepSeek Coder
- Custom fine-tuned security models

### 2. big-AGI Web Interface
**Purpose:** Advanced AI chat interface for security workflows
**Technology:** Next.js, React, TypeScript
**Port:** 3000 (development)
**Features:**
- Multi-model chat (compare responses)
- Beam mode (parallel model reasoning)
- Code syntax highlighting
- Markdown rendering with LaTeX
- File upload and analysis
- Conversation management
- Persona system (security analyst, penetration tester, etc.)

**Cybersecurity Personas:**
- 🔒 Security Analyst
- 🔴 Red Team Operator
- 🔵 Blue Team Defender
- 🔬 Malware Analyst
- 📋 Compliance Auditor
- 💻 Security Engineer

### 3. Chromium Headless Browser
**Purpose:** Web scraping, OSINT, and automated browsing for security research
**Technology:** Chromium with remote debugging
**Port:** 9222
**Use Cases:**
- Automated threat intelligence gathering
- Vulnerability disclosure monitoring
- Security blog/feed aggregation
- OSINT reconnaissance
- Automated security tool interaction

## Hardware Requirements

### Minimum Specifications
- **CPU:** 6+ cores (AMD/Intel)
- **RAM:** 16GB DDR4
- **GPU:** AMD Radeon RX 5000 series or newer (8GB+ VRAM)
- **Storage:** 100GB SSD (for models and data)
- **OS:** Linux (Arch, Ubuntu, Debian)

### Recommended Specifications
- **CPU:** AMD Ryzen 7/9 or Intel i7/i9 (8+ cores)
- **RAM:** 32GB+ DDR4/DDR5
- **GPU:** AMD Radeon RX 6800/7900 (16GB+ VRAM)
- **Storage:** 500GB NVMe SSD
- **OS:** Arch Linux with latest ROCm drivers

### Tested Configuration
- **CPU:** AMD Ryzen 9 5900X
- **RAM:** 64GB DDR4-3600
- **GPU:** AMD Radeon RX 7900 XTX (24GB VRAM)
- **Storage:** 2TB NVMe SSD
- **OS:** Arch Linux (kernel 6.17.5-zen1)

## Installation

### Quick Start

```bash
# Clone repository
git clone https://github.com/isolomonleecode/Local-AI-CySec-Workstation.git
cd Local-AI-CySec-Workstation

# Install dependencies
./scripts/install-dependencies.sh

# Configure systemd services
sudo cp configs/systemd/*.service /etc/systemd/system/
sudo systemctl daemon-reload

# Start services
sudo systemctl start localai.service
sudo systemctl start chromium-debug.service
sudo systemctl start big-agi.service

# Enable on boot
sudo systemctl enable localai.service chromium-debug.service big-agi.service

# Check status
systemctl status localai.service
systemctl status big-agi.service
```

### Manual Installation

See [docs/installation.md](docs/installation.md) for detailed step-by-step instructions.

## Configuration

### LocalAI Setup
```bash
# Edit LocalAI configuration
vim configs/localai/config.yaml

# Download models
./scripts/download-models.sh llama-3.1-8b
./scripts/download-models.sh codellama-13b

# Test LocalAI
curl http://localhost:8080/v1/models
```

### big-AGI Setup
```bash
# Configure environment
cp configs/big-agi/.env.example configs/big-agi/.env
vim configs/big-agi/.env

# Set LocalAI endpoint
LOCALAI_API_HOST=http://127.0.0.1:8080

# Start big-AGI
cd big-AGI
npm install
npm run dev

# Access at http://localhost:3000
```

## Usage

### Basic Chat Interface
1. Open browser to `http://localhost:3000`
2. Select LocalAI as provider in settings
3. Choose model (e.g., llama-3.1-8b-instruct)
4. Start chatting!

### Security Use Cases

#### Vulnerability Analysis
```
User: Analyze CVE-2025-1234 and provide:
1. Attack vector analysis
2. Affected versions
3. Mitigation steps
4. Detection signatures

[AI provides detailed security analysis]
```

#### Code Security Review
```
User: Review this Python script for security issues:
[paste code]

[AI identifies SQL injection, XSS, hardcoded secrets, etc.]
```

#### Incident Response
```
User: I have suspicious traffic from 192.168.1.100. Analyze these logs:
[paste logs]

[AI provides IOCs, recommendations, and response steps]
```

#### Malware Analysis
```
User: Static analysis of this binary hash:
SHA256: [hash]

[AI queries threat intelligence and provides analysis]
```

### Advanced Features

#### Beam Mode (Multi-Model Analysis)
Compare responses from multiple models simultaneously:
1. Enable Beam mode in big-AGI
2. Select 2-4 models (e.g., Llama, Mistral, CodeLlama)
3. Ask security question
4. Get diverse perspectives and identify best answer

#### Custom Personas
Create specialized security personas:
```yaml
# configs/big-agi/personas/red-team.yaml
name: "Red Team Operator"
role: "Offensive security expert"
instructions: |
  You are an experienced penetration tester and red team operator.
  Focus on:
  - Identifying attack vectors
  - Exploitation techniques
  - Stealth and evasion
  - Post-exploitation strategies
  Always provide ethical hacking context and authorization requirements.
```

## Security & Privacy

### Data Protection
- ✅ All AI processing stays on localhost
- ✅ No telemetry or analytics sent to external servers
- ✅ Models run in isolated Docker containers
- ✅ Network traffic limited to localhost only

### Operational Security
- 🔒 API keys stored in `.env` (not committed to Git)
- 🔒 Systemd services run as non-root user
- 🔒 Docker containers with minimal privileges
- 🔒 Regular security updates via `./scripts/update-stack.sh`

### Best Practices
1. **Keep models updated** - Newer models have better security understanding
2. **Use personas** - Specialized personas give better security guidance
3. **Validate AI output** - Always verify AI-generated security advice
4. **Sanitize inputs** - Don't paste actual credentials or sensitive data
5. **Air-gap if needed** - Disconnect from network for maximum security

## Project Structure

```
Local-AI-CySec-Workstation/
├── docs/                      # Documentation
│   ├── installation.md        # Detailed installation guide
│   ├── model-comparison.md    # LLM model comparison
│   ├── security-use-cases.md  # Cybersecurity examples
│   ├── troubleshooting.md     # Common issues
│   └── README.md              # Documentation index
├── configs/                   # Configuration files
│   ├── localai/               # LocalAI configs
│   │   └── config.yaml
│   ├── big-agi/               # big-AGI configs
│   │   ├── .env.example
│   │   └── personas/          # Custom personas
│   ├── systemd/               # Systemd service files
│   │   ├── localai.service
│   │   ├── big-agi.service
│   │   └── chromium-debug.service
│   └── README.md
├── scripts/                   # Automation scripts
│   ├── install-dependencies.sh
│   ├── download-models.sh
│   ├── start-stack.sh
│   ├── stop-stack.sh
│   ├── update-stack.sh
│   ├── backup-configs.sh
│   └── README.md
├── tools/                     # Security integration tools
│   ├── ai-vuln-analyzer.py    # AI-powered CVE analysis
│   ├── ai-log-parser.py       # Intelligent log analysis
│   ├── ai-code-reviewer.py    # Security code review
│   └── README.md
├── examples/                  # Example workflows
│   ├── vulnerability-analysis.md
│   ├── malware-analysis.md
│   ├── log-analysis.md
│   └── code-review.md
├── .gitignore
├── README.md                  # This file
└── LICENSE
```

## Performance Optimization

### GPU Acceleration
```bash
# Verify ROCm installation
rocm-smi

# Check GPU utilization during inference
watch -n 1 rocm-smi

# Optimize LocalAI for your GPU
vim configs/localai/config.yaml
# Set: gpu_layers: 35 (adjust based on VRAM)
```

### Model Selection
| Model | Size | VRAM | Use Case | Speed |
|-------|------|------|----------|-------|
| Llama-3.1-8B | 8B | 6GB | General security queries | Fast |
| Llama-3.1-70B | 70B | 48GB | Complex analysis | Slow |
| CodeLlama-13B | 13B | 10GB | Code security review | Medium |
| Mistral-7B | 7B | 5GB | Quick responses | Very Fast |
| DeepSeek-Coder-6.7B | 6.7B | 5GB | Code analysis | Fast |

### Inference Optimization
- **Context Length:** Reduce for faster responses (2048 vs 4096 tokens)
- **Temperature:** Lower (0.3-0.5) for consistent security analysis
- **Quantization:** Use Q4 or Q5 models for speed (vs Q8 for accuracy)

## Troubleshooting

### LocalAI Not Starting
```bash
# Check Docker logs
docker logs local-ai

# Verify GPU passthrough
docker run --rm --device=/dev/kfd --device=/dev/dri rocm/rocm-terminal rocm-smi

# Check port availability
ss -tlnp | grep 8080
```

### big-AGI Connection Issues
```bash
# Test LocalAI API
curl http://localhost:8080/v1/models

# Check big-AGI logs
journalctl -u big-agi.service -f

# Verify environment variables
cat /run/media/ssjlox/gamer/localAI/big-AGI/.env
```

### GPU Not Detected
```bash
# Install ROCm drivers
./scripts/install-rocm.sh

# Verify installation
rocm-smi
/opt/rocm/bin/rocminfo

# Check kernel modules
lsmod | grep amdgpu
```

See [docs/troubleshooting.md](docs/troubleshooting.md) for more solutions.

## Roadmap

### Current Features ✅
- [x] LocalAI GPU-accelerated inference
- [x] big-AGI web interface
- [x] Systemd service management
- [x] Chromium headless browser integration
- [x] Multi-model support

### Planned Features 📋
- [ ] Automated model download and management
- [ ] Security-focused model fine-tuning
- [ ] Integration with SIEM tools (Wazuh, Splunk)
- [ ] Automated threat intelligence gathering
- [ ] Custom security personas library
- [ ] RAG (Retrieval-Augmented Generation) for security docs
- [ ] API for security tool integration
- [ ] Grafana dashboards for AI metrics
- [ ] Automated vulnerability scanning with AI triage

### Future Enhancements 🚀
- [ ] Kubernetes deployment for scaling
- [ ] Multi-GPU support
- [ ] Custom security model training pipeline
- [ ] Integration with Metasploit/Burp Suite
- [ ] AI-powered penetration testing assistant
- [ ] Automated security report generation

## Contributing

This is a personal cybersecurity workstation project, but contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request with detailed description
4. Follow existing code and documentation standards

## Resources

### LocalAI Documentation
- [LocalAI Official Docs](https://localai.io/)
- [Model Gallery](https://localai.io/models/)
- [API Reference](https://localai.io/basics/getting_started/)

### big-AGI Documentation
- [big-AGI GitHub](https://github.com/enricoros/big-AGI)
- [Configuration Guide](https://github.com/enricoros/big-AGI/blob/main/docs/environment-variables.md)
- [Deployment Options](https://github.com/enricoros/big-AGI/blob/main/docs/deploy-docker.md)

### AMD ROCm
- [ROCm Documentation](https://rocm.docs.amd.com/)
- [Supported GPUs](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/reference/system-requirements.html)
- [Performance Tuning](https://rocm.docs.amd.com/en/latest/how-to/tuning-guides/index.html)

### Security AI Resources
- [AI for Cybersecurity - NIST](https://www.nist.gov/ai)
- [LLMs for Security Research](https://arxiv.org/abs/2307.03170)
- [Offensive Security with AI](https://www.defcon.org/html/defcon-31/dc-31-speakers.html#AI)

## License

MIT License - See [LICENSE](LICENSE) file

## Contact

For questions about this project or to discuss AI-enhanced security operations:
- **GitHub:** [@isolomonleecode](https://github.com/isolomonleecode)
- **Repository:** [Local-AI-CySec-Workstation](https://github.com/isolomonleecode/Local-AI-CySec-Workstation)

---

**Disclaimer:** This workstation is designed for authorized security research, testing, and defensive operations only. Always obtain proper authorization before conducting security assessments. The author is not responsible for misuse of these tools.

**Built with:** 🔒 Security | 🤖 AI | 🚀 AMD ROCm | 💻 Open Source
