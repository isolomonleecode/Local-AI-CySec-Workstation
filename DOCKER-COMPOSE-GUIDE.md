# Docker Compose Deployment Guide

Complete guide for deploying the Local AI CySec Workstation using Docker Compose.

---

## Quick Start

### 1. Prerequisites

- Docker Engine 20.10+
- Docker Compose V2
- AMD GPU with ROCm support (for LocalAI GPU acceleration)
- 16GB+ RAM recommended

### 2. Initial Setup

```bash
# Clone the repository
git clone https://github.com/isolomonleecode/Local-AI-CySec-Workstation.git
cd Local-AI-CySec-Workstation

# Copy environment template
cp .env.example .env

# Edit .env with your configuration
nano .env  # or your preferred editor
```

### 3. Generate Secure Keys

```bash
# Generate secure LiteLLM keys
echo "LITELLM_MASTER_KEY=sk-$(openssl rand -hex 16)" >> .env
echo "LITELLM_SALT_KEY=sk-salt-$(openssl rand -hex 16)" >> .env

# Set secure database password
echo "POSTGRES_PASSWORD=$(openssl rand -base64 32)" >> .env
```

### 4. Start Services

```bash
# Start AI services only
docker-compose --profile ai up -d

# OR start AI + monitoring
docker-compose --profile ai --profile monitoring up -d

# OR start everything (AI + monitoring + SAML lab)
docker-compose --profile ai --profile monitoring --profile saml up -d
```

---

## Service Profiles

The stack uses Docker Compose profiles for modular deployment:

### Profile: `ai` (Core Services)
**Always required for AI functionality**

- **LocalAI** - GPU-accelerated LLM backend (port 8080)
- **LiteLLM** - Unified API gateway (port 4000)
- **big-AGI** - Primary chat UI (port 3000)
- **Open-WebUI** - RAG and document analysis (port 3001)
- **PostgreSQL** - LiteLLM database (port 5432)

### Profile: `monitoring` (Optional)
**For metrics and observability**

- **Prometheus** - Metrics collection (port 9090)
- **Node Exporter** - System metrics
- **Promtail** - Log aggregation (port 9080)

### Profile: `saml` (Optional)
**For SAML/SSO security testing**

- **Keycloak** - Identity Provider (port 8180)
- **SimpleSAMLphp** - Test Service Provider (port 8081)
- **NextCloud** - SAML-enabled app (port 8082)
- **SFTP Server** - File transfer testing (port 2222)

---

## Usage Examples

### Start Just AI Services
```bash
docker-compose --profile ai up -d
```

### Add Monitoring
```bash
docker-compose --profile ai --profile monitoring up -d
```

### Full Stack
```bash
docker-compose --profile ai --profile monitoring --profile saml up -d
```

### Stop All Services
```bash
docker-compose down
```

### Stop and Remove Volumes (Clean Slate)
```bash
docker-compose down -v
```

---

## Service Access

Once started, access services at:

### AI Services
- **big-AGI**: http://localhost:3000
- **Open-WebUI**: http://localhost:3001
- **LiteLLM UI**: http://localhost:4000
- **LocalAI**: http://localhost:8080

### Monitoring (if enabled)
- **Prometheus**: http://localhost:9090

### SAML Lab (if enabled)
- **Keycloak**: http://localhost:8180
  - Username: `admin`
  - Password: (from .env, default: `admin123`)
- **SimpleSAMLphp**: http://localhost:8081
- **NextCloud**: http://localhost:8082

---

## Configuration

### LiteLLM Models

Edit `configs/litellm/config.yaml` to:
- Add/remove models
- Configure external API providers (OpenAI, Anthropic, etc.)
- Adjust rate limits
- Customize routing strategies

Example adding OpenAI:
```yaml
model_list:
  - model_name: gpt-4
    litellm_params:
      model: gpt-4
      api_key: os.environ/OPENAI_API_KEY
```

Then add to `.env`:
```bash
OPENAI_API_KEY=sk-your-key-here
```

### Prometheus Monitoring

Edit `configs/prometheus/prometheus.yml` to add scrape targets.

### Environment Variables

All configurable options are in `.env`:
- API keys and passwords
- Service ports
- Feature flags
- Database credentials

---

## GPU Support

### AMD GPU (ROCm)

LocalAI is configured for AMD GPU with ROCm support:
- Devices `/dev/kfd` and `/dev/dri` are mounted
- Environment variable `HSA_OVERRIDE_GFX_VERSION=10.3.0`

