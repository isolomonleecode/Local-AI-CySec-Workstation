# Claude Code Integration for n8n

n8n workflows that integrate Claude Code with Telegram, Slack, and Discord for real-time AI coding assistance.

## 📋 Overview

These workflows allow you to interact with Claude Code directly from your favorite messaging platforms:

- **Telegram**: Send messages to your bot and get AI coding help
- **Slack**: Mention your bot in channels or DM it for assistance
- **Discord**: Mention your bot in servers for coding support

### Workflow Versions

| Workflow | Method | Features |
|----------|--------|----------|
| `01-telegram-claude-code.json` | Anthropic API | Basic chat, Telegram polling |
| `02-slack-claude-code.json` | Anthropic API | Basic chat, Slack Events |
| **`02-slack-claude-code-v2.json`** | **SSH to Claude CLI** | **Full tool access, persistent sessions, slash commands** |
| `03-discord-claude-code.json` | Anthropic API | Basic chat, Discord webhook |

## 🆕 Slack Claude Code v2 (SSH-Based)

The v2 workflow uses SSH to execute the Claude Code CLI directly, providing the **full Claude Code experience** from Slack:

### Features
- ✅ Full Claude Code CLI with tool access (file ops, bash, MCP servers)
- ✅ Persistent sessions via `--resume` flag
- ✅ Slash commands: `/help`, `/clear`, `/model`, `/system`, `/sessions`
- ✅ Thread-aware responses
- ✅ No API keys exposed to external services

### Architecture
```
Slack Message → Webhook → n8n → SSH to Workstation → Claude CLI → Response
```

### Setup Requirements
1. **Slack App** with Events API (message.channels scope)
2. **SSH credential** in n8n pointing to your workstation
3. **Claude Code CLI** installed on the target machine
4. **Tailscale Funnel** (or other method) for external webhook URL
5. **WEBHOOK_URL** environment variable set in n8n container

### Configuration Steps

1. **Import workflow** into n8n
2. **Update SSH nodes** - Select your SSH credential on:
   - "SSH Execute Claude CLI" node
   - "SSH List Sessions" node
3. **Update session ID** in "Extract & Detect Commands" node:
   ```javascript
   const sessionId = 'YOUR_CLAUDE_SESSION_ID';  // Use: claude /sessions
   ```
4. **Update SSH cwd** path in both SSH nodes to your project directory
5. **Configure Slack Events API** with your webhook URL:
   - URL: `https://your-domain/webhook/slack-claude-v2`
   - Events: `message.channels`, `app_mention`
6. **Activate** the workflow

### Slash Commands

| Command | Description |
|---------|-------------|
| `/help` | Show available commands |
| `/clear` | Clear thread settings |
| `/model [sonnet\|opus\|haiku]` | Switch Claude model |
| `/system [prompt]` | Set custom system prompt |
| `/sessions` | List Claude CLI sessions |

---

## Original Workflows (API-Based)

## 🚀 Features

- ✅ Real-time messaging integration
- ✅ Code syntax highlighting (markdown/Discord/Slack formatting)
- ✅ Long message splitting (respects platform character limits)
- ✅ Error handling with user-friendly messages
- ✅ Thread/reply support
- ✅ Bot filtering (ignores bot messages to prevent loops)

## 📦 Prerequisites

### Required n8n Credentials

You'll need to set up the following credentials in n8n:

1. **Anthropic API** (`anthropicApi`)
   - API Key from https://console.anthropic.com/
   - Model: `claude-sonnet-4-5-20250929`

2. **Platform-specific credentials:**

   **For Telegram:**
   - Telegram Bot API Token (from @BotFather)
   - Community node: `n8n-nodes-telegram-polling`

   **For Slack:**
   - Slack App with Bot Token
   - Required scopes: `app_mentions:read`, `chat:write`, `im:history`, `im:write`

   **For Discord:**
   - Discord Bot Token
   - Required permissions: `Send Messages`, `Read Message History`

### Installing Community Nodes

For Telegram polling support:

```bash
# In n8n UI: Settings → Community nodes → Install
n8n-nodes-telegram-polling
```

Or via Docker:

```bash
docker exec n8n npm install n8n-nodes-telegram-polling
docker restart n8n
```

## 🔧 Setup Instructions

### 1. Import Workflows

1. Open n8n at http://localhost:5678
2. Click **"Workflows"** → **"Import from File"**
3. Select one of the workflow JSON files:
   - `01-telegram-claude-code.json`
   - `02-slack-claude-code.json`
   - `03-discord-claude-code.json`

### 2. Configure Credentials

Each workflow requires platform-specific credentials:

#### Telegram Setup

1. Create a bot via @BotFather on Telegram
2. Get your bot token
3. In n8n:
   - Go to **Credentials** → **Add Credential** → **Telegram API**
   - Name: `Telegram Bot API`
   - Access Token: Paste your bot token
   - Save

#### Slack Setup

1. Create a Slack App at https://api.slack.com/apps
2. Enable Event Subscriptions:
   - Subscribe to `app_mention` and `message.im` events
   - Set Request URL to your n8n webhook URL
3. Install app to workspace
4. In n8n:
   - Go to **Credentials** → **Add Credential** → **Slack API**
   - Name: `Slack API`
   - Access Token: Your Bot User OAuth Token
   - Save

#### Discord Setup

1. Create a Discord Application at https://discord.com/developers/applications
2. Add a bot to your application
3. Enable required intents: `Server Members`, `Message Content`
4. Invite bot to your server with proper permissions
5. In n8n:
   - Go to **Credentials** → **Add Credential** → **Discord Bot API**
   - Name: `Discord Bot API`
   - Bot Token: Paste your bot token
   - Save

