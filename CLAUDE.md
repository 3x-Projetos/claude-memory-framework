# Claude Code - Framework Instructions

## Critical Tool Usage Rules

### Write Tool - Path Requirements

**ALWAYS use relative paths, NEVER use absolute paths.**

**Correct examples**:
```
.claude/README.md
.claude-memory/providers/claude/session-state.md
skills/scientist/SKILL.md
```

**Incorrect examples** (will fail):
```
C:/Users/Luis Romano/.claude/README.md
/home/user/.claude-memory/session-state.md
C:\Users\Luis Romano\.claude\skills\scientist\SKILL.md
```

**Why**: The Write tool requires relative paths to function properly. Using absolute paths will result in "file has not been read" errors even after reading the file.

**Pattern**:
1. Read file using relative path: `.claude/README.md`
2. Edit/Write using same relative path: `.claude/README.md`

**Full documentation**: See `.claude/PATHS.md` for detailed explanations, error cases, and troubleshooting.

---

## Skills System

### SOTA Pattern (v3.3)

**Compact Skills** (<200 words in SKILL.md):
- SKILL.md: Core workflow only (what/when/how in minimal words)
- GUIDE.md: Detailed documentation (loaded only on-demand)
- EXAMPLES.md: Usage examples (loaded only on-demand)

**Benefits**:
- 87-90% context reduction
- Faster loading
- On-demand detail loading

See `.claude/skills/skill-creator/GUIDE.md` for complete SOTA patterns.

---

## Cloud Sync

**Config-driven** (not hardcoded):
- Cloud path: Read from `~/.claude-memory/.config.json`
- Never hardcode paths like `~/.claude-memory-cloud/`
- Try-first pattern: Execute and handle errors gracefully

---

*Framework v3.3 - 2025-12-29*
