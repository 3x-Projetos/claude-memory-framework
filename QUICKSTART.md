# Quick Start - Claude Memory System

Get started with the Claude Memory System in 5 minutes.

---

## ✅ Already Installed?

If you can see this file, the system is already installed! Skip to "How to Use".

---

## 🚀 Installation

### Option 1: Clone This Repository

```bash
git clone https://github.com/3x-Projetos/claude-memory-framework.git
cd claude-memory-framework

# The framework is ready to use in this directory
```

### Option 2: Install in Existing Project

```bash
# Clone temporary repo
git clone https://github.com/3x-Projetos/claude-memory-framework.git /tmp/cms

# Run bootstrap in your project
bash /tmp/cms/.claude/setup-claude-memory.sh /path/to/your/project

# Cleanup
rm -rf /tmp/cms
```

---

## 💻 How to Use

### First Time

1. **Restart Claude CLI** (if just installed)
2. **Run `/start`** to begin
3. **Work normally** with Claude
4. **Run `/end`** when finished

### Subsequent Sessions

```bash
# Start session showing previous summary
/start

# Choose: continue or start new
> Continue or new? [type your choice]

# Work...

# Save and sync (auto-syncs to cloud if configured)
/end
```

---

## 🎯 Main Commands

| Command | When to Use | What It Does |
|---------|-------------|--------------|
| `/start` | Session start | Load context + show last session |
| `/continue` | Resume work | Load with 85-93% token savings |
| `/memory` | During work | List available tools |
| `/organize` | Organize notes | Process note file |
| `/end` | Session end | Create log + auto cloud sync |

---

## 📝 Complete Example

```
# Day 1 - First session
You: /start
Claude: Tools loaded. No previous session.
        Ready to work!

You: I need to create a REST API
Claude: [works on API...]

You: /end
Claude: [creates log 2025.12.29.md with activities and pending tasks]

---

# Day 2 - Resuming
You: /start
Claude: Last session: 2025-12-29
        Topic: REST API Development

        Pending:
        - [ ] Add authentication
        - [ ] Write tests

        Continue where we left off or new activity?

You: Continue
Claude: Great! Let's work on API authentication...
```

---

## 📋 Note Organization

Want to organize your notes? Use this format:

```markdown
[raw]

My ideas and notes here...
- Topic 1
- Topic 2

---
[prompt]
Identify topics and suggest priorities.

---
[organized]

[Result will appear here after /organize]
```

Then run: `/organize filename.md`

---

## ❓ Questions?

- **Full documentation**: [README.md](README.md)
- **Architecture details**: [MEMORY-ORGANIZATION.md](MEMORY-ORGANIZATION.md)
- **Version history**: [CHANGELOG.md](CHANGELOG.md)
- **See tools**: Run `/memory` in Claude CLI

---

## 🎓 Key Concepts

1. **Memory**: System "remembers" via logs in `YYYY.MM.DD.md`
2. **Hierarchical**: Daily → Weekly → Monthly (85-93% compression)
3. **Commands**: Shortcuts `/start`, `/end`, `/continue`, etc.
4. **Continuity**: Each session can resume the previous one
5. **Cloud Sync**: Optional multi-device sync (auto on `/end`)

---

## ✅ First-Time Checklist

- [ ] System installed (files in `.claude/`)
- [ ] Claude CLI restarted
- [ ] Executed `/start` successfully
- [ ] Tested `/memory` to see tools
- [ ] Executed `/end` when finished
- [ ] Saw log file created (YYYY.MM.DD.md)

---

**You're now using Claude with persistent memory!**

**Next step**: Use `/start` in all sessions and `/end` when finished.

---

*Framework version: 3.4.0*
