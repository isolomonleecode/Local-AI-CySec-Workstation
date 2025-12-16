#!/bin/bash
# Test Phase 3B with LOW severity alert (should use smollm3-3b)

echo "Testing Phase 3B: LOW severity alert (level 3)"
echo "Expected model: huggingfacetb_smollm3-3b (Fast)"
echo ""

curl -X POST http://192.168.0.52:5678/webhook/wazuh-alert-dynamic \
  -H "Content-Type: application/json" \
  -d '{
  "id": "test-low-'$(date +%s)'",
  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'",
  "rule": {
    "level": 3,
    "description": "User login session opened",
    "id": "5501",
    "groups": ["syslog", "pam", "authentication_success"]
  },
  "agent": {
    "id": "001",
    "name": "capcorp9000",
    "ip": "192.168.0.52"
  },
  "full_log": "Dec 15 12:00:00 capcorp9000 sshd[54321]: Accepted publickey for ssjlox from 192.168.0.100 port 45678 ssh2",
  "data": {
    "srcip": "192.168.0.100",
    "srcport": "45678",
    "dstuser": "ssjlox"
  }
}'

echo ""
echo "✅ Request sent. Check n8n execution log and Grafana for annotation."
