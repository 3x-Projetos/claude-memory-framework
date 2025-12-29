# Memory Organization - Local vs Cloud (Optional)

**Version**: 3.4.0
**Date**: 2025-12-29
**Purpose**: Define memory structure with OPTIONAL cloud sync for seamless multi-device interaction

---

## 🎯 Core Principles

1. **Cloud is Optional**: Framework works perfectly with local-only memory
2. **Device-Agnostic**: Works on any device (laptop, desktop, mobile, VM, web VM)
3. **Provider-Agnostic**: Works with Claude, LMStudio, Gemini, or any other agent
4. **No Hardcoded URLs**: Users configure their own cloud repo (if desired)
5. **Privacy-First**: PII stays local unless explicitly marked for sharing

---

## 🏗️ Bootstrap Detection

### On Framework Installation

**Framework checks** (in order):
1. Does `~/.claude-memory/` exist?
   - ✅ Yes → Local memory configured
   - ❌ No → Offer to create

2. Does `~/.claude-memory-cloud/` exist?
   - ✅ Yes → Cloud sync enabled
   - ❌ No → **Ask user if they want cloud sync**

3. Is git configured?
   - ✅ Yes → Can use cloud sync if desired
   - ❌ No → Offer basic git setup guide

### Bootstrap Flow

```
Welcome to Claude Memory Framework!

[1] Local memory not found. Create it? (Y/n): Y
  ✅ Created ~/.claude-memory/

[2] Cloud sync not configured. Enable multi-device sync? (y/N): N
  ℹ️  You can enable cloud sync later with /setup-cloud

[3] Git is configured ✅
  User: your-name
  Email: your-email@example.com

Setup complete! Use /start to begin.
```

**Or, if user wants cloud**:
```
[2] Cloud sync not configured. Enable multi-device sync? (y/N): y

  To use cloud sync, you need:
  - A private GitHub repository for your memories
  - Git configured on this machine

  Git is configured ✅

  Enter your cloud memory repository URL (or press Enter to skip):
  > https://github.com/your-username/your-memory-repo.git

  ✅ Cloning repository...
  ✅ Cloud sync enabled!

Setup complete! Use /start to begin.
```

---

## 📁 Memory Structure

### Mode 1: Local-Only (Default)

**When**: No cloud configured

**Structure**:
```
~/.claude-memory/
├── .config.json                  # sync_enabled: false
├── global-memory.md
├── global-memory.quick.md
├── global-memory.safe.md
│
├── providers/
│   ├── claude/
│   │   ├── session-state.md
│   │   ├── session-state.quick.md
│   │   └── logs/
│   │       ├── daily/
│   │       ├── weekly/
│   │       └── monthly/
│   │
│   ├── lmstudio/
│   └── gemini/
│
└── integration/
    └── provider-activities.md
```

**Agent behavior**:
- Works entirely with local memory
- No git operations
- Fast, simple, private

---

### Mode 2: Local + Cloud (Optional)

**When**: User configured cloud repo

**Structure**:
```
~/.claude-memory/
├── .config.json                  # sync_enabled: true, cloud_repo: "https://..."
├── (same as Mode 1)

~/.claude-memory-cloud/           # Git repo (user's private repo)
├── .gitignore
├── .sync-config.json             # User's sync preferences
├── README.md                     # User can customize
│
├── global/
│   ├── profile.md
│   ├── profile.safe.md
│   └── preferences.json
│
├── devices/
│   ├── laptop-work/
│   ├── desktop-big/
│   └── (user adds devices as they connect)
│
├── projects/
│   └── (user's projects, synced across devices)
│
├── providers/
│   ├── claude/
│   ├── lmstudio/
│   └── gemini/
│
├── sync/
│   ├── device-registry.json
│   └── last-sync.json
│
└── integration/
    └── timeline.md
```

**Agent behavior**:
- Works with local memory during session (fast)
- Syncs to cloud on session start/end (seamless)
- Cross-device context awareness

---

## ⚙️ Configuration File

### `~/.claude-memory/.config.json`

**Local-only mode**:
```json
{
  "version": "3.4.0",
  "sync_enabled": false,
  "device_name": "laptop-work",
  "providers": ["claude", "lmstudio"],
  "privacy": {
    "redact_pii": true,
    "auto_redact": ["email", "phone", "address"]
  }
}
```

**Cloud sync mode**:
```json
{
  "version": "3.4.0",
  "sync_enabled": true,
  "cloud_repo": "https://github.com/your-username/your-memory-repo.git",
  "cloud_path": "~/.claude-memory-cloud",
  "device_name": "laptop-work",
  "providers": ["claude", "lmstudio"],
  "sync": {
    "on_session_start": true,
    "on_session_end": true,
    "auto_commit": true,
    "conflict_resolution": "latest-timestamp"
  },
  "privacy": {
    "redact_pii": true,
    "auto_redact": ["email", "phone", "address"],
    "cloud_safe_only": false
  }
}
```

---

## 🔄 Agent Sync Detection

### On Every Session Start

**Agent checks** (pseudo-code):
```python
# Read config
config = read_json("~/.claude-memory/.config.json")

if config["sync_enabled"]:
    # Cloud sync mode
    cloud_path = config["cloud_path"]

    if not os.path.exists(cloud_path):
        print("⚠️ Cloud sync enabled but repo not found. Run /setup-cloud")
        use_local_only()
    else:
        # Pull from cloud
        os.chdir(cloud_path)
        subprocess.run(["git", "pull"])

        # Load hybrid context
        load_from_cloud(cloud_path)
        load_from_local("~/.claude-memory")
        merge_contexts()
else:
    # Local-only mode
    load_from_local("~/.claude-memory")
```

