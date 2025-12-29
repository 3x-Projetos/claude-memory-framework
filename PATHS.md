# Path Requirements for Claude Code CLI

## Critical Discovery

The **Write tool** in Claude Code CLI requires **relative paths**, not absolute paths.

### What This Means

**❌ WRONG** - Absolute paths will fail:
```
C:/Users/Luis Romano/.claude/README.md
/home/user/.claude-memory/session-state.md
C:\Users\Luis Romano\.claude\skills\scientist\SKILL.md
```

**✅ CORRECT** - Use relative paths:
```
.claude/README.md
.claude-memory/session-state.md
.claude/skills/scientist/SKILL.md
```

---

## Why This Happens

When you use an absolute path with the Write tool:
1. Read tool works fine with absolute path
2. Write tool fails with error: **"file has not been read"**
3. Even though you just read it successfully!

**Root cause**: Write tool's internal validation requires relative paths to match against its read history.

---

## Solution Pattern

### Pattern 1: Always Use Relative Paths

```markdown
✅ Read:  .claude/skills/scientist/SKILL.md
✅ Write: .claude/skills/scientist/SKILL.md
```

### Pattern 2: Convert Absolute to Relative

If you receive an absolute path from user or system:

```
Absolute: C:/Users/Luis Romano/.claude/README.md
         ↓
Relative: .claude/README.md
```

### Pattern 3: Working Directory Awareness

Claude Code CLI starts in user's home directory or project root. Paths are relative to that location.

```bash
# If CWD is C:/Users/Luis Romano/
.claude/README.md           → C:/Users/Luis Romano/.claude/README.md
projects/myapp/src/main.js  → C:/Users/Luis Romano/projects/myapp/src/main.js
```

---

## Affected Tools

### Write Tool
- **MUST** use relative paths
- Will fail with absolute paths even after Read succeeds

### Edit Tool
- **SHOULD** use relative paths (same validation as Write)
- Consistent behavior with Write tool

### Read Tool
- **CAN** use both absolute and relative paths
- More flexible, but recommend using relative for consistency

---

## Best Practices

### 1. Always Start Relative

When working with files in Claude Code:
```
Read:  .claude/skills/scientist/SKILL.md
Edit:  .claude/skills/scientist/SKILL.md
Write: .claude/skills/scientist/SKILL.md
```

### 2. Never Hardcode Home Directory

**❌ BAD**:
```
~/.claude-memory/session-state.md
C:/Users/Luis Romano/.claude/README.md
```

**✅ GOOD**:
```
.claude-memory/session-state.md
.claude/README.md
```

### 3. Use Bash for Path Operations

If you need to resolve paths:
```bash
# Get absolute path (for display only)
realpath .claude/README.md

# But use relative path for Read/Write
Read: .claude/README.md
```

### 4. Framework-Specific Paths

When documenting paths in framework files:

**For humans** (documentation):
- `~/.claude-memory/` ← Clear for users

**For Claude Code** (actual operations):
- `.claude-memory/` ← Works in tools

---

## Common Errors

### Error 1: "File has not been read"

```
Error: Cannot write to file that hasn't been read: C:/Users/Luis Romano/.claude/README.md
```

**Cause**: Used absolute path in Write after Read
**Fix**: Change to relative path `.claude/README.md`

### Error 2: Write Fails After Successful Read

```
Read:  C:/Users/Luis Romano/.claude/README.md  ← Works
Write: C:/Users/Luis Romano/.claude/README.md  ← Fails
```

**Cause**: Path format mismatch in Write tool validation
**Fix**: Use relative path for both

---

## Framework Integration

### Skills System

All skill files use relative paths:
```
.claude/skills/scientist/SKILL.md
.claude/skills/scientist/GUIDE.md
.claude/skills/session-continuity-assistant/SKILL.md
```

### Memory System

All memory files use relative paths:
```
.claude-memory/providers/claude/session-state.md
.claude-memory/providers/claude/logs/daily/2025.12.29.md
.claude-memory/integration/provider-activities.md
```

### Commands

All command files use relative paths:
```
.claude/commands/continue.md
.claude/commands/end.md
```

---

## Historical Context

**Discovered**: 2025-12-29 during v3.3 release
**Context**: Git integration workflow
**Impact**: All Write operations were failing until paths converted to relative
**Solution**: Updated CLAUDE.md with critical path requirement

**Session**: `providers/claude/logs/daily/2025.12.29.md` (Session 3, 21:30)
**Commit**: 9f4df55 (after fixing path issues)

---

## References

- Main framework guide: `.claude/README.md`
- Global instructions: `~/.claude/CLAUDE.md` (see "Write Tool - Path Requirements")
- Session log: `.claude-memory/providers/claude/logs/daily/2025.12.29.md`

---

*Last updated: 2025-12-29 (v3.3)*
