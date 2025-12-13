# Prompt Enhancement System - Implementation Guide

## Overview

This automated prompt enhancement system transforms basic prompts into production-ready, domain-aware variants using a chain-of-thought architecture powered by LocalAI and n8n.

**System Components:**
- 3 n8n workflow variants (Full Pipeline, Fast Track, Deep Analysis)
- 4 domain-specific knowledge libraries (Threat Modeling, Incident Response, Penetration Testing, Compliance Audit)
- LocalAI integration via LiteLLM proxy
- Webhook-based API endpoints

**Architecture:**
```
User Input → n8n Webhook → Sequential LLM Stages → Domain Library Injection → Variant Generation → JSON Output
```

---

## Prerequisites

### Required Services

1. **n8n** (version 1.122.5 or later)
   - Running at: `http://192.168.0.52:5678`
   - Self-hosted in Docker

2. **LiteLLM Proxy**
   - Running at: `http://192.168.0.52:4000`
   - OpenAI-compatible endpoint: `/v1/chat/completions`

3. **LocalAI**
   - Running at: `http://192.168.0.52:8080`
   - Models available: qwen3-30b, qwen2.5-7b, llama-3.1-8b, mistral-7b

### Verify Services

```bash
# Check LiteLLM
curl http://192.168.0.52:4000/health

# Check LocalAI
curl http://192.168.0.52:8080/readyz

# Check n8n
curl http://192.168.0.52:5678/healthz
```

All should return 200 OK status.

---

## Installation Steps

### Step 1: Import Workflows into n8n

1. **Access n8n UI:**
   ```
   http://192.168.0.52:5678
   ```

2. **Import Each Workflow:**

   **For Variant A (Full Pipeline):**
   - Click **"Workflows"** → **"Add Workflow"**
   - Click **"⋮"** (three dots) → **"Import from File"**
   - Select `variant-a-full-pipeline.json`
   - Click **"Save"** (shortcut: Ctrl+S)
   - Click **"Activate"** toggle (top-right)

   **For Variant B (Fast Track):**
   - Repeat above steps with `variant-b-fast-track.json`

   **For Variant C (Deep Analysis):**
   - Repeat above steps with `variant-c-deep-analysis.json`

3. **Verify Webhook Endpoints:**

   After activation, note the webhook URLs (click on "Webhook Trigger" node):
   - Variant A: `http://192.168.0.52:5678/webhook/enhance-prompt`
   - Variant B: `http://192.168.0.52:5678/webhook/enhance-prompt-fast`
   - Variant C: `http://192.168.0.52:5678/webhook/enhance-prompt-deep`

   (Actual URLs may include additional path segments depending on n8n configuration)

---

### Step 2: Verify Workflow Functionality

Test each workflow with a simple prompt:

**Test Variant A (Full Pipeline):**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Create a security monitoring dashboard for threat detection"}'
```

**Expected Response:**
```json
{
  "original_prompt": "Create a security monitoring dashboard for threat detection",
  "stage_1_intent": { ... },
  "stage_2_missing_info": { ... },
  "stage_3_constraints": { ... },
  "stage_4_risks": { ... },
  "stage_5_role_context": { ... },
  "enhanced_prompts": [
    {
      "variant": "precision",
      "system_prompt": "...",
      "user_prompt": "..."
    },
    {
      "variant": "creative",
      "system_prompt": "...",
      "user_prompt": "..."
    },
    {
      "variant": "balanced",
      "system_prompt": "...",
      "user_prompt": "..."
    }
  ]
}
```

**Test Variant B (Fast Track):**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-fast \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Analyze security logs for anomalies"}'
```

**Expected Execution Time:**
- Variant A: 30-60 seconds (7 sequential LLM calls)
- Variant B: 10-15 seconds (2 LLM calls)
- Variant C: 40-80 seconds (parallel branches + synthesis)

---

### Step 3: Domain Library Integration (Enhancement)

The domain-specific libraries provide pre-loaded cybersecurity expertise. To use them:

#### Option 1: Manual Domain Injection (Current Implementation)

Currently, workflows do not automatically detect domains. To use domain libraries:

1. **Read the appropriate library file:**
   ```bash
   cat threat_modeling.json
   # or
   cat incident_response.json
   # or
   cat penetration_testing.json
   # or
   cat compliance_audit.json
   ```

