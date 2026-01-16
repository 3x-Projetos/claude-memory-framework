# Claude Code - Session Strategy

Efficient context management and productive sessions.

## Progressive Loading

**Load only what you need, when you need it.**

- **Startup:** Session state (~1k tokens), summaries (.quick.md), current task only
- **On-Demand:** Full docs (when modifying), detailed specs (when implementing), history (when researching)
- **Rule:** Use `@filename.md` references instead of reading upfront

## Context Budget

| Session Type | Target | Strategy |
|--------------|--------|----------|
| Quick fix | <25% | Minimal: affected files only |
| Feature work | <50% | Progressive: load as you go |
| Research | <60% | Selective: specific docs only |
| Architecture | <70% | `/compact` every 40 messages |

## Workflow

**Starting:** Use existing context, load task-specific files only, don't read entire READMEs upfront

**Working:** Monitor context meter, `/compact` at 70%, use subagents for isolated tasks

**Ending:** Save decisions to docs, commit with descriptive messages, update status files

## Key Commands

- `/compact` - Summarize and free context (use at 70%)
- `/clear` - Full reset (only when switching major tasks)
- `/context` - Check current usage

## Tool Efficiency

**DO:** `@` references, load summaries first, trust paths without reading, Grep/Glob for discovery + Read for details

**DON'T:** Load all docs at start, read files you won't modify, keep unused context, exceed 80%

## LSP Tools Available

**Installed Language Servers:**
- **Pyright** (Python) v1.1.407
- **vtsls** (TypeScript/JS) v0.3.0

**When to use:** Debugging scripts, code navigation (goToDefinition, findReferences), type checking, hover info

**Performance:** 50ms (LSP) vs 10-45s (grep) = **900x faster** for semantic operations

**Status:** ✅ Enabled (`ENABLE_LSP_TOOL=1`)

## Memory Framework

**Persistent memory system** across sessions and devices.

**Key features:** Session logs, project context, multi-device sync, skills system

**Quick commands:** `/start`, `/continue`, `/end`, `/switch [project]`

**Documentation:** `~/.claude-memory/README.md` (framework overview)

## Commit Format

```
{type}: {brief description}

🤖 Generated with Claude Code
Co-Authored-By: {model} <noreply@anthropic.com>
```

Types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `security`

## Contextual Suggestions

**Suggest `/reflect` when:** User frustrated, major achievement, long session (>2h), tired/drained

**How:** Brief, natural mention. Don't interrupt flow.

---

**Auto-loaded every session. Keep <1k tokens.**

**Expanded explanations:** `~/.claude/CLAUDE-expanded.md`
**LSP setup details:** `~/.claude-memory/global/tools/lsp-reference.md`
**Memory framework docs:** `~/.claude-memory/README.md`
