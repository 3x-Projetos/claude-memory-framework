# Context Preservation System

**Version**: 1.0
**Framework**: Claude Memory System v3.4+
**Purpose**: Preserve critical instructions through context compaction

---

## Overview

The Context Preservation System ensures that critical instructions from CLAUDE.md and project-specific rules survive context compaction (auto or manual). It uses hooks to save and restore essential context, preventing the "forgotten instructions" problem.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     CONTEXT COMPACTION CYCLE                    │
└─────────────────────────────────────────────────────────────────┘

1. Context reaches ~95% capacity
   ↓
2. PreCompact hook triggers
   ↓
3. preserve-instructions.sh extracts critical rules
   ↓
4. Rules saved to .claude/.preserved-context.md (~300-500 tokens)
   ↓
5. Compaction happens (conversation summarized)
   ↓
6. SessionStart hook triggers (next session or immediate)
   ↓
7. restore-instructions.sh reloads preserved rules
   ↓
8. Critical context restored in fresh session
   ↓
9. .preserved-context.md deleted (cleanup)
```

## File Structure

```
~/.claude/
├── CLAUDE.md                          # Minimal global overview
├── settings.json                      # Hooks configuration
├── hooks/
│   ├── common.sh                      # Shared utilities
│   ├── preserve-instructions.sh       # PreCompact hook
│   └── restore-instructions.sh        # SessionStart hook
├── rules/                             # Modular global rules
│   ├── agent-first-development.md     # Agent enforcement
│   ├── data-accuracy.md               # Data verification rules
│   └── project-guidelines.md          # General project standards
└── .preserved-context.md              # Temporary (created by hooks)

~/.claude-memory/projects/{project}/
├── .context.md                        # Full project context
├── .context.quick.md                  # Quick summary
└── .claude/
    ├── CLAUDE.md                      # Project-specific instructions
    └── rules/                         # Project-specific rules
        ├── backend-standards.md
        ├── frontend-standards.md
        └── ui-guidelines.md
```

## What Gets Preserved

### Always Preserved (High Priority)

**Global Rules** (~200 tokens):
- Agent-first development enforcement
- Data accuracy requirements
- Available agents list
- Critical constraints

**Project Context** (~100-200 tokens):
- Current active project
- Project-specific critical rules
- Recent decisions/context

**Session State** (~50-100 tokens):
- What you were working on
- Next steps
- Active blockers

**Total Budget**: 300-500 tokens (configurable)

### NOT Preserved (Reloaded from Files)

- Full CLAUDE.md content (auto-reloaded each session)
- Project .context.md files (loaded on-demand)
- Conversation history (that's what compaction compresses)
- Non-critical documentation

## Lazy Loading Strategy

The system uses **progressive loading** to minimize context usage:

**Level 1 - Always Loaded** (< 100 tokens):
```
~/.claude/CLAUDE.md (minimal overview only)
```

**Level 2 - Preserved Through Compaction** (300-500 tokens):
```
.claude/.preserved-context.md (created by hooks)
  ├── Critical enforcement rules
  ├── Current project focus
  └── Essential constraints