2. **Manually inject expertise into your prompt:**
   ```bash
   curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
     -H "Content-Type: application/json" \
     -d '{
       "prompt": "Create a STRIDE-based threat model for a cloud API gateway handling payment data. Apply MITRE ATT&CK framework and include PCI DSS requirements."
     }'
   ```

   The keywords "STRIDE", "MITRE ATT&CK", and "PCI DSS" will naturally trigger relevant expertise during Stage 5 (Role + Context Setup) because the LLM recognizes these domain-specific terms.

#### Option 2: Automated Domain Detection (Advanced Implementation)

To automatically inject domain libraries, modify **Stage 1: Intent Analysis**:

1. **Edit the workflow in n8n**
2. **Update Stage 1 JSON body** to include domain detection:
   ```json
   {
     "model": "qwen2.5-7b",
     "messages": [
       {
         "role": "system",
         "content": "Analyze the prompt and output JSON:\n{\n  \"intent\": \"string\",\n  \"domain\": \"threat_modeling|incident_response|penetration_testing|compliance_audit|general\"\n}"
       },
       {
         "role": "user",
         "content": "{{ $json.body.prompt }}"
       }
     ]
   }
   ```

3. **Add a "Read Domain Library" node** after Stage 1:
   - Node type: **Read Binary File**
   - File path: `={{ "/run/media/ssjlox/gamer/Github Projects/Local-AI-CySec-Workstation/n8n-workflows/prompt-enhancement-system/" + $json.domain + ".json" }}`
   - Only execute if: `={{ $json.domain !== "general" }}`

4. **Modify Stage 5** to inject library content:
   ```json
   {
     "role": "system",
     "content": "{{ $('Read Domain Library').item.json.expertise_injections.join('\\n') }}\n\n[Original Stage 5 system prompt...]"
   }
   ```

This is an advanced customization beyond the base implementation.

---

## Usage Guide

### Choosing the Right Workflow

| Workflow | Use When | Execution Time | Output Variants | Best For |
|----------|----------|----------------|-----------------|----------|
| **Variant A: Full Pipeline** | Need comprehensive analysis with complete 7-stage breakdown | 30-60 sec | 3 (precision, creative, balanced) | Production deployments, complex projects |
| **Variant B: Fast Track** | Quick iterations, testing, or simple prompts | 10-15 sec | 2 (precision, balanced) | Rapid prototyping, simple tasks |
| **Variant C: Deep Analysis** | Research projects, enterprise decisions, multi-stakeholder scenarios | 40-80 sec | 4 (security-first, performance-optimized, business-aligned, holistic) | Complex enterprise projects, strategic planning |

### Real-World Usage Examples

#### Example 1: Threat Modeling for New Feature

**Input:**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "We are adding OAuth 2.0 authentication to our API. Create a threat model."
  }'
```

**How to Use Output:**
- Review all 3 variants (precision, creative, balanced)
- **Precision variant**: Use for formal threat modeling documentation
- **Creative variant**: Brainstorming additional attack scenarios
- **Balanced variant**: Team presentations and stakeholder communication

**Copy the selected variant's `system_prompt` and `user_prompt`** into your LLM interface to generate the actual threat model.

#### Example 2: Incident Response Playbook

**Input:**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-deep \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create an incident response playbook for ransomware attacks affecting healthcare data."
  }'
```

**How to Use Output:**
- Review the **security-first variant** for compliance focus (HIPAA requirements)
- Review the **business-aligned variant** for executive communication
- Review the **holistic variant** for comprehensive implementation

#### Example 3: Fast Pentesting Scope Document

**Input:**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-fast \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Write a penetration testing scope document for an e-commerce platform."
  }'
```

**How to Use Output:**
- Use **precision variant** for technical scoping
- Use **balanced variant** for client-facing scope document

---

## System Architecture Deep Dive

### Variant A: Full Pipeline Architecture

```
Webhook Trigger (POST /enhance-prompt)
    ↓
Stage 1: Intent Analysis [qwen2.5-7b, temp=0.3]
    → Identifies primary intent and task type
    ↓
Stage 2: Missing Info Detection [qwen2.5-7b, temp=0.3]
    → Lists required information not provided
    ↓
