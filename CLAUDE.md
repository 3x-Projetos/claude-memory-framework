# Claude Memory System - Global Instructions

**Version**: v3.4 (Context Preservation Enabled)
**Framework**: Multi-device memory system for AI providers
**Memory Location**: `~/.claude-memory/`

---

## 🚨 CRITICAL RULES (Always Enforced)

> **These rules are preserved through context compaction via hooks**

### 1. Agent-First Development
**NEVER IMPLEMENT CODE WITHOUT AGENTS IN PROJECTS**

✅ **Load for details**: `.claude/rules/agent-first-development.md`

### 2. Data Accuracy
**NEVER INVENT DATA**

✅ **Load for details**: `.claude/rules/data-accuracy.md`

### 3. Project Guidelines
Standard practices for git, documentation, testing

✅ **Load for details**: `.claude/rules/project-guidelines.md`

---

## 📁 Modular Rules System

**All detailed rules are in separate files for lazy loading:**

```
~/.claude/rules/
├── agent-first-development.md  (~150 tokens)
├── data-accuracy.md            (~100 tokens)
└── project-guidelines.md       (~100 tokens)
```

**Load rules only when needed** to minimize context usage.

---

## 🎯 Quick Reference

### Session Commands (Skills)

| Command | Action | Context Impact |
|---------|--------|----------------|
| `/continue` | Resume last session | ~1k tokens |
| `/end` | Save & sync | None (saves context) |
| `/switch {project}` | Change project | Minimal (quick context only) |

Execute via: `Skill("command-name")`

### Memory Structure

```
~/.claude-memory/
├── providers/claude/
│   ├── session-state.md       # Current state
│   └── logs/daily/            # Session logs
├── projects/{name}/
│   ├── .context.quick.md      # Load this first
│   ├── .context.md            # Load on-demand
│   └── .claude/               # Project-specific config
│       ├── CLAUDE.md          # Project instructions
│       ├── rules/             # Project rules
│       └── agents/            # Project agents
└── integration/
    └── provider-activities.quick.md  # Recent activity
```

### Progressive Loading Strategy

**Level 1 - Always** (~200 tokens):
- This file (global overview)
- Project `.context.quick.md` (if active project)

**Level 2 - When Needed** (~300-500 tokens):
- `.claude/rules/*.md` (modular rules)
- Project `.claude/CLAUDE.md`
- Project `.claude/rules/*.md`

**Level 3 - Deep Context** (~2000 tokens):
- `.context.md` (full project context)
- `.status.md` (roadmap)
- Documentation files

**Level 4 - Historical** (heavy):
- Session logs
- Full documentation

---

## 🔄 Context Preservation System

**Automatic hooks preserve critical context through compaction:**

- **PreCompact Hook**: Saves critical rules before compaction (~300-500 tokens)
- **SessionStart Hook**: Restores preserved context after compaction
- **What's preserved**:
  - Agent-first development rules
  - Data accuracy requirements
  - Current project context
  - Available agents list
  - Session state

> **Documentation**: `.claude/docs/CONTEXT-PRESERVATION.md`

---

## 🤖 Available Global Agents

Check `.claude/agents/` directory:
- `api-debugger` - Debug API issues, analyze Postman/scripts
- `test-specialist` - Analyze coverage, suggest test cases
- `ui-specialist` - Evaluate layout, visual design, responsiveness
- `ux-specialist` - Analyze usability, flows, accessibility

**Project-specific agents**: Check project `.claude/agents/` directory

---

## 📚 Documentation (Load On-Demand)

**Framework**:
- `.claude/README.md` - Framework overview
- `.claude/QUICKSTART.md` - Setup guide
- `.claude/MEMORY-ORGANIZATION.md` - Architecture details
- `.claude/CLI-CONTEXT-LOADING.md` - Progressive loading guide

**System Docs**:
- `.claude/docs/CONTEXT-PRESERVATION.md` - Context preservation system
- `.claude/docs/TEAMS-FRAMEWORK.md` - Agent team patterns

**Skills**:
- `.claude/skills/{name}/GUIDE.md` - Skill documentation

**Workflows**:
- `.claude/workflows/{name}.md` - Workflow documentation

---

## 🎨 Current Work

**Active Projects**: Check `~/.claude-memory/providers/claude/session-state.md`

**Context Budget**: 200,000 tokens (Sonnet 4.5)

**Auto-Compaction**: Triggers at ~95% capacity (190,000 tokens)

---

**Last Updated**: 2026-01-20
**Framework Version**: v3.4
**Context Preservation**: ✅ Enabled
