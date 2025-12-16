#!/bin/bash
# Test Phase 3B with MEDIUM severity alert (should use llama-3.1-8b-instruct)

echo "Testing Phase 3B: MEDIUM severity alert (level 8)"
echo "Expected model: llama-3.1-8b-instruct (Balanced)"
echo ""

curl -X POST http://192.168.0.52:5678/webhook/wazuh-alert-dynamic \
  -H "Content-Type: application/json" \
  -d '{
  "id": "test-medium-'$(date +%s)'",
  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'",
  "rule": {
    "level": 8,
    "description": "Multiple authentication failures",
    "id": "5710",
    "groups": ["syslog", "sshd", "authentication_failed"]
  },
  "agent": {
    "id": "001",
    "name": "capcorp9000",
    "ip": "192.168.0.52"
  },
  "full_log": "Dec 15 12:00:00 capcorp9000 sshd[12345]: Failed password for invalid user test from 198.51.100.25 port 52341 ssh2",
  "data": {
    "srcip": "198.51.100.25",
    "srcport": "52341",
    "dstuser": "test"
  }
}'

echo ""
echo "✅ Request sent. Check n8n execution log and Grafana for annotation."