Stage 3: Constraint Expansion [qwen2.5-7b, temp=0.3]
    → Identifies technical and business constraints
    ↓
Stage 4: Risk/Failure Mode Analysis [qwen2.5-7b, temp=0.4]
    → Enumerates potential failure scenarios
    ↓
Stage 5: Role + Context Setup [qwen3-30b, temp=0.5]
    → Designs optimal role and context for task
    ↓
Stage 6: Variant Generation [qwen3-30b, temp=0.7]
    → Creates 3 prompt variants (precision, creative, balanced)
    ↓
Stage 7: JSON Formatting [JavaScript Code Node]
    → Compiles all stages into structured JSON with error handling
    ↓
Webhook Response
```

**Model Selection Rationale:**
- **Stages 1-4**: qwen2.5-7b (fast, structured analysis)
- **Stages 5-6**: qwen3-30b (complex reasoning, creativity)
- **Temperature**: Low (0.3-0.4) for analysis, high (0.7) for creative generation

### Variant B: Fast Track Architecture

```
Webhook Trigger (POST /enhance-prompt-fast)
    ↓
Combined Analysis [mistral-7b, temp=0.3]
    → Analyzes intent, missing info, constraints, and risks in single call
    ↓
Variant Generation [qwen3-30b, temp=0.7]
    → Creates 2 prompt variants (precision, balanced)
    ↓
JSON Output [JavaScript Code Node]
    ↓
Webhook Response
```

**Speed Optimization:**
- Combines stages 1-4 into single LLM call
- Uses faster mistral-7b for analysis
- Generates only 2 variants instead of 3

### Variant C: Deep Analysis Architecture

```
Webhook Trigger (POST /enhance-prompt-deep)
    ↓
[PARALLEL EXECUTION]
    ├─→ Security Analysis Branch [qwen3-30b, temp=0.4]
    ├─→ Engineering Analysis Branch [qwen3-30b, temp=0.4]
    └─→ Business Analysis Branch [qwen3-30b, temp=0.4]
    ↓
Merge Analysis Branches [n8n Merge Node]
    ↓
Consensus Synthesis [qwen3-30b, temp=0.5]
    → Reconciles perspectives, identifies conflicts, creates unified requirements
    ↓
Multi-Variant Generation [qwen3-30b, temp=0.7]
    → Creates 4 perspective-weighted variants:
      • security-first (80% security, 10% eng, 10% business)
      • performance-optimized (10% security, 80% eng, 10% business)
      • business-aligned (10% security, 10% eng, 80% business)
      • holistic (balanced integration of all perspectives)
    ↓
Final JSON Output [JavaScript Code Node]
    ↓
Webhook Response
```

**Use Case:**
- Complex enterprise projects with multiple stakeholders
- Research-grade analysis with diverse perspectives
- Strategic decision-making requiring balanced trade-offs

---

## Customization Guide

### Adjusting Temperature for Your Use Case

**Temperature** controls output randomness:
- **0.1-0.3**: Highly deterministic, structured output (analysis stages)
- **0.4-0.6**: Balanced creativity and consistency (synthesis)
- **0.7-0.9**: Creative, diverse output (variant generation)

**To modify temperature:**
1. Open workflow in n8n
2. Click on the LLM stage node (e.g., "Stage 6: Variant Generation")
3. Edit the `jsonBody` parameter
4. Change the `temperature` value
5. Save workflow

### Changing Models

**Available models in your LocalAI setup:**
- **qwen3-30b**: Complex reasoning, synthesis, creative tasks
- **qwen2.5-7b**: Fast analysis, structured output, function calling
- **llama-3.1-8b**: Coding tasks
- **mistral-7b**: Fast general-purpose tasks

**To change model in a stage:**
1. Edit the node's `jsonBody`
2. Change `"model": "qwen2.5-7b"` to desired model
3. Adjust `max_tokens` if needed (larger models can handle more tokens)

### Adding New Domain Libraries

1. **Create a new domain library JSON** following this structure:
   ```json
   {
     "domain": "your_domain_name",
     "description": "Brief description",
     "expertise_injections": [
       "Domain-specific knowledge point 1",
       "Domain-specific knowledge point 2"
     ],
     "required_fields": ["field1", "field2"],
     "compliance_frameworks": ["Framework1", "Framework2"],
     "standard_outputs": ["Output type 1", "Output type 2"],
     "integration_guidance": {
       "stage_1_detection": ["Keywords to detect this domain"],
       "stage_5_injection": "How to inject expertise"
     },
     "quality_criteria": ["Criterion 1", "Criterion 2"]
   }
   ```

2. **Save to the same directory:**
   ```
   /run/media/ssjlox/gamer/Github Projects/Local-AI-CySec-Workstation/n8n-workflows/prompt-enhancement-system/your_domain.json
   ```

3. **Implement domain detection** (see "Option 2: Automated Domain Detection" above)

### Adding More Prompt Variants

**To add a 4th variant to Variant A:**

1. Edit the **Stage 6: Variant Generation** node
2. Modify the system prompt to request 4 variants instead of 3:
   ```
   Generate 4 enhanced prompt variants:
   1. **Precision**: Maximum accuracy, detailed requirements, formal tone
   2. **Creative**: Innovative approaches, brainstorming-friendly, exploratory
   3. **Balanced**: Best of both, practical and thorough
   4. **Minimal**: Concise, essential details only, fast execution
   ```

3. Update the JSON schema in the system prompt to include the new variant

4. Save and test

---

## Troubleshooting

### Issue: "Connection refused" or timeout errors

**Cause:** LiteLLM or LocalAI service not running

**Solution:**
```bash
# Check service status
docker ps | grep -E "litellm|local-ai"

