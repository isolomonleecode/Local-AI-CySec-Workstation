#!/bin/bash
# Test Phase 3B with CRITICAL severity alert (should use Qwen3-30B if VRAM available)

echo "Testing Phase 3B: CRITICAL severity alert (level 12)"
echo "Expected model: Qwen3-30B-A3B-Q3_K_M (Best) if VRAM ≥14GB, else llama-3.1-8b-instruct"
echo ""

curl -X POST http://192.168.0.52:5678/webhook/wazuh-alert-dynamic \
  -H "Content-Type: application/json" \
  -d '{
  "id": "test-critical-'$(date +%s)'",
  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'",
  "rule": {
    "level": 12,
    "description": "Active response: Firewall drop event - possible attack blocked",
    "id": "5715",
    "groups": ["syslog", "sshd", "authentication_failed", "attack"]
  },
  "agent": {
    "id": "001",
    "name": "capcorp9000",
    "ip": "192.168.0.52"
  },
  "full_log": "Dec 15 12:00:00 capcorp9000 kernel: [IPTABLES DROP] IN=eth0 OUT= SRC=203.0.113.45 DST=192.168.0.52 PROTO=TCP SPT=54321 DPT=22 WINDOW=29200 SYN",
  "data": {
    "srcip": "203.0.113.45",
    "dstip": "192.168.0.52",
    "proto": "TCP",
    "dstport": "22"
  }
}'

echo ""
echo "✅ Request sent. Check n8n execution log and Grafana for annotation."
echo ""
echo "💡 TIP: Compare AI analysis quality between models:"
echo "   - Fast model: Quick summary"
echo "   - Balanced model: Good detail"
echo "   - Best model: Comprehensive analysis with deeper context"
