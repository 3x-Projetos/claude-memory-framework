#!/bin/bash
#
# Claude Memory Cloud - Population Script
#
# This script creates all the initial files in your cloud memory repo
# Run this AFTER cloning the cloud memory repo
#
# Usage:
#   cd ~/.claude-memory-cloud
#   bash /path/to/populate-cloud-memory.sh
#

set -e

CLOUD_DIR="${1:-$HOME/.claude-memory-cloud}"

echo "=========================================="
echo "Populating Cloud Memory Repository"
echo "=========================================="
echo ""
echo "Target directory: $CLOUD_DIR"
echo ""

# Verify we're in the right place
if [ ! -d "$CLOUD_DIR/.git" ]; then
    echo "❌ Error: $CLOUD_DIR is not a git repository"
    echo "Please run setup-cloud-memory.sh first"
    exit 1
fi

cd "$CLOUD_DIR"

echo "📝 Creating directory structure..."

# Create directories
mkdir -p devices/{laptop-work,laptop-personal,desktop-small,desktop-big,android-phone}
mkdir -p global
mkdir -p projects
mkdir -p providers/{claude,lmstudio,gemini}
mkdir -p sync/{conflicts,logs}
mkdir -p integration
mkdir -p future-projects

echo "✅ Directories created"
echo ""
echo "📝 Creating configuration files..."

# .gitignore
cat > .gitignore << 'GITIGNORE_EOF'
# Claude Memory Cloud - Git Ignore Configuration
# Private memory repository - tracks centralized memory across devices

# ===========================
# Temporary files (local cache, NOT synced)
# ===========================
*.tmp
*.bak
*.cache
.DS_Store
Thumbs.db

# ===========================
# Sync state (runtime only, NOT committed)
# ===========================
sync/.sync-lock
sync/.last-sync-timestamp
sync/.conflict-resolution-pending

# ===========================
# Device-specific temp files
# ===========================
devices/*/.active-session
devices/*/.cache

# ===========================
# WHAT TO VERSION (core memory):
# ===========================
# global/                      - User profile, preferences
# devices/*/                   - Device info, last-active
# projects/*/                  - Project contexts and status
# providers/*/                 - Provider state and timelines
# integration/                 - Unified cross-device timeline
# future-projects/             - Ideas and future work
# sync/logs/                   - Sync history (for debugging)
# sync/device-registry.json    - Known devices
# README.md, docs/             - Documentation
GITIGNORE_EOF

# .sync-config.json
cat > .sync-config.json << 'SYNCCONFIG_EOF'
{
  "version": "1.0",
  "auto_sync": true,
  "conflict_resolution": "latest-timestamp",
  "sync_on_session_start": true,
  "sync_on_session_end": true,
  "current_device": "unknown",
  "sync_providers": {
    "git": {
      "enabled": true,
      "remote": "origin",
      "branch": "main",
      "auto_push": true,
      "auto_pull": true
    }
  },
  "mobile": {
    "wifi_only": false,
    "sync_when_charging": true,
    "max_cellular_mb": 10
  },
  "offline_mode": {
    "queue_changes": true,
    "max_queue_size_mb": 50,
    "notify_pending_sync": true
  }
}
SYNCCONFIG_EOF

# sync/device-registry.json
cat > sync/device-registry.json << 'DEVICEREG_EOF'
{
  "version": "1.0",
  "created": "2024-12-26",
  "last_updated": "2024-12-26",
  "devices": {
    "laptop-work": {
      "status": "pending",
      "os": null,
      "first_seen": null,
      "last_active": null,
      "sync_enabled": true,
      "hardware_id": null,
      "notes": "Primary work laptop - awaiting registration"
    },
    "laptop-personal": {
      "status": "pending",
      "os": null,
      "first_seen": null,
      "last_active": null,
      "sync_enabled": true,
      "hardware_id": null,
      "notes": "Personal laptop - awaiting registration"
    },
    "desktop-small": {
      "status": "pending",
      "os": null,
      "first_seen": null,
      "last_active": null,
      "sync_enabled": true,
      "hardware_id": null,
      "notes": "Small desktop - awaiting registration"
    },
    "desktop-big": {
      "status": "pending",
      "os": null,
      "first_seen": null,
      "last_active": null,
      "sync_enabled": true,
      "hardware_id": null,
      "notes": "Large desktop - awaiting registration"
    },
    "android-phone": {
      "status": "pending",
      "os": "Android",
      "first_seen": null,
      "last_active": null,
      "sync_enabled": true,
      "hardware_id": null,
      "notes": "Mobile device - awaiting Android wrapper app"
    }
  }
}
DEVICEREG_EOF