# Restart if needed
cd /run/media/ssjlox/gamer/Github\ Projects/Local-AI-CySec-Workstation
docker-compose --profile ai restart
```

### Issue: Workflow returns malformed JSON

**Cause:** LLM output did not follow JSON schema

**Solution:**
- Stage 7 (JSON Formatting node) includes error handling
- Check the `parse_error` field in the response
- If present, the `raw` field contains the unformatted LLM output
- Lower the temperature for that stage to increase JSON compliance
- Add more explicit JSON schema examples in the system prompt

### Issue: Workflow takes too long (>2 minutes)

**Cause:** LocalAI model loading or GPU resource contention

**Solution:**
```bash
# Check GPU usage
docker exec local-ai rocm-smi

# Check LocalAI logs
docker logs local-ai --tail 50

# Consider using Variant B (Fast Track) for quicker results
# Or reduce max_tokens in each stage
```

### Issue: Domain expertise not appearing in output

**Cause:** Domain library not injected into workflow

**Solution:**
- Currently, domain injection is manual (include domain keywords in your input prompt)
- For automated injection, implement "Option 2: Automated Domain Detection" (see Step 3 above)
- Verify domain library JSON files exist in the correct directory

### Issue: n8n workflow shows "Error" status

**Cause:** Various - check execution logs

**Solution:**
1. Click on the workflow execution in n8n
2. Review the error message in the failed node
3. Common issues:
   - **HTTP 500 from LiteLLM**: Check LocalAI is running, model is loaded
   - **Timeout**: Increase timeout in HTTP Request node settings
   - **JSON parsing error**: LLM returned invalid JSON, check Stage 7 error handling

---

## Performance Optimization

### Reducing Latency

1. **Use Variant B for simple prompts** (10-15 sec vs 30-60 sec)
2. **Reduce max_tokens** in each stage (fewer tokens = faster generation)
3. **Use smaller models** where appropriate:
   - Stage 1-4: mistral-7b instead of qwen2.5-7b
   - Stage 5-6: qwen2.5-7b instead of qwen3-30b (trade-off: lower quality)

4. **Batch processing**: If enhancing multiple prompts, use n8n's batch execution

### Improving Output Quality

1. **Increase max_tokens** for more detailed analysis (600-1000 instead of 400-500)
2. **Use qwen3-30b for all stages** (slower but higher quality)
3. **Add domain libraries** for specialized expertise
4. **Provide more context in input prompt** (the more detail you provide, the better the enhancement)

### Scaling for Multiple Users

**Current setup:** Single-user webhook endpoints

**For multi-user:**
1. Add authentication to webhooks (n8n supports basic auth, header-based auth)
2. Implement rate limiting using n8n's "Rate Limit" node
3. Consider running multiple LocalAI instances for parallel processing
4. Use n8n's queue mode for high-throughput scenarios

---

## Advanced Features

### A/B Testing Variants

To compare which variant produces the best results:

1. **Use all 3 workflows in parallel:**
   ```bash
   # Run all three
   curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt -d '{"prompt": "..."}' &
   curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-fast -d '{"prompt": "..."}' &
   curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-deep -d '{"prompt": "..."}' &
   wait
   ```

2. **Compare execution time and output quality**

3. **Track metrics:**
   - Time to completion
   - Token usage (check LocalAI logs)
   - Subjective quality rating (1-5)
   - Task success rate (did the enhanced prompt achieve the goal?)

### Feedback Loop Implementation

To improve the system over time:

1. **Create a feedback workflow:**
   - Webhook: POST /prompt-feedback
   - Input: `{"original_prompt": "...", "variant_used": "precision", "rating": 4, "comments": "..."}`
   - Store in database or file

2. **Periodically review feedback:**
   - Identify patterns in low-rated outputs
   - Adjust system prompts in underperforming stages
   - Fine-tune temperature and max_tokens

3. **Iterate on domain libraries:**
   - Add frequently requested expertise to libraries
   - Remove unused or ineffective injections

---

## Security Considerations

### Data Privacy

**Current implementation:**
- All processing happens locally (no cloud APIs)
- Prompts are not logged by default
- n8n execution data stored in Docker volume

**Recommendations:**
1. **Do not include sensitive data in prompts** (credentials, PII, trade secrets)
2. **Enable n8n's execution data deletion** for compliance:
   - Settings → Executions → "Delete executions automatically after X days"
3. **Restrict n8n access** to authorized users only (enable authentication in docker-compose.yml)

### Webhook Security

**Current state:** Webhooks are unauthenticated (anyone can POST to them)

**To secure:**
1. **Enable n8n webhook authentication:**
   - Edit workflow → Webhook Trigger node
   - Enable "Authentication" → Choose method (Header Auth, Basic Auth)

2. **Use API keys:**
   ```bash
   curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
     -H "Authorization: Bearer YOUR_SECRET_KEY" \
     -H "Content-Type: application/json" \
     -d '{"prompt": "..."}'
   ```

3. **Implement rate limiting** to prevent abuse

---

## Maintenance

### Updating Workflows

When modifying workflows:
1. **Export current version as backup:**
   - Workflow → ⋮ → "Download"
   - Save as `variant-a-full-pipeline-backup-YYYY-MM-DD.json`

2. **Make changes in n8n UI**

3. **Test thoroughly before production use**

4. **Export updated version:**
   - Replace the original JSON file in the repository

### Monitoring

**Check workflow health:**
```bash
# n8n API (if enabled)
curl http://192.168.0.52:5678/rest/executions?limit=10

