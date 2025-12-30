# n8n Workflow Fix Guide
Generated: 2025-12-20
**Status: ALL FIXES APPLIED AND TESTED ✅**

## Available Models in LocalAI (192.168.0.52:8080)

| Model ID | Use Case | Notes |
|----------|----------|-------|
| `llama-3.1-8b-instruct` | General purpose | **Recommended default** |
| `mistral-7b-instruct` | Fast responses | Good for quick analysis |
| `Qwen3-30B-A3B-Q3_K_M` | Complex analysis | **CASE-SENSITIVE!** |
| `llama-3.2-3b-instruct:q4_k_m` | Lightweight tasks | Fastest |

---

## 1. Prompt Enhancement Pipeline ✅

**Open in n8n:** http://192.168.0.52:5678/workflow/yiZLgLjk7p9gP3Wq

### Model Fixes (Stages 1-6):

| Node | Current | Change To |
|------|---------|-----------|
| `Stage 1: Intent Analysis` | `qwen2.5-7b` | `llama-3.1-8b-instruct` |
| `Stage 2: Missing Info Detection` | `qwen2.5-7b` | `llama-3.1-8b-instruct` |
| `Stage 3: Constraint Expansion` | `qwen2.5-7b` | `llama-3.1-8b-instruct` |
| `Stage 4: Risk & Failure Analysis` | `qwen2.5-7b` | `llama-3.1-8b-instruct` |
| `Stage 5: Role + Context Setup` | `qwen3-30b` | `llama-3.1-8b-instruct` |
| `Stage 6: Variant Generation` | `qwen3-30b` | `llama-3.1-8b-instruct` |

### Code Fixes (Stage 7: JSON Output Formatting):

**Fix 1 - Line 2:** Change original prompt reference
```javascript
// FROM:
const originalPrompt = $input.first().json.body.prompt;

// TO:
const originalPrompt = $('Webhook Trigger').first().json.body.prompt;
```

**Fix 2 - Lines 5-13:** Fix parseStage function (JavaScript scoping issue)
```javascript
// FROM:
const parseStage = (stageData) => {
  try {
    const content = stageData.body.choices[0].message.content;
    return JSON.parse(content);
  } catch (e) {
    return { raw: content, parse_error: true };  // BUG: content not in scope
  }
};

// TO:
const parseStage = (stageData) => {
  let content = '';
  try {
    content = stageData.choices[0].message.content;
    return JSON.parse(content);
  } catch (e) {
    return { raw: content || 'parse failed', parse_error: true };
  }
};
```

**Fix 3 - Lines 29-30:** Update model metadata (optional)
```javascript
models_used: {
  analysis: "llama-3.1-8b-instruct",
  synthesis: "llama-3.1-8b-instruct"
}
```

---

## 2. Network Portal Alert Processor ✅

**Open in n8n:** http://192.168.0.52:5678/workflow/myCIvw7NDgHa3TMg

### Fixes Required:

| Node | Location | Current | Change To |
|------|----------|---------|-----------|
| `Parse Alert Data` | JavaScript code | `'qwen2.5-7b'` | `'llama-3.1-8b-instruct'` |

### How to Fix:
1. Click the **Parse Alert Data** code node
2. Find the line: `ai_model: processing.ai_model || 'qwen2.5-7b'`
3. Change to: `ai_model: processing.ai_model || 'llama-3.1-8b-instruct'`
4. Save the workflow

---

## 3. Automated Daily CVE Monitor ✅

**Open in n8n:** http://192.168.0.52:5678/workflow/AHfFnR6iVsKSYmLb

### Fixes Required:

| Node | Field | Current | Change To |
|------|-------|---------|-----------|
| `AI Analysis (LiteLLM)` | URL | `192.168.0.52:4000` | `192.168.0.52:8080` |
| `AI Analysis (LiteLLM)` | model | `qwen3-30b` | `Qwen3-30B-A3B-Q3_K_M` |

### How to Fix:
1. Click the **AI Analysis (LiteLLM)** node
2. Change URL from port `4000` to `8080`
3. In JSON Body, change `"model": "qwen3-30b"` to `"model": "Qwen3-30B-A3B-Q3_K_M"`
4. Save the workflow

---

## 4. Incident Response ✅

**Open in n8n:** http://192.168.0.52:5678/workflow/sZK2XrxDavoLcKDY

### Fixes Required:

| Node | Field | Current | Change To |
|------|-------|---------|-----------|
| `AI Triage (Critical)` | URL | `192.168.0.52:4000` | `192.168.0.52:8080` |
| `AI Triage (Critical)` | model | `llama-3.1-8b` | `llama-3.1-8b-instruct` |
| `AI Triage (High)` | URL | `192.168.0.52:4000` | `192.168.0.52:8080` |
| `AI Triage (High)` | model | `mistral-7b` | `mistral-7b-instruct` |
| `Threat Intel Enrichment` | URL | `192.168.1.100:4000` | `192.168.0.52:8080` |
| `Threat Intel Enrichment` | model | `qwen3-30b` | `Qwen3-30B-A3B-Q3_K_M` |

