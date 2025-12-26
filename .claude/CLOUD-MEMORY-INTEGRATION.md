# Cloud Memory Integration Guide

**Integrating multi-device cloud sync with the Claude Memory Framework**

> **Version**: 1.0
> **Created**: 2024-12-26
> **Framework Version**: 2.2+

---

## 🎯 Overview

This guide explains how to integrate the **cloud memory repository** (`claude-memory-cloud`) with your local **framework repository** (`claude-memory-system`).

**Two Repositories:**
1. **Framework** (`claude-memory-system`) - PUBLIC
   - Slash commands, workflows, hooks
   - Shared with community
   - Location: Project directories

2. **Cloud Memory** (`claude-memory-cloud`) - PRIVATE
   - Your personal memories, profiles, sessions
   - Synced across your devices
   - Location: `~/.claude-memory-cloud/`

---

## 🚀 Setup on Each Device

### Step 1: Clone Framework (if not already done)

```bash
# Clone the framework repo to a project directory
git clone https://github.com/3x-Projetos/claude-memory-system.git ~/projects/my-work

cd ~/projects/my-work
```

### Step 2: Setup Cloud Memory

**Option A: Automated Setup (Recommended)**

```bash
# Run the setup script from framework
bash .claude/setup-cloud-memory.sh

# This will clone the cloud memory repo to ~/.claude-memory-cloud
```

**Option B: Manual Setup**

```bash
# Clone cloud memory directly
git clone https://github.com/3x-Projetos/claude-memory-cloud.git ~/.claude-memory-cloud
```

### Step 3: Verify Integration

```bash
# Check framework is present
ls ~/projects/my-work/.claude/

# Check cloud memory is present
ls ~/.claude-memory-cloud/
```

**Expected result:**
- Framework: Local to your project
- Cloud memory: In your home directory (`~/.claude-memory-cloud/`)

---

## 📂 How They Work Together

### Framework (Local Project)
```
~/projects/my-work/
├── .claude/
│   ├── commands/          # Slash commands
│   ├── hooks/             # Session hooks
│   └── workflows/         # Documented processes
├── .session-state.md      # Current session (local)
└── logs/                  # Project-specific logs
```

### Cloud Memory (Home Directory)
```
~/.claude-memory-cloud/
├── global/
│   ├── profile.md         # Your preferences (synced)
│   └── preferences.json   # Settings (synced)
├── devices/               # Device-specific state
├── projects/              # Cross-device project contexts
└── providers/             # Provider timelines
```

### Integration Points

**Session Start (`/start`, `/continue`, `/new`):**
1. Pull from cloud memory: `cd ~/.claude-memory-cloud && git pull`
2. Load global profile from cloud
3. Load project context from cloud (if multi-project)
4. Load local session state from framework

**Session End (`/end`):**
1. Save local session state (framework)
2. Update cloud memory (project activity, timeline)
3. Commit and push: `cd ~/.claude-memory-cloud && git commit && git push`

---

## 🔄 Automatic Sync (via Hooks)

### Current Hooks (Framework)

The framework has these hooks in `.claude/settings.json`:
- `SessionStart` - Runs at CLI startup
- `SessionEnd` - Runs at CLI shutdown (if supported)
- `PreToolUse` - Runs before tool executions

### Cloud Sync Integration (Coming in v2.3)

**Enhanced `session-start.py`:**
```python
# 1. Lazy logging (existing)
# 2. NEW: Cloud memory sync
if os.path.exists(os.path.expanduser("~/.claude-memory-cloud")):
    os.chdir(os.path.expanduser("~/.claude-memory-cloud"))
    subprocess.run(["git", "pull", "--rebase"], capture_output=True)
    # Load global profile
```

**Enhanced `session-auto-end.py`:**
```python
# 1. Create session log (existing)
# 2. NEW: Cloud memory sync
if os.path.exists(os.path.expanduser("~/.claude-memory-cloud")):
    os.chdir(os.path.expanduser("~/.claude-memory-cloud"))
    subprocess.run(["git", "add", "."])
    subprocess.run(["git", "commit", "-m", f"Session update: {timestamp}"])
    subprocess.run(["git", "push"])
```

---

## 🛠️ Manual Sync Commands

### Pull Latest from Cloud
```bash
cd ~/.claude-memory-cloud
git pull
```

**When to use:**
- Before starting work
- After working on another device
- If sync failed automatically

### Push Changes to Cloud
```bash
cd ~/.claude-memory-cloud
git add .
git commit -m "Update from $(hostname)"
git push
```

**When to use:**
- After manual changes to cloud memory files
- If automatic push failed
- Before switching devices

### Check Sync Status
```bash
cd ~/.claude-memory-cloud
git status                # Local changes
git log --oneline -5      # Recent commits
git remote -v             # Remote repo
```

---