echo "✅ Configuration files created"
echo ""
echo "📝 Creating documentation (this may take a moment)..."

# Copy README.md from the source
cat > README.md << 'README_EOF'
# Claude Memory Cloud

**Private memory repository for multi-device AI agent interactions**

> **Version**: 1.0 (Cloud Sync)
> **Created**: 2024-12-26
> **Type**: Private Git Repository (Centralized Memory)

---

## 🎯 What Is This?

This is your **centralized memory store** for Claude Code and other AI agents. It allows you to:

- 🔄 **Sync memories across devices** (laptop, desktop, phone)
- 🧠 **Maintain continuity** - start work on one device, continue on another
- 📱 **Cross-platform** - same memory on Linux, macOS, Windows, Android
- 🔒 **Private by default** - your data, your control
- 📊 **Track everything** - all devices, all agents, unified timeline

For complete documentation, see the README.md file in the cloud memory repository on GitHub:
https://github.com/3x-Projetos/claude-memory-cloud

---

## 📁 Directory Structure

```
~/.claude-memory-cloud/
├── global/                      # Cross-device user memory
├── devices/                     # Per-device state (5 devices)
├── projects/                    # Cross-device projects
├── providers/                   # Multi-provider state
├── sync/                        # Sync metadata
├── integration/                 # Unified timeline
└── future-projects/             # Enhancement ideas
```

---

## 🚀 Quick Start

### First Time Setup

**On your first device:**
```bash
# Clone this repository
git clone https://github.com/3x-Projetos/claude-memory-cloud.git ~/.claude-memory-cloud

# Verify
cd ~/.claude-memory-cloud
ls -la
```

**On additional devices:**
```bash
# Same command - clone on each device
git clone https://github.com/3x-Projetos/claude-memory-cloud.git ~/.claude-memory-cloud
```

---

## 🔄 How Sync Works

**Automatic** (via hooks in framework):
- Session Start: `git pull` (get latest from other devices)
- Session End: `git commit && git push` (share your changes)

**Manual:**
```bash
cd ~/.claude-memory-cloud

# Get latest
git pull

# Save and share changes
git add .
git commit -m "Update from [device-name]"
git push
```

---

## 📖 Full Documentation

All files in this repo have detailed documentation.See:
- `global/README.md` - Global memory structure
- `future-projects/android-wrapper.md` - Mobile app planning
- `future-projects/device-migration.md` - Device replacement workflow

---

**Developed with Claude Code** 🤖
*Your memory, everywhere you work*
README_EOF

echo "✅ README created"
echo ""

# Create placeholder files for documentation
echo "# Global Memory README - See main README for details" > global/README.md
echo "# User Profile - Edit this file with your preferences" > global/profile.md
echo '{"version": "1.0"}' > global/preferences.json
echo "# Unified Timeline - Auto-populated by sync system" > integration/timeline.md

echo "✅ Initial files created"
echo ""
echo "=========================================="
echo "Population complete!"
echo "=========================================="
echo ""
echo "📊 Summary:"
find . -type f -not -path './.git/*' | wc -l | xargs echo "   Files created:"
find . -type d -not -path './.git*' | wc -l | xargs echo "   Directories:"
echo ""
echo "Next steps:"
echo "1. Review the files created"
echo "2. Edit global/profile.md with your preferences"
echo "3. Commit and push:"
echo "     git add ."
echo "     git commit -m 'Initial commit: Cloud memory infrastructure'"
echo "     git push -u origin main"
echo ""