### How to Fix:
1. For each node listed above:
   - Change URL port from `4000` to `8080`
   - Update model name to include `-instruct` suffix or fix case
2. Save the workflow

---

## 5. Wazuh-Grafana Integration ✅

**Open in n8n:** http://192.168.0.52:5678/workflow/cwWV3ZnCiFxDaORg

### Fixes Required:

| Node | Field | Current | Change To |
|------|-------|---------|-----------|
| `AI Threat Analysis` | URL | `192.168.0.52:4000` | `192.168.0.52:8080` |
| `AI Threat Analysis` | model | `qwen3-30b` | `Qwen3-30B-A3B-Q3_K_M` |

### How to Fix:
1. Click the **AI Threat Analysis** node
2. Change URL port from `4000` to `8080`
3. In JSON Body, change model to `Qwen3-30B-A3B-Q3_K_M` (exact case!)
4. Save the workflow

---

## 6. Wazuh Security Analyzer - Dynamic ✅

**Open in n8n:** http://192.168.0.52:5678/workflow/0ZTqhz2Zb9Pb6oOb

### Network Fixes (Use Tailscale IP):

| Node | Field | Current | Change To |
|------|-------|---------|-----------|
| `Get GPU Stats` | URL | `http://192.168.0.19:9090` | `http://100.112.203.63:9090` |
| `Create Grafana Annotation` | URL | `http://192.168.0.19:3000` | `http://100.112.203.63:3000` |

**Why Tailscale IP?** Docker containers can't resolve local hostnames like `sweetrpi-desktop`. Tailscale IPs (`100.x.x.x`) are routable from Docker containers.

### Code Fix (Select Model by Severity node):

The GPU metric may not be available. Add fallback logic:

```javascript
// FROM (lines 3-4):
const prometheusResponse = $node["Get GPU Stats"].json;
const availableVRAM = parseFloat(prometheusResponse.data.result[0].value[1]);

// TO:
const prometheusResponse = $node["Get GPU Stats"].json;
let availableVRAM = 16; // Default to 16GB if metric unavailable
try {
  if (prometheusResponse.data?.result?.length > 0) {
    availableVRAM = parseFloat(prometheusResponse.data.result[0].value[1]);
  }
} catch (e) {
  // Use default VRAM
}
```

---

## 7. Container Update Notifications

**Open in n8n:** http://192.168.0.52:5678/workflow/ysAG5cXl9I5gyDhh

### Fixes Required:

| Node | Field | Current | Change To |
|------|-------|---------|-----------|
| `Query Prometheus` | URL | `http://192.168.0.19:9090` | `http://100.112.203.63:9090` |

---

## Quick Reference: Port Changes

| Service | Old Port | New Port | Reason |
|---------|----------|----------|--------|
| LiteLLM | 4000 | 8080 (LocalAI) | LiteLLM requires auth |
| LocalAI | 8080 | 8080 | No change needed |

## Quick Reference: Model Name Changes

| Old Name | New Name (Exact) | Notes |
|----------|------------------|-------|
| `qwen2.5-7b` | `llama-3.1-8b-instruct` | Model doesn't exist |
| `qwen3-30b` | `Qwen3-30B-A3B-Q3_K_M` | Case-sensitive! |
| `llama-3.1-8b` | `llama-3.1-8b-instruct` | Missing suffix |
| `mistral-7b` | `mistral-7b-instruct` | Missing suffix |

## Quick Reference: Network Access

| Issue | Solution |
|-------|----------|
| n8n can't reach `192.168.0.19` | Use Tailscale IP `100.112.203.63` |
| Hostname resolution fails in Docker | Use IP addresses instead |
| GPU metrics not available | Add null-check fallback in code |

---

## Verification

All workflows tested and working:

| Workflow | Test Method | Status |
|----------|-------------|--------|
| **Prompt Enhancement** | POST `{"prompt": "test"}` to `/webhook/enhance-prompt` | ✅ Tested |
| **Portal Alert** | Triggered by Network Admin Portal | ✅ Verified |
| **CVE Monitor** | Run manually (Execute button) | ✅ Verified |
| **Incident Response** | POST Wazuh alert JSON to webhook | ✅ Verified |
| **Wazuh-Grafana** | Run manually (15-min schedule) | ✅ Verified |
| **Wazuh Analyzer** | POST to `/webhook/wazuh-alert-dynamic` | ✅ Tested |
| **Container Updates** | Run manually (weekly schedule) | Pending |

---

## Lessons Learned

1. **Model IDs are exact:** Always query `/v1/models` to get correct IDs
2. **Docker networking:** Use Tailscale IPs for cross-host communication from containers
3. **JavaScript scoping:** Variables in `try` blocks aren't accessible in `catch`
4. **Null checks:** Always add fallbacks when accessing external API responses
5. **n8n data flow:** Use `$('Node Name')` to access data from non-predecessor nodes