# Check recent executions in n8n UI
# Navigate to: Executions → View recent runs
```

**Monitor LocalAI performance:**
```bash
# Check GPU utilization
docker exec local-ai rocm-smi

# Check model memory usage
docker stats local-ai

# View inference logs
docker logs local-ai -f | grep "inference"
```

### Backup

**Backup n8n workflows and data:**
```bash
# Backup n8n Docker volume
docker run --rm -v n8n_workstation_data:/data -v $(pwd):/backup ubuntu tar czf /backup/n8n-backup-$(date +%Y%m%d).tar.gz /data

# Backup workflow JSON files
cp -r /run/media/ssjlox/gamer/Github\ Projects/Local-AI-CySec-Workstation/n8n-workflows/prompt-enhancement-system /path/to/backup/
```

---

## Next Steps

1. **Test all three workflow variants** with your actual use cases
2. **Implement domain library auto-injection** (Optional Enhancement)
3. **Create custom domain libraries** for your specific needs (e.g., "cloud_security.json", "appsec.json")
4. **Set up webhook authentication** for production use
5. **Integrate with your existing tools** (e.g., trigger from Slack, save enhanced prompts to Obsidian)

---

## Support and Resources

**Documentation:**
- n8n Docs: https://docs.n8n.io
- LocalAI Docs: https://localai.io/basics/getting_started/
- LiteLLM Docs: https://docs.litellm.ai/

**Your Environment:**
- **n8n Workflows Directory:** `/run/media/ssjlox/gamer/Github Projects/Local-AI-CySec-Workstation/n8n-workflows/`
- **Docker Compose:** `/run/media/ssjlox/gamer/Github Projects/Local-AI-CySec-Workstation/docker-compose.yml`
- **Service Health Checks:**
  - LiteLLM: http://192.168.0.52:4000/health
  - LocalAI: http://192.168.0.52:8080/readyz
  - n8n: http://192.168.0.52:5678/healthz

**Related Documentation:**
- See `CYBERSECURITY_USE_CASES.md` for real-world examples
- See individual domain library JSON files for expertise details

---

## Appendix: Complete API Reference

### Variant A: Full Pipeline

**Endpoint:** `POST /webhook/enhance-prompt`

**Request:**
```json
{
  "prompt": "Your basic prompt here"
}
```

**Response:**
```json
{
  "original_prompt": "string",
  "stage_1_intent": {
    "primary_intent": "string",
    "task_type": "string",
    "complexity": "low|medium|high"
  },
  "stage_2_missing_info": {
    "critical_gaps": ["string"],
    "helpful_additions": ["string"]
  },
  "stage_3_constraints": {
    "technical_constraints": ["string"],
    "business_constraints": ["string"],
    "regulatory_constraints": ["string"]
  },
  "stage_4_risks": {
    "failure_modes": ["string"],
    "mitigation_strategies": ["string"]
  },
  "stage_5_role_context": {
    "optimal_role": "string",
    "context_elements": ["string"]
  },
  "enhanced_prompts": [
    {
      "variant": "precision|creative|balanced",
      "system_prompt": "string",
      "user_prompt": "string"
    }
  ]
}
```

### Variant B: Fast Track

**Endpoint:** `POST /webhook/enhance-prompt-fast`

**Request:** Same as Variant A

**Response:**
```json
{
  "original_prompt": "string",
  "analysis": {
    "intent": "string",
    "missing_info": ["string"],
    "constraints": ["string"],
    "risks": ["string"]
  },
  "enhanced_prompts": [
    {
      "name": "precision|balanced",
      "system_prompt": "string",
      "user_prompt": "string"
    }
  ],
  "pipeline": "fast-track"
}
```

### Variant C: Deep Analysis

**Endpoint:** `POST /webhook/enhance-prompt-deep`

**Request:** Same as Variant A

**Response:**
```json
{
  "metadata": {
    "original_prompt": "string",
    "pipeline_version": "deep-analysis-1.0.0",
    "timestamp": "ISO 8601 string",
    "analysis_branches": 3,
    "models_used": "qwen3-30b"
  },
  "multi_perspective_analysis": {
    "security": {
      "security_requirements": ["string"],
      "threat_model": ["string"],
      "compliance_frameworks": ["string"],
      "data_sensitivity": "public|internal|confidential|restricted",
      "required_controls": ["string"]
    },
    "engineering": {
      "technical_requirements": ["string"],
      "performance_targets": ["string"],
      "integrations": ["string"],
      "testing_scope": ["string"],
      "observability": ["string"]
    },
    "business": {
      "business_objectives": ["string"],
      "stakeholders": ["string"],
      "success_criteria": ["string"],
      "roi_factors": ["string"],
      "timeline": "string"
    },
    "synthesis": {
      "unified_requirements": ["string"],
      "prioritized_constraints": [
        {"constraint": "string", "priority": "high|medium|low"}
      ],
      "comprehensive_risks": [
        {"category": "security|technical|business", "risk": "string", "mitigation": "string"}
      ],
      "role_definition": "string",
      "quality_criteria": ["string"]
    }
  },
  "enhanced_prompts": [
    {
      "name": "security-first|performance-optimized|business-aligned|holistic",
      "system_prompt": "string",
      "user_prompt": "string",
      "output_format": "string",
      "quality_criteria": ["string"],
      "perspective_weights": {
        "security": 0.8,
        "engineering": 0.1,
        "business": 0.1
      }
    }
  ],
  "usage_guide": {
    "security-first": "Use case description",
    "performance-optimized": "Use case description",
    "business-aligned": "Use case description",
    "holistic": "Use case description"
  }
}
```

---

**Document Version:** 1.0.0
**Last Updated:** 2025-12-10
**Author:** Local-AI-CySec-Workstation Project
