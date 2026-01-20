# Context Preservation System - User Guide

**Version**: v3.4
**Date**: 2026-01-20
**Status**: Production Ready ✅

---

## What is This?

The Context Preservation System ensures your critical instructions (like "ALWAYS USE AGENTS" and "NEVER INVENT DATA") survive context compaction in Claude Code.

**Problem Solved**: Previously, after context compaction, Claude would "forget" your important rules. Now, they're automatically preserved and restored.

---

## How It Works (Simple)

### Before Compaction
1. Context fills up (~95% capacity)
2. System automatically saves your critical rules
3. Compaction happens
4. Context cleared/summarized

### After Compaction
1. You start a new session
2. System automatically restores your rules
3. Claude remembers everything
4. You continue working

**Zero manual work required!**

---

## Benefits You'll See

- ✅ No more forgotten rules after compaction
- ✅ 63% token savings (smaller CLAUDE.md)
- ✅ Easy to maintain modular rules
- ✅ Multi-project support
- ✅ Automatic preservation/restoration

---

## File Locations

**Global**: `~/.claude/CLAUDE.md` + `~/.claude/rules/`
**Project**: `~/.claude-memory/projects/{PROJECT}/.claude/`

---

For full documentation, see:
- `~/.claude/docs/CONTEXT-PRESERVATION.md` (architecture)
- `~/.claude/docs/IMPLEMENTATION-SUMMARY.md` (implementation)
- `~/.claude/docs/TESTING-GUIDE.md` (testing)

**Version**: v3.4 | **Status**: Production Ready ✅