**Adjust for your GPU:**
```yaml
# In docker-compose.yml, update for your GPU model:
environment:
  - HSA_OVERRIDE_GFX_VERSION=10.3.0  # Change to your GFX version
```

Find your version:
```bash
rocminfo | grep gfx
```

### NVIDIA GPU

To use NVIDIA GPU instead:

1. Install NVIDIA Container Toolkit
2. Update `docker-compose.yml`:
```yaml
local-ai:
  image: localai/localai:latest-gpu-nvidia-cuda-12
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: all
            capabilities: [gpu]
```

---

## Troubleshooting

### Check Service Status
```bash
docker-compose ps
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f local-ai
docker-compose logs -f litellm
docker-compose logs -f big-agi
```

### Restart a Service
```bash
docker-compose restart local-ai
```

### Check Health
```bash
# LocalAI
curl http://localhost:8080/readyz

# LiteLLM
curl http://localhost:4000/health

# big-AGI
curl http://localhost:3000
```

### Database Issues
```bash
# Connect to PostgreSQL
docker exec -it litellm_db psql -U llmproxy -d litellm

# Check database
\dt
\q
```

### Reset Everything
```bash
# Stop and remove all containers, networks, volumes
docker-compose down -v

# Remove all images
docker-compose down --rmi all -v

# Start fresh
docker-compose --profile ai up -d
```

---

## Volume Management

### Persistent Data Locations

Data is stored in Docker volumes:
- `litellm_postgres_data` - LiteLLM database
- `localai_models` - Downloaded AI models
- `localai_backends` - LocalAI backends
- `open_webui_data` - Open-WebUI data
- `prometheus_data` - Metrics history

### Backup Volumes
```bash
# Backup LiteLLM database
docker run --rm -v litellm_postgres_data:/data -v $(pwd):/backup ubuntu tar czf /backup/litellm-db-backup.tar.gz /data

# Backup AI models
docker run --rm -v localai_models:/data -v $(pwd):/backup ubuntu tar czf /backup/models-backup.tar.gz /data
```

### Restore Volumes
```bash
# Restore LiteLLM database
docker run --rm -v litellm_postgres_data:/data -v $(pwd):/backup ubuntu tar xzf /backup/litellm-db-backup.tar.gz -C /
```

---

## Security Best Practices

### 1. Secure Passwords
- Generate strong random passwords for all services
- Never use default passwords in production
- Keep `.env` file secure and never commit to git

### 2. API Keys
- Use strong, randomly generated API keys
- Rotate keys periodically
- Limit key permissions where possible

### 3. Network Isolation
- AI services run on isolated `ai-network`
- SAML lab runs on isolated `saml-network`
- Use reverse proxy for external access

### 4. Updates
```bash
# Pull latest images
docker-compose pull

# Recreate containers with new images
docker-compose --profile ai up -d
```

---

## Systemd Integration (Optional)

To start the stack on boot using systemd:

1. Use the template system in `configs/systemd/`
2. Run `./scripts/configure-services.sh` to generate service files
3. Follow instructions in `configs/systemd/README.md`

**Note:** Docker Compose is the recommended deployment method. Systemd is optional for advanced users.

---

## Migration from Systemd

If you're currently using systemd services:

1. Stop systemd services:
```bash
sudo systemctl stop big-agi.service localai.service chromium-debug.service
sudo systemctl disable big-agi.service localai.service chromium-debug.service
```

2. Start Docker Compose stack:
```bash
docker-compose --profile ai up -d
```

3. Verify services are running:
```bash
docker-compose ps
curl http://localhost:3000  # big-AGI
curl http://localhost:8080/readyz  # LocalAI
```

---

## Performance Tuning

### Increase LocalAI Performance
In `.env`:
```bash
THREADS=16              # Increase CPU threads
CONTEXT_SIZE=8192       # Larger context window
DEBUG=false             # Disable debug logging
REBUILD=false           # Skip rebuild on startup
```

### Increase Database Performance
```yaml
litellm-db:
  command:
    - "postgres"
    - "-c"
    - "shared_buffers=256MB"
    - "-c"
    - "max_connections=200"
```

---

## Support

For issues:
1. Check logs: `docker-compose logs -f`
2. Check health: `docker-compose ps`
3. Review [TROUBLESHOOTING.md](../Documentation/...)
4. Open issue on GitHub

---

**Last Updated:** December 6, 2025