### 3. Configure Anthropic API

1. Get API key from https://console.anthropic.com/
2. In n8n:
   - Go to **Credentials** → **Add Credential** → **Anthropic API**
   - Name: `Anthropic API`
   - API Key: Paste your Anthropic API key
   - Save

### 4. Update Workflow Credentials

For each workflow:

1. Open the workflow
2. Click on each node that requires credentials
3. Select the appropriate credential from the dropdown
4. Save the workflow

### 5. Activate Workflows

1. Open each workflow
2. Toggle the **"Active"** switch in the top right
3. Verify the trigger shows as listening

## 💬 Usage

### Telegram

1. Find your bot on Telegram
2. Start a conversation: `/start`
3. Send any coding question or request
4. Get instant responses from Claude Code

**Example:**
```
You: How do I implement a binary search tree in Python?

Bot: 🤖 Processing your request with Claude Code...

Bot: Here's how to implement a binary search tree in Python:

```python
class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None
...
```

### Slack

1. Invite the bot to a channel: `/invite @YourBotName`
2. Mention the bot: `@YourBotName how do I fix this error?`
3. Or DM the bot directly

**Example:**
```
You: @Claude Can you review this code snippet?

Bot: :robot_face: Processing your request with Claude Code...

Bot: I'll review your code. Here are my observations:
...
```

### Discord

1. Invite bot to your server
2. Mention the bot: `@YourBot help me debug this function`
3. Get responses in thread or as reply

**Example:**
```
You: @ClaudeBot what's wrong with this TypeScript code?

Bot: 🤖 Processing your request with Claude Code...

Bot: I found a few issues in your TypeScript code:
...
```

## 🎛️ Customization

### Adjusting System Prompts

Edit the "Call Claude API" node in each workflow:

```javascript
{
  "name": "system",
  "value": "You are Claude Code, an AI coding assistant. [customize this]"
}
```

### Changing Models

Replace `claude-sonnet-4-5-20250929` with:
- `claude-opus-4-5-20251101` (more capable, slower)
- `claude-haiku-3-5-20241022` (faster, lighter)

### Adjusting Token Limits

Modify `max_tokens` parameter:
- Default: `4096`
- Range: `1` to `8192`

### Message Length Limits

Each platform has different character limits (handled automatically):
- **Telegram**: 4000 characters
- **Slack**: 3900 characters
- **Discord**: 1900 characters

Messages are automatically split if they exceed limits.

## 🔍 Troubleshooting

### Telegram Not Responding

```bash
# Check if polling trigger is active
docker logs n8n | grep -i telegram

# Verify community node is installed
docker exec n8n npm list | grep telegram-polling
```

### Slack Events Not Received

1. Check Event Subscriptions in Slack App settings
2. Verify Request URL is correct (n8n webhook URL)
3. Re-subscribe to events if needed
4. Check Slack app is installed to workspace

### Discord Bot Not Responding

1. Verify bot has `Message Content` intent enabled
2. Check bot has proper permissions in server
3. Ensure bot is online (check Discord Developer Portal)

### Claude API Errors

```bash
# Check API key is valid
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: YOUR_API_KEY" \
  -H "anthropic-version: 2023-06-01"

# Monitor n8n logs for API errors
docker logs n8n --tail 50 | grep -i anthropic
```

### Rate Limiting

Anthropic API has rate limits:
- **Tier 1**: 50 requests/minute
- **Tier 2**: 1000 requests/minute
- **Tier 3**: 2000 requests/minute

Add delay nodes between messages if hitting limits.

## 🛡️ Security Best Practices

1. **API Keys**: Store in n8n credentials, never hardcode
2. **Rate Limiting**: Implement message throttling for public bots
3. **User Filtering**: Add allowlist for sensitive deployments
4. **Logging**: Monitor usage for abuse
5. **Error Messages**: Don't expose sensitive error details to users

## 📊 Monitoring

### Check Workflow Executions

1. n8n UI → **Executions**
2. Filter by workflow name
3. Review success/failure rates
4. Check execution times

### Monitor API Usage

Track Anthropic API usage:
- Dashboard: https://console.anthropic.com/dashboard
- Check token consumption
- Monitor rate limits
- Review billing

## 🔗 Related Resources

- [NetworkChuck's n8n Claude Code Guide](https://github.com/theNetworkChuck/n8n-claude-code-guide)
- [Anthropic API Documentation](https://docs.anthropic.com/)
- [n8n Documentation](https://docs.n8n.io/)
- [Telegram Bot API](https://core.telegram.org/bots/api)
- [Slack API](https://api.slack.com/)
- [Discord Developer Portal](https://discord.com/developers/docs)

## 📝 Workflow Structure

All workflows follow this pattern:

```
Trigger (Telegram/Slack/Discord)
  ↓
Send Acknowledgment
  ↓
Extract Message Data
  ↓
Call Claude API
  ↓
Format Response (split if needed)
  ↓
Send Response
  ↓
Error Handler (if API fails)
```

## 🎯 Next Steps

1. **Add Conversation Memory**: Implement Redis/database to store chat history
2. **Multi-turn Conversations**: Track context across messages
3. **File Uploads**: Add support for code file analysis
4. **Slash Commands**: Create custom commands for common tasks
5. **Analytics**: Track usage patterns and popular queries

## 💡 Tips

- Start with Telegram (easiest setup with polling)
- Test in private channels/DMs before public deployment
- Monitor first 100 executions closely
- Set up alerts for failed executions
- Create usage guidelines for your team

---

**Created:** 2025-12-11
**Author:** Claude Code + Your Name
**License:** MIT
**Version:** 1.0.0