**Result**:
- ✅ Framework works WITHOUT cloud
- ✅ Framework works WITH cloud (if configured)
- ✅ No hardcoded URLs
- ✅ User controls everything

---

## 🚀 Setup Commands

### `/setup-cloud` - Enable Cloud Sync

**User command**:
```
User: /setup-cloud
```

**Agent prompts**:
```
To enable cloud sync, I need your private GitHub repository URL.

This will allow you to:
✅ Access memories from any device
✅ Sync sessions across devices
✅ Never lose context when switching machines

Requirements:
- A private GitHub repository (create at github.com/new)
- Git configured on this machine

Git configuration:
✅ User: your-username
✅ Email: your-email@example.com

Enter your cloud memory repository URL:
> https://github.com/your-username/your-memory-repo.git

Options:
[1] Clone existing repo (if you set this up on another device)
[2] Initialize new repo (first device setup)

Choice: 2

Creating cloud memory structure...
✅ Created ~/.claude-memory-cloud/
✅ Initialized git repository
✅ Created initial structure
✅ Updated ~/.claude-memory/.config.json

Next steps:
1. Create a private repo at: https://github.com/new
2. Name it: claude-memory-cloud (or any name)
3. Copy the URL and run: /link-cloud <url>

Or, if you already created the repo:
git remote add origin https://github.com/your-username/your-memory-repo.git
git push -u origin main
```

### `/disable-cloud` - Switch to Local-Only

**User command**:
```
User: /disable-cloud
```

**Agent**:
```
Disabling cloud sync...
✅ Updated config (sync_enabled: false)
ℹ️  Your cloud repo (~/.claude-memory-cloud/) is still there
   You can re-enable with /setup-cloud anytime
```

---

## 🛠️ Framework Bootstrap Script

### `session-start.py` (Enhanced)

**Detect and handle cloud**:
```python
import json
import os
import subprocess

# Load config
config_path = os.path.expanduser("~/.claude-memory/.config.json")
if not os.path.exists(config_path):
    # First time setup
    run_bootstrap()
    exit()

with open(config_path) as f:
    config = json.load(f)

# Check cloud sync
if config.get("sync_enabled"):
    cloud_path = os.path.expanduser(config["cloud_path"])

    if os.path.exists(cloud_path):
        # Sync from cloud
        print("🔄 Syncing from cloud...")
        os.chdir(cloud_path)
        result = subprocess.run(["git", "pull"], capture_output=True)

        if result.returncode == 0:
            print("✅ Synced from cloud")
        else:
            print("⚠️ Cloud sync failed (working offline)")
    else:
        print("⚠️ Cloud sync enabled but repo not found")
        print("   Run /setup-cloud to fix")

# Load memory (local + cloud if available)
load_memory(config)
```

---

## 📦 Distribution (Open Source)

### What ships with framework:

**Included**:
- ✅ Local memory structure
- ✅ Bootstrap script (detects cloud)
- ✅ Setup commands (`/setup-cloud`, `/disable-cloud`)
- ✅ Documentation (how to configure cloud)
- ✅ Example `.config.json`

**NOT included** (user provides):
- ❌ Cloud repository URL (user creates their own)
- ❌ Git credentials (user configures)
- ❌ Personal memories (obviously)

### New User Experience

**User installs framework**:
```bash
git clone https://github.com/opensource/claude-memory-system.git
cd claude-memory-system
./install.sh
```

**Bootstrap runs**:
```
Claude Memory Framework v3.4.0

[1] Creating local memory structure...
  ✅ ~/.claude-memory/ created

[2] Cloud sync? (optional)
  ℹ️  Cloud sync lets you access memories from multiple devices
  Enable cloud sync? (y/N): N

  No problem! You can enable it later with /setup-cloud

✅ Setup complete!

Use /start to begin your first session.
```

**User can add cloud LATER**:
```
User: /setup-cloud
Agent: Guides through cloud setup (see above)
```

---

## ✅ Success Criteria

**Framework should**:
✅ Work perfectly WITHOUT cloud (local-only)
✅ Work seamlessly WITH cloud (when configured)
✅ Never assume cloud exists
✅ Never hardcode repository URLs
✅ Let users configure their own cloud repo
✅ Be fully open-source distributable
✅ Support any git provider (GitHub, GitLab, Gitea, etc.)

---

## 🎯 Implementation Checklist

### Phase 1: Local-Only  - COMPLETED
- [x] `~/.claude-memory/` structure
- [x] Local session state
- [x] Local daily logs
- [x] Provider-agnostic design

### Phase 2: Config Detection
 - COMPLETED (v2.3)
- [x] Create `.config.json` schema
- [x] Bootstrap script with cloud detection
- [x] `/setup-cloud` command
- [x] `/disable-cloud` command

### Phase 3: Cloud Sync (Optional)
 - COMPLETED (v2.3.1)
- [x] Cloud memory structure generator
- [x] Sync scripts (auto-sync on `/end`)
- [x] Conflict resolution (latest-timestamp)
- [x] Cross-device timeline (provider-activities.md)

### Phase 4: Polish
 - COMPLETED (v3.4.0)
- [x] Documentation for new users (README, QUICKSTART)
- [x] Migration guide (local -> cloud via `/setup-cloud`)
- [x] Troubleshooting guide (in README.md)
- [x] Progressive context loading (v3.4.0)

---

**End of Organization Guide**
