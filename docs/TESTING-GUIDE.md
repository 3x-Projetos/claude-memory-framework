# Context Preservation System - Testing Guide

**Version**: 1.0
**Framework**: Claude Memory System v3.4+
**Purpose**: Verify context preservation works correctly

---

## Quick Test

Run the automated test script:

```bash
bash ~/.claude/docs/test-preservation.sh
```

Expected output:
```
✓ Preserved file created
✓ Token count within budget: ~300
✓ Preserved file cleaned up
```

---

## Manual Tests

### Test 1: Preservation

```bash
# Run preserve script
bash ~/.claude/hooks/preserve-instructions.sh

# Check output
cat ~/.claude/.preserved-context.md

# Check token count
wc -w ~/.claude/.preserved-context.md

# Should be < 500 tokens
```

### Test 2: Restoration

```bash
# Restore (uses existing preserved file from Test 1)
bash ~/.claude/hooks/restore-instructions.sh

# Verify file was deleted
ls ~/.claude/.preserved-context.md
# Should return: No such file or directory
```

### Test 3: During Compaction

1. Start Claude Code session
2. Run `/compact` command
3. Check logs: `grep "PRESERVE_START" ~/.claude/debug/context-preservation.log`
4. Verify Claude remembers critical rules after compaction

---

## Troubleshooting

**Preserved file not created**:
```bash
# Check permissions
chmod +x ~/.claude/hooks/*.sh

# Check settings.json
grep "PreCompact" ~/.claude/settings.json
```

**Rules not surviving compaction**:
```bash
# Check complete cycle in logs
grep "PRESERVE\|RESTORE" ~/.claude/debug/context-preservation.log | tail -10
```

**Token count too high**:
```bash
# Check what's consuming tokens
cat ~/.claude/.preserved-context.md | head -50

# Edit preserve-instructions.sh to reduce content
```

---

## Acceptance Criteria

System passes if:
- [x] Preserved file < 500 tokens
- [x] Restoration deletes file
- [x] Rules survive compaction
- [x] No manual intervention needed
- [x] Performance < 100ms

---

For detailed testing procedures, see `.claude/docs/CONTEXT-PRESERVATION.md` (Testing section).

**Last Updated**: 2026-01-20