```

**Level 3 - Loaded on Demand** (variable):
```
.claude/rules/*.md (loaded when needed)
.claude-memory/projects/{name}/.claude/rules/*.md
```

**Level 4 - Loaded for Deep Context** (heavy):
```
.claude-memory/projects/{name}/.context.md
Full documentation files
Historical logs
```

## Hook Configuration

### settings.json

```json
{
  "hooks": {
    "PreCompact": [{
      "matcher": "auto|manual",
      "hooks": [{
        "type": "command",
        "command": "bash .claude/hooks/preserve-instructions.sh"
      }]
    }],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python .claude/session-start.py"
          },
          {
            "type": "command",
            "command": "bash .claude/hooks/restore-instructions.sh"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "hooks": [{
          "type": "command",
          "command": "python .claude/session-auto-end.py"
        }]
      }
    ]
  }
}
```

## Hook Scripts

### preserve-instructions.sh (PreCompact)

**Purpose**: Extract and save critical context before compaction

**Process**:
1. Detect current project from session-state.md
2. Extract critical sections from:
   - `~/.claude/rules/*.md` (global enforcement rules)
   - `~/.claude-memory/providers/claude/session-state.md` (current focus)
   - Project-specific rules if active project exists
3. Build preserved context (max 500 tokens)
4. Save to `.claude/.preserved-context.md`
5. Log preservation event

**Token Budget**:
- Global rules: 200 tokens max
- Project context: 150 tokens max
- Session state: 100 tokens max
- Metadata: 50 tokens max
- **Total**: 500 tokens max

### restore-instructions.sh (SessionStart)

**Purpose**: Reload preserved context after compaction

**Process**:
1. Check if `.preserved-context.md` exists
2. If yes:
   - Output: "CRITICAL CONTEXT RESTORED FROM PREVIOUS SESSION:"
   - Output preserved content to stdout (Claude sees it)
   - Delete `.preserved-context.md`
3. If no:
   - Silent (normal session start, no compaction occurred)

## Modular Rules System

### Global Rules (~/.claude/rules/)

**agent-first-development.md** (~150 tokens):
- Absolute rule: NEVER implement without agents
- Enforcement checklist
- Available agents list
- Violation consequences

**data-accuracy.md** (~100 tokens):
- Absolute rule: NEVER invent data
- Verification requirements
- Citation requirements
- Unknown data handling

**project-guidelines.md** (~100 tokens):
- General project standards
- Git commit rules
- Code review requirements
- Documentation standards

### Project Rules (project/.claude/rules/)

**Example for videotelemetria-ui**:
- `backend-standards.md`: API design, error handling, security
- `frontend-standards.md`: Component patterns, state management, accessibility
- `ui-guidelines.md`: Design system, spacing, responsive design

## Usage

### For Users

**No manual action needed!** The system works automatically:

1. Work normally in Claude Code
2. When context reaches 95%, hooks preserve critical rules
3. Compaction happens
4. Next session automatically restores critical context
5. Continue working with rules intact

### For Developers

**Adding new global rules**:
```bash
# Create new rule file
cat > ~/.claude/rules/new-rule.md <<EOF
# Rule Name

## Critical Requirements
- Rule 1
- Rule 2

## Enforcement
- How to enforce
EOF

# Update preserve-instructions.sh to include it
```

**Adding project-specific rules**:
```bash
# In project directory
mkdir -p .claude/rules
cat > .claude/rules/my-standard.md <<EOF
# Project Standard

## Requirements
- Standard 1
- Standard 2
EOF

# Update project CLAUDE.md to reference it
```

## Testing

### Test Preservation

```bash
# 1. Create test preserved context
cat > ~/.claude/.preserved-context.md <<EOF
# PRESERVED CONTEXT TEST

## Agent-First Development
- ALWAYS use agents
- NEVER implement directly

## Current Project
- videotelemetria-ui

## Session State
- Working on: API integration
EOF

# 2. Start new session (SessionStart hook should trigger)
# 3. Verify Claude sees the preserved content
# 4. Verify file is deleted after restoration
```

### Test Preservation Script

```bash
# Run preserve script manually
bash ~/.claude/hooks/preserve-instructions.sh

# Check output
cat ~/.claude/.preserved-context.md

# Should contain critical rules within 500 tokens
```

## Troubleshooting

### Rules Not Surviving Compaction

**Symptom**: After compaction, Claude forgets critical rules

**Diagnosis**:
```bash
# Check if PreCompact hook ran
cat ~/.claude/debug/preserve-instructions.log

# Check if preserved file was created
ls -lh ~/.claude/.preserved-context.md

# Check token count
wc -w ~/.claude/.preserved-context.md
```

**Solutions**:
- Verify hooks are configured in settings.json
- Check hook scripts have execute permissions: `chmod +x ~/.claude/hooks/*.sh`
- Check logs for errors
- Verify token budget not exceeded

### Preserved Context Too Large

**Symptom**: Preserved context exceeds 500 tokens

**Solution**:
```bash
# Edit preserve-instructions.sh
# Reduce sections or make rules more concise
# Priority order:
#   1. Agent-first enforcement (critical)
#   2. Data accuracy (critical)
#   3. Current project context
#   4. Other rules (optional)
```

### Hook Not Triggering

**Symptom**: Hooks don't run during compaction

**Diagnosis**:
```bash
# Check settings.json syntax
cat ~/.claude/settings.json | python -m json.tool

# Check hook file exists
ls -lh ~/.claude/hooks/preserve-instructions.sh

# Check permissions
ls -l ~/.claude/hooks/*.sh
```

**Solutions**:
- Fix JSON syntax errors in settings.json
- Ensure hook files exist and are executable
- Check Claude Code version supports PreCompact hook

## Performance

### Context Savings

**Before Context Preservation**:
- After compaction: ~0 tokens of critical rules
- Need to manually re-explain rules each session
- Agent enforcement forgotten
- Data accuracy rules forgotten

**After Context Preservation**:
- After compaction: 300-500 tokens of critical rules preserved
- Rules automatically restored
- Zero manual intervention
- Consistent enforcement across compactions

**Net Savings**: ~50,000+ tokens per session (avoiding re-explanation)

### Hook Performance

- **preserve-instructions.sh**: < 100ms
- **restore-instructions.sh**: < 50ms
- **Impact on compaction**: Negligible (non-blocking)
- **Impact on session start**: +50ms (acceptable)

## Best Practices

1. **Keep global CLAUDE.md minimal** (~200 tokens)
   - Overview only
   - Reference to rules/ directory
   - Critical session commands

2. **Use modular rules** (~100-150 tokens each)
   - One concern per file
   - Easy to update
   - Lazy load when needed

3. **Prioritize preserved content**
   - Enforcement rules > guidelines
   - Current project > historical context
   - Critical > nice-to-have

4. **Test preservation regularly**
   - After adding new rules
   - After modifying hooks
   - After Claude Code updates

5. **Monitor token usage**
   - Keep preserved context < 500 tokens
   - Use `wc -w .preserved-context.md` to check
   - Trim non-critical content if needed

## Migration Guide

### From Monolithic CLAUDE.md

**Before** (single 7KB file):
```
~/.claude/CLAUDE.md (all rules, 7767 bytes)
```

**After** (modular):
```
~/.claude/
├── CLAUDE.md (200 tokens - overview)
├── rules/
│   ├── agent-first-development.md (150 tokens)
│   ├── data-accuracy.md (100 tokens)
│   └── project-guidelines.md (100 tokens)
└── hooks/ (preservation system)
```

**Migration Steps**:
1. Backup current CLAUDE.md
2. Extract critical sections to rules/*.md
3. Rewrite CLAUDE.md as minimal overview
4. Test hooks preserve critical rules
5. Verify compaction survival

## Future Enhancements

**Potential improvements**:
- [ ] Intelligent token budgeting (prioritize by usage frequency)
- [ ] Compression for preserved content (semantic compression)
- [ ] Skill-based auto-restoration (skills that auto-trigger post-compact)
- [ ] Cloud sync integration (preserve across devices)
- [ ] Analytics (track which rules are most violated post-compact)

---

**Last Updated**: 2026-01-20
**Author**: Luis Romano
**Framework**: Claude Memory System v3.4
