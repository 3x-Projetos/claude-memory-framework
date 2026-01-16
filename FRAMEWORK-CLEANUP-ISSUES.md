# Framework Cleanup & Improvement - GitHub Issues

**Milestone**: v3.4 (Cleanup & Security)
**Priority**: High (Security vulnerabilities fixed, now cleanup)

---

## 🔴 CRITICAL - Immediate Cleanup (Delete These Files)

### Issue #1: Remove machine-specific and personal files
**Labels**: `cleanup`, `security`, `priority-high`

**Files to DELETE**:
- `CLAUDE.md` - Contains machine-specific paths
- `HARDWARE-SPECS.md` - Personal machine analysis
- `PATHS.md` - Machine-specific paths documentation
- `IMPLEMENTATION-PLAN.md` - Temporary planning doc (outdated)
- `statusline-readme.md`, `statusline.py`, `usage-widget.sh` - Replaced by csstatusline

**Rationale**: Public framework should not contain personal/machine-specific data

**Action**: Delete files, commit, push

---

## 🟡 UPDATE REQUIRED - Fix Hardcoded Paths

### Issue #2: Fix hardcoded paths in Python scripts
**Labels**: `bug`, `security`, `priority-high`

**Files affected**:
- `auto-approve-edits.py`
- `redact-pii.py`
- `session-start.py`
- `session-auto-end.py`
- `lmstudio-session-manager.py`
- `claude-usage-widget.py`

**Problem**: Scripts contain hardcoded paths like `/c/Users/Luis Romano/`

**Solution**: Use relative paths or environment variables

**Example**:
```python
# BAD
path = "C:/Users/Luis Romano/.claude-memory/"

# GOOD
import os
path = os.path.expanduser("~/.claude-memory/")
```

---

## 📝 DOCUMENTATION - Update & Organize

### Issue #3: Update QUICKSTART.md to v3.3
**Labels**: `documentation`, `priority-medium`

**Current state**: Outdated, doesn't reflect v3.3 features
**Required updates**:
- Skills System (v3.0)
- Auto Cloud Sync (v2.3.1)
- SOTA compact skills (v3.3)
- Current command list

---

### Issue #4: Update MEMORY-ORGANIZATION.md
**Labels**: `documentation`, `priority-medium`

**Current state**: Important but outdated
**Required updates**:
- Reflect current memory structure (3 layers: Working, Global, Cloud)
- Update with v3.3 improvements
- Clarify purpose of each memory layer

**Keep**: This file is important reference for framework architecture

---

### Issue #5: Review METRICS-FRAMEWORK.md
**Labels**: `feature`, `review-needed`, `priority-low`

**Current state**: Important concept, never activated
**Questions**:
- Should this be a skill?
- Should this be integrated into `/reflect` command?
- Is this still relevant for v3.3+?

**Action**: Review and decide: activate, convert to skill, or archive

---

### Issue #6: Update MULTI-PROVIDER-IMPLEMENTATION.md
**Labels**: `documentation`, `priority-medium`

**Current state**: Important for multi-provider usage (Claude, Gemini, GPT, LMStudio)
**Action**: 
- Keep this file
- Update if outdated
- Ensure it's accessible when working with multiple providers

---

## 🎯 SKILL CREATION

### Issue #7: Convert MEMORY-IMPROVEMENTS.md to skill
**Labels**: `skill`, `enhancement`, `priority-medium`

**Current file**: Personal strengths/improvements doc
**Why remove from repo**: Contains personal characteristics
**Why create skill**: Useful framework for self-improvement

**Action**:
1. Create `/claude/skills/memory-improvements/`
2. Extract generic patterns from personal doc
3. Create SKILL.md (compact) + GUIDE.md (detailed)
4. Delete MEMORY-IMPROVEMENTS.md from repo

---

## 🗂️ STRUCTURE REVIEW

### Issue #8: Review .claude/ folder structure
**Labels**: `review`, `structure`, `priority-medium`

**Folders to review**:
- `.claude/commands/` - Are all commands current?
- `.claude/skills/` - Organization OK?
- `.claude/workflows/` - Still relevant?
- `.claude/performance/` - Used?
- `.claude/handInput/` - Needed?

**Action**: Audit each folder, remove/update as needed

---

### Issue #9: Create CHANGELOG.md
**Labels**: `documentation`, `priority-high`

**Current state**: Version history bloating README.md
**Action**: Extract all version history to CHANGELOG.md, simplify README

---

### Issue #10: Simplify README.md
**Labels**: `documentation`, `priority-high`

**Current**: 610 lines (too verbose)
**Target**: ~200-250 lines
**Keep**: What it is, core features, quick start, links to detailed docs
**Move**: Changelog, detailed architecture, token economics examples

---

## 📋 Implementation Order (Suggested)

**Phase 1: Cleanup** (This session if possible)
- Issue #1: Delete unnecessary files
- Issue #9: Create CHANGELOG.md
- Issue #10: Simplify README.md

**Phase 2: Security** (Next session)
- Issue #2: Fix hardcoded paths in Python files

**Phase 3: Documentation** (Ongoing)
- Issue #3: Update QUICKSTART
- Issue #4: Update MEMORY-ORGANIZATION
- Issue #6: Review MULTI-PROVIDER

**Phase 4: Enhancement** (Future)
- Issue #5: Review METRICS-FRAMEWORK
- Issue #7: Create memory-improvements skill
- Issue #8: Structure review

---

## 🎯 Success Criteria

Framework is considered "clean" when:
1. ✅ No personal/machine-specific data in public repo
2. ✅ No hardcoded paths (use relative or env vars)
3. ✅ Documentation reflects current state (v3.3+)
4. ✅ README is concise (~200-250 lines)
5. ✅ All files serve clear framework purpose
6. ✅ Security: .gitignore prevents future leaks

---

**Created**: 2025-12-29
**Version**: v3.3.1 → v3.4 (cleanup)