## 📱 Multi-Device Workflow

### Scenario: Work on Laptop, Continue on Desktop

**Morning (laptop-work):**
```bash
# Start Claude Code
# Hooks automatically:
#   1. git pull from cloud (gets latest)
#   2. Loads your profile and contexts

# Work on project
/continue
# ... work ...
/end

# Hooks automatically:
#   1. Updates cloud memory
#   2. git commit && git push
```

**Afternoon (desktop-big):**
```bash
# Start Claude Code
# Hooks automatically:
#   1. git pull from cloud (sees laptop changes!)
#   2. Loads updated contexts

# Continue work
/continue
# Claude knows exactly where you left off!
```

---

## ⚠️ Troubleshooting

### "Git pull failed"

**Cause**: Network issue or merge conflict

**Solution**:
```bash
cd ~/.claude-memory-cloud
git status
git pull --rebase
# If conflict, resolve manually
```

### "Cloud memory not found"

**Cause**: Haven't run setup yet

**Solution**:
```bash
bash .claude/setup-cloud-memory.sh
```

### "Permission denied (GitHub)"

**Cause**: Git credentials not configured

**Solution**:
```bash
# Setup Git credentials
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# For HTTPS (use Personal Access Token as password)
# Generate token: https://github.com/settings/tokens
```

### "Merge conflict in profile.md"

**Cause**: Edited profile on multiple devices simultaneously

**Solution**:
```bash
cd ~/.claude-memory-cloud
git status                    # See conflicted files
code global/profile.md        # Edit, remove conflict markers
git add global/profile.md
git commit -m "Resolved profile conflict"
git push
```

---

## 🔐 Privacy & Security

### What's Private?

**Cloud Memory Repo (`claude-memory-cloud`):**
- ✅ **MUST** be Private on GitHub
- Contains your personal data
- Device information
- Session histories

**Framework Repo (`claude-memory-system`):**
- ✅ **CAN** be Public
- Contains only code/workflows
- No personal data

### PII Protection

**Automatic redaction** (when implemented):
- `global/profile.md` - Full profile (with PII)
- `global/profile.safe.md` - Auto-generated, PII redacted
- Framework hooks load `.safe.md` for AI context

**Manual marking**:
```markdown
Name: [PII:NAME]Your Name[/PII:NAME]
Email: [PII:EMAIL]you@example.com[/PII:EMAIL]
```

---

## 📋 Checklist: Setup on New Device

- [ ] Clone framework repo to project directory
- [ ] Run `bash .claude/setup-cloud-memory.sh`
- [ ] Verify cloud memory cloned: `ls ~/.claude-memory-cloud/`
- [ ] Start Claude Code in framework directory
- [ ] Test pull: `cd ~/.claude-memory-cloud && git pull`
- [ ] Make a change and test push
- [ ] Verify change appears on GitHub

---

## 🚧 Future Enhancements (v2.3+)

### Planned Features

1. **Automatic device registration**
   - First session auto-detects and registers device
   - Updates `sync/device-registry.json`

2. **Conflict resolution UI**
   - Visual diff for conflicts
   - Smart merge strategies

3. **Offline sync queue**
   - Queue changes when offline
   - Auto-sync when connection restored

4. **Sync status in prompts**
   - Show sync status in `/continue` output
   - Alert if cloud memory is out of sync

5. **Device migration wizard**
   - Guided device replacement
   - Preserves history seamlessly

---

## 📖 Related Documentation

- **Setup Scripts**:
  - `.claude/setup-cloud-memory.sh` - Clone cloud memory repo
  - `.claude/populate-cloud-memory.sh` - Initialize structure

- **Cloud Memory Repo**:
  - `~/.claude-memory-cloud/README.md` - Complete guide
  - `~/.claude-memory-cloud/future-projects/` - Future plans

- **Framework**:
  - `.claude-memory.md` - Framework toolbox index
  - `.claude/README.md` - Framework documentation

---

## 💡 Best Practices

### Do:
✅ Commit small, frequent changes
✅ Use descriptive commit messages
✅ Pull before starting work
✅ Push after ending session
✅ Review conflicts carefully
✅ Keep cloud memory repo private

### Don't:
❌ Commit sensitive credentials
❌ Force push (risk losing data)
❌ Edit same file on multiple devices simultaneously
❌ Make cloud memory repo public
❌ Skip pulling before starting work

---

## 🤝 Contributing

If you enhance the cloud memory integration:
1. Document changes in this file
2. Update scripts if needed
3. Test on multiple devices
4. Share improvements via framework repo

---

**Version History:**

- **v1.0** (2024-12-26): Initial cloud memory integration
  - Setup and population scripts
  - Documentation
  - Multi-device sync strategy

---

**Created**: 2024-12-26
**Last Updated**: 2024-12-26
**Maintained by**: Framework users
