# Claude Memory System - Framework Guide

Multi-device memory system for AI providers. This complements ~/.claude/CLAUDE.md with framework-specific context.

## 🚨 CRITICAL: Data Accuracy

**ABSOLUTE RULE - NEVER INVENT DATA**:
- ❌ NO fabricated numbers (costs, metrics, percentages, benchmarks)
- ❌ NO made-up status values (Ctx%, 5H%, WK%)
- ❌ NO guessed pricing or specifications
- ✅ ALWAYS verify from actual sources (files, WebSearch, user)
- ✅ ALWAYS cite sources for factual claims
- ✅ If unknown, say "I need to research this" - never guess

**Why**: Invented data ruins decisions, costs money/time, breaks trust.

---

## Quick Reference

**Memory Location**: `~/.claude-memory/`
**Cloud Sync**: `~/.claude-memory-cloud/` (optional)
**Framework Version**: v3.4

## Essential Structure

```
~/.claude-memory/
├── providers/claude/
│   ├── session-state.md       # START HERE (current state)
│   └── logs/daily/            # Session logs
├── projects/{name}/
│   ├── .context.quick.md      # Load this (summary)
│   └── .context.md            # Load on-demand (full)
└── integration/
    └── provider-activities.quick.md  # Recent activity
```

## Session Commands (Skills)

| Command | Action | Context Impact |
|---------|--------|----------------|
| `/continue` | Resume last session | ~1k tokens (state + quick files) |
| `/end` | Save & sync | None (saves context) |
| `/switch {project}` | Change project | Minimal (quick context only) |

Execute via: `Skill("command-name")`

## Progressive Loading Pattern

**First load**:
1. `session-state.md` (where you left off)
2. `provider-activities.quick.md` (recent work)
3. If continuing project: `.context.quick.md` only

**Load on-demand**:
- `.context.md` - when modifying project details
- `.status.md` - when checking roadmap
- Full logs - when researching history

## Current Work (v3.4)

**Active**: Issue #13 (Progressive Context Loading), #12 (Labels), #9 (CHANGELOG)
**GitHub**: https://github.com/luisromano-gf/claude-memory-system-repo/issues

## File Conventions

- Logs: `YYYY.MM.DD.md` (daily), `YYYY.WW.md` (weekly)
- Quick files: Summaries (<500 tokens)
- Full files: Complete context (load only when editing)

## On-Demand References

Load these ONLY when modifying:
- `@README.md` - Framework overview
- `@QUICKSTART.md` - Setup guide
- `@MEMORY-ORGANIZATION.md` - Architecture details
- `.claude/skills/{name}/GUIDE.md` - Skill documentation

---

**This file loads when working in claude-memory-system-repo/**
**General session practices: see ~/.claude/CLAUDE.md**
