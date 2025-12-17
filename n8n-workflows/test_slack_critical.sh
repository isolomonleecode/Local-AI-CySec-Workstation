#!/bin/bash
# Test Phase 3C with CRITICAL severity to trigger Slack notification

echo "Testing Phase 3C: CRITICAL severity alert (level 12)"
echo "Expected: Slack notification + Grafana annotation"
echo ""

curl -X POST http://192.168.0.52:5678/webhook/wazuh-alert-dynamic \
  -H "Content-Type: application/json" \
  -d '{
  "id": "test-slack-'$(date +%s)'",
  "timestamp": "'$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")'",
  "rule": {
    "level": 12,
    "description": "Possible SQL injection attack detected",
    "id": "31106",
    "groups": ["web", "attack", "sql_injection"]
  },
  "agent": {
    "id": "002",
    "name": "webserver-prod",
    "ip": "192.168.0.100"
  },
  "full_log": "Dec 15 21:30:00 webserver-prod nginx: 203.0.113.45 - - [15/Dec/2025:21:30:00] \"GET /api/users?id=1 OR 1=1 HTTP/1.1\" 403",
  "data": {
    "srcip": "203.0.113.45",
    "srcport": "54321",
    "url": "/api/users?id=1 OR 1=1",
    "method": "GET"
  }
}'

echo ""
echo "✅ Request sent."
echo ""
echo "Expected results:"
echo "  1. n8n workflow executes"
echo "  2. AI analyzes the SQL injection attempt"
echo "  3. Grafana annotation created"
echo "  4. 🔔 Slack notification sent to #security-alerts"
echo ""
echo "Check Slack channel: #security-alerts"
