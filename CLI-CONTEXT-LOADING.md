# Claude CLI - Context Loading Behavior

Understanding how Claude Code loads context automatically vs on-demand.

## Loading Sequence (Session Start)

```
1. CLAUDE.md files (Automatic, ~1-5k tokens)
   ↓
2. .claude/rules/*.md (If present, automatic)
   ↓
3. Session state restoration (If --continue or --resume)
   ↓
4. @-mentioned files (Manual, in prompt)
   ↓
5. Skills (On-demand, via Skill tool)
   ↓
6. Workflows (On-demand, via references)
   ↓
7. Tool reads (On-demand, via Read/Grep/Glob)
```

## Automatic Loading (Every Session)

**CLAUDE.md Priority Order**:
1. Repository root `./CLAUDE.md` (highest priority)
2. Parent directories (cascading upward)
3. Child directories (when working in subdirs)
4. Global `~/.claude/CLAUDE.md` (lowest priority)

**Budget**: Keep CLAUDE.md < 5k tokens total (all cascading files combined)

**Rules Directory**: `.claude/rules/*.md` auto-loaded if present

## On-Demand Loading

### Skills (.claude/skills/)
- **Trigger**: `Skill("skill-name")` tool invocation
- **Load**: Only SKILL.md (~200 words) + active skill code
- **GUIDE.md**: NOT loaded automatically (reference only)

### Workflows (.claude/workflows/)
- **Trigger**: Referenced in SKILL.md or CLAUDE.md
- **Load**: On first reference only
- **Pattern**: Keep lightweight, detailed steps on-demand

### Files
- **@ mentions**: `@filename.md` in user prompt → loaded immediately
- **Read tool**: Claude requests specific file → loaded
- **Grep/Glob**: Discovery only → paths returned, content not loaded

### Documentation
- **README.md**: NOT auto-loaded (too large)
- **Other docs**: Load via @ mention or Read tool only

## Optimization Strategies

### 1. CLAUDE.md Strategy
```markdown
# Keep minimal (< 1k tokens ideal)
- Project overview (2-3 lines)
- Key conventions
- Where to find more (@ references)

# DON'T include in CLAUDE.md:
- Full architecture explanations
- Detailed code examples
- Complete API documentation
- Long lists or tables
```

### 2. Progressive Disclosure Pattern
```
CLAUDE.md (auto-load)
  ↓ references
GUIDE.md (on-demand)
  ↓ references
DETAILED-SPEC.md (on-demand)
```

### 3. Skill Structure
```
skill-name/
├── SKILL.md        # Auto-loaded (~200 words max)
├── GUIDE.md        # On-demand (detailed usage)
└── impl/           # Code (loaded when skill executes)
```

### 4. File References
```markdown
# BAD: Loads entire file upfront
User: "Fix the API, here's the code: @api.ts"

# GOOD: Reference only, load when needed
User: "Fix the API endpoint in api.ts"
Claude: [Uses Read tool when actually needs to see code]
```

## Context Budget Monitoring

**Check usage**: `/context` command
**Auto-compact**: Triggers at 80% (if enabled)
**Manual compact**: `/compact Focus on {area}` at 70%

## Multi-File Loading

### Automatic Cascade (CLAUDE.md)
```
/project/
├── CLAUDE.md              # Loaded
│   └── @common/guide.md   # Auto-loaded (imported)
└── common/
    └── guide.md           # Content merged into context
```

**Budget impact**: All imported files count toward CLAUDE.md budget

### Manual References (Not Cascading)
```markdown
# In CLAUDE.md
For API details, see @docs/api.md  # NOT loaded automatically
                                    # Just tells Claude where to look
```

## Session Types & Loading

| Type | CLAUDE.md | Skills | Docs | Strategy |
|------|-----------|--------|------|----------|
| Quick fix | ✅ Auto | ❌ None | ❌ Minimal | Direct to code |
| Feature | ✅ Auto | ✅ 1-2 | 📄 Reference only | Progressive |
| Research | ✅ Auto | ❌ None | 📄 Selective load | Exploratory |
| Refactor | ✅ Auto | ✅ Multiple | 📄 Architecture docs | Planned |

## Best Practices Summary

1. **CLAUDE.md**: Keep < 1k tokens, use as "table of contents"
2. **Skills**: SKILL.md minimal, GUIDE.md for details
3. **Docs**: Reference in CLAUDE.md, don't import
4. **Files**: Let Claude load via Read when needed
5. **Monitor**: Use `/context` regularly, `/compact` at 70%

## Common Anti-Patterns

❌ **Loading everything upfront**
```markdown
# CLAUDE.md (BAD)
@README.md
@ARCHITECTURE.md
@API-DOCS.md
@CONTRIBUTING.md
# Result: 20k tokens before session starts
```

✅ **Progressive references**
```markdown
# CLAUDE.md (GOOD)
Project: API Server
Stack: Node.js, TypeScript, PostgreSQL
Docs: README.md, ARCHITECTURE.md (load on-demand)
# Result: ~200 tokens, references available
```

---

**Key Insight**: Claude CLI loads what you configure to auto-load (CLAUDE.md, rules). Everything else is on-demand. Design your structure accordingly.

**Related**:
- Session Strategy: `~/.claude/CLAUDE.md`
- Framework Guide: `@CLAUDE.md` (this repo)
- Issue #13: Progressive Context Loading Strategy
