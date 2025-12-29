# Claude Memory System

[![Version](https://img.shields.io/badge/version-3.4.0-blue.svg)](https://github.com/3x-Projetos/claude-memory-framework/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude CLI](https://img.shields.io/badge/Claude-CLI-orange.svg)](https://github.com/anthropics/claude-code)

Persistent, hierarchical memory system for Claude CLI with multi-device sync and progressive context loading.

---

## Overview

Claude Memory System enables seamless continuity across AI sessions through intelligent memory management. It automatically compresses session context, saving 85-93% of tokens while maintaining perfect recall. Works locally by default, with optional cloud sync for multi-device workflows.

**Key Stats**:
- 🎯 85-93% token savings on session startup
- 🔄 Automatic context compression (daily → weekly → monthly)
- 🌐 Optional multi-device sync (works offline too)
- 🔧 5 auto-activating skills for enhanced workflows
- 🛡️ Privacy-first with PII redaction

---

## Why Use This?

✅ **Never lose context** - Sessions automatically remember previous work
✅ **Save tokens** - Progressive loading reduces context by 85-93%
✅ **Work anywhere** - Optional cloud sync across all devices
✅ **Auto-organized** - Hierarchical memory (daily → weekly → monthly)
✅ **Project-aware** - Track multiple projects independently
✅ **Privacy-first** - Automatic PII redaction before cloud sync

---

## Quick Start

1. Install the framework (see [QUICKSTART.md](QUICKSTART.md))
2. Run `/start` to initialize session
3. Work normally with Claude
4. Run `/end` to save session (auto-syncs if cloud configured)
5. Next session: `/continue` resumes where you left off

**Full installation guide**: [QUICKSTART.md](QUICKSTART.md)

---

## Core Features

### 🆕 Progressive Loading (v3.4.0)
Smart context management with session type templates:
- Quick fix: <25% context budget
- Feature work: <50% context
- Research tasks: <60% context
- Architecture work: <70% context

**Docs**: [CLI-CONTEXT-LOADING.md](CLI-CONTEXT-LOADING.md)

### Skills System (v3.0)
5 auto-activating skills based on intent:
- 🔬 **scientist** - Universal scientific thinking framework
- 🔄 **session-continuity-assistant** - Intelligent multi-device resumption
- 📓 **note-organizer** - Systematic note processing
- 🌱 **personal-growth** - Reflection and growth tracking
- 📝 **end** - Session finalization

Skills activate automatically when relevant (no explicit invocation needed).

### Cloud Sync (v2.3+)
Optional multi-device memory:
- Auto-syncs on `/end` (v2.3.1)
- Works perfectly without cloud (local-only by default)
- Any git provider (GitHub, GitLab, Gitea)
- User-configurable paths (no hardcoded URLs)

**Setup**: Run `/setup-cloud` command

### Multi-Provider (v2.2)
Supports multiple AI providers:
- Claude CLI (primary)
- LM Studio (local models)
- Unified timeline across providers

### Hierarchical Memory (v2.0)
Automatic compression saves tokens:
- Daily logs → Weekly summaries (85% savings)
- Weekly → Monthly summaries (93% savings)
- Quick files for instant resume (~1k tokens)

**See full version history**: [CHANGELOG.md](CHANGELOG.md)

---

## How It Works

1. **Session Start**: `/start` loads quick memories (~1k tokens)
2. **Working**: Claude has full context from previous sessions
3. **Session End**: `/end` creates structured log + auto-syncs to cloud (if configured)
4. **Aggregation**: Daily → Weekly → Monthly compression (automatic on schedule)
5. **Resumption**: Next `/continue` loads compressed summaries instead of full logs

**Memory location**: `~/.claude-memory/`  
**Cloud sync** (optional): User-configured git repository

---

## Documentation

| File | Purpose |
|------|---------|
| [QUICKSTART.md](QUICKSTART.md) | 5-minute installation guide |
| [CHANGELOG.md](CHANGELOG.md) | Complete version history (v2.0 → v3.4) |
| [MEMORY-ORGANIZATION.md](MEMORY-ORGANIZATION.md) | Architecture deep dive (local vs cloud) |
| [CLI-CONTEXT-LOADING.md](CLI-CONTEXT-LOADING.md) | Progressive loading implementation |
| `.claude/commands/` | All slash commands documentation |
| `.claude/skills/` | Skills system details |
| `.claude/workflows/` | Workflow documentation (8 files) |

---

## Common Commands

| Command | Purpose |
|---------|---------|
| `/start` | Start session, load context |
| `/continue` | Resume from last session |
| `/end` | Save session & sync to cloud |
| `/switch [project]` | Change active project |
| `/projects` | List all projects dashboard |
| `/organize [file]` | Process and structure notes |
| `/reflect` | Log well-being metrics |
| `/setup-cloud` | Configure cloud sync |

**Full command reference**: [.claude-memory.md](.claude-memory.md)

---

## Troubleshooting

**Cloud sync failed**  
→ Check `.config.json` has valid `cloud_path` configured

**Skills not activating**  
→ Skill descriptions must match task intent/keywords

**Context usage too high**  
→ Use `/compact` command or reference files with `@filename` instead of reading

**Can't find session logs**  
→ Check `~/.claude-memory/providers/claude/logs/daily/`

**Session won't load**  
→ Verify `session-state.md` exists in `providers/claude/`

---

## Project Status

**Version**: 3.4.0 (2025-12-29)  
**Status**: Production-ready  
**License**: MIT  
**Repository**: https://github.com/3x-Projetos/claude-memory-framework

**Recent Updates**:
- v3.4.0: Progressive context loading (-40-50% context usage)
- v3.3.0: SOTA skills optimization (-90% skill file size)
- v3.0.0: Auto-activating skills system
- v2.3.1: Automatic cloud sync on `/end`

See [CHANGELOG.md](CHANGELOG.md) for complete version history.

---

## Contributing

Issues and pull requests welcome!  
Repository: https://github.com/3x-Projetos/claude-memory-framework

---

## License

MIT License - See [LICENSE](LICENSE) file for details.
