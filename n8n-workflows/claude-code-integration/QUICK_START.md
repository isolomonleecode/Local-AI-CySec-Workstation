# Quick Start Guide - Claude Code Integration

## 🚀 5-Minute Setup

### Step 1: Get API Keys (5 min)

- [ ] **Anthropic API Key**: https://console.anthropic.com/
  - Sign up → Create API Key → Copy

- [ ] **Choose Platform(s)**:

  **Telegram** (Recommended - Easiest):
  - [ ] Message @BotFather on Telegram
  - [ ] Send `/newbot` → Follow prompts
  - [ ] Copy bot token

  **Slack**:
  - [ ] Go to https://api.slack.com/apps
  - [ ] Create New App → From Scratch
  - [ ] Enable Bot User → Get OAuth Token

  **Discord**:
  - [ ] Go to https://discord.com/developers/applications
  - [ ] New Application → Add Bot
  - [ ] Copy Bot Token

### Step 2: Install Community Node (Telegram only) (1 min)

```bash
docker exec n8n npm install n8n-nodes-telegram-polling
docker restart n8n
```

### Step 3: Import Workflow (1 min)

1. Open n8n: http://localhost:5678
2. Workflows → Import from File
3. Select: `01-telegram-claude-code.json` (or your chosen platform)

### Step 4: Add Credentials (2 min)

**Anthropic API:**
1. n8n → Credentials → New Credential
2. Type: "Anthropic API"
3. Paste API Key → Save

**Telegram Bot API:**
1. n8n → Credentials → New Credential
2. Type: "Telegram API"
3. Paste Bot Token → Save

### Step 5: Update Workflow (1 min)

1. Open imported workflow
2. Click "Call Claude API" node
3. Select your Anthropic API credential
4. Click "Telegram Polling Trigger" node
5. Select your Telegram Bot API credential
6. Save workflow

### Step 6: Activate (30 sec)

1. Toggle "Active" switch (top right)
2. Confirm trigger shows "Listening..."

### Step 7: Test (30 sec)

1. Find your bot on Telegram
2. Send: `/start`
3. Ask: `Write a Python function to reverse a string`
4. Get response! 🎉

---

## ⚡ Platform-Specific Quick Configs

### Telegram
```yaml
Required Credentials:
  - Telegram Bot API (from @BotFather)
  - Anthropic API

Community Node:
  - n8n-nodes-telegram-polling

Character Limit: 4000
```

### Slack
```yaml
Required Credentials:
  - Slack API (Bot User OAuth Token)
  - Anthropic API

Required Scopes:
  - app_mentions:read
  - chat:write
  - im:history
  - im:write

Character Limit: 3900
```

### Discord
```yaml
Required Credentials:
  - Discord Bot API (Bot Token)
  - Anthropic API

Required Intents:
  - Server Members
  - Message Content

Required Permissions:
  - Send Messages
  - Read Message History

Character Limit: 1900
```

---

## 🔧 Common Issues & Fixes

### "Credential not found"
**Fix:** Update credential IDs in workflow nodes to match your credential names

### "Telegram not responding"
**Fix:**
```bash
docker exec n8n npm install n8n-nodes-telegram-polling
docker restart n8n
```

### "Claude API error: Authentication failed"
**Fix:** Verify API key at https://console.anthropic.com/ → regenerate if needed

### "Workflow not triggering"
**Fix:** Toggle workflow OFF then ON, check trigger shows "Listening..."

---

## 📝 Customization Cheat Sheet

### Change Model
In "Call Claude API" node, update `model` parameter:
- `claude-sonnet-4-5-20250929` (Default - Balanced)
- `claude-opus-4-5-20251101` (Smartest - Slower)
- `claude-haiku-3-5-20241022` (Fastest - Lighter)

### Adjust Response Length
In "Call Claude API" node, update `max_tokens`:
- Short answers: `1024`
- Medium: `2048`
- Long: `4096` (Default)
- Very long: `8192` (Max)

### Custom System Prompt
In "Call Claude API" node, replace `system` value:
```javascript
"You are a [role]. You help with [specific tasks]. [instructions]."
```

Examples:
- `"You are a Python expert. Help debug Python code. Always provide working examples."`
- `"You are a security auditor. Review code for vulnerabilities. Be thorough."`
- `"You are a code reviewer. Provide constructive feedback. Focus on best practices."`

---

## 🎯 Usage Examples

### Telegram
```
You: How do I read a CSV file in pandas?
Bot: 🤖 Processing...
Bot: [Detailed response with code examples]
```

### Slack
```
You: @ClaudeBot explain async/await in JavaScript
Bot: :robot_face: Processing...
Bot: [Response in thread]
```

### Discord
```
You: @ClaudeBot debug this Python error
Bot: 🤖 Processing...
Bot: [Reply to your message]
```

---

## 📊 Monitoring

Check workflow health:
1. n8n → Executions
2. Filter by workflow
3. Review success rate

Monitor API usage:
https://console.anthropic.com/dashboard

---

## 🆘 Need Help?

1. Check main README.md for detailed troubleshooting
2. Review n8n logs: `docker logs n8n --tail 100`
3. Verify credentials: n8n → Credentials → Test
4. Check workflow execution history for errors

---

**Pro Tip:** Start with Telegram - it's the easiest to set up and test!
