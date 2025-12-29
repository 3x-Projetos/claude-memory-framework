# Session Templates - Progressive Loading Patterns

Ready-to-use templates for different session types with optimized context loading.

## Template 1: Quick Fix (<25% context)

**Use case**: Bug fix, small tweak, urgent patch

**Initial prompt template**:
```
Fix [specific issue] in [file/component]

Context needed:
- Error: [paste error message]
- File: [filename or path]

Don't load docs unless needed.
```

**Loading pattern**:
1. Load session-state.md only
2. Let Claude Read the specific file
3. Fix and test
4. Commit

**Expected context**: ~20-25%

---

## Template 2: Feature Work (<50% context)

**Use case**: New feature, enhancement, moderate complexity

**Initial prompt template**:
```
Implement [feature description]

Affected area: [component/module]
Related: [issue/ticket number]

Load architecture docs if you need design guidance.
```

**Loading pattern**:
1. Load session-state.md + project .context.quick.md
2. Claude loads architecture docs if needed
3. Implement progressively
4. /compact at 70% if needed

**Expected context**: ~40-50%

---

## Template 3: Research Session (<60% context)

**Use case**: Understanding codebase, exploration, learning

**Initial prompt template**:
```
Help me understand [specific aspect]

Focus: [area of interest]
Goal: [what you want to learn]

Use Explore agent for codebase discovery.
```

**Loading pattern**:
1. Load session-state.md only
2. Use Explore agent (separate context)
3. Load specific files as discovered
4. Take notes to .context.md

**Expected context**: ~50-60%

---

## Template 4: Architecture Work (<70% context)

**Use case**: Refactoring, system design, complex changes

**Initial prompt template**:
```
[Architecture task description]

Scope: [affected systems]
Constraints: [technical/business]

Plan mode recommended. /compact every 40 messages.
```

**Loading pattern**:
1. Load session-state.md + .context.md (full context)
2. Load relevant architecture docs
3. Use /compact proactively every 40 messages
4. Save decisions to .status.md

**Expected context**: ~60-70% (with compacting)

---

## Template 5: Documentation Work (<30% context)

**Use case**: Writing docs, updating README, guides

**Initial prompt template**:
```
Update [document name]

Changes needed: [description]
Audience: [target readers]

Load existing doc when ready to edit.
```

**Loading pattern**:
1. Load session-state.md only
2. Read target document when editing
3. Reference related docs on-demand
4. Keep lightweight

**Expected context**: ~25-30%

---

## Progressive Loading Decision Tree

```
Session Start
    ↓
Load session-state.md (always)
    ↓
Is this continuing a project?
    ├─ Yes → Load .context.quick.md
    └─ No → Skip project context
    ↓
Task type?
    ├─ Quick fix → Load only target file
    ├─ Feature → Load quick context + on-demand
    ├─ Research → Use Explore agent
    ├─ Architecture → Load full context + plan for compacting
    └─ Docs → Load target doc only
    ↓
Work progressively
    ↓
Context > 70%?
    ├─ Yes → /compact and continue
    └─ No → Keep working
    ↓
Done → /end
```

---

## Lazy-Loading Guidelines

### Rule 1: Start Minimal
```markdown
# Always start with
1. session-state.md
2. .context.quick.md (if project-specific)
3. Nothing else

# Let Claude request what it needs
```

### Rule 2: Reference, Don't Load
```markdown
# In prompts, REFERENCE files instead of @mentioning:
❌ "Here's the code: @app.ts @utils.ts @config.ts"
✅ "Fix the validation in app.ts"

# Let Claude Read when ready
```

### Rule 3: Summaries First
```markdown
# Provide quick version first
.context.quick.md  (summary - 200 tokens)
    ↓ if needed
.context.md  (full - 2k tokens)

# Same for all docs
```

### Rule 4: Demand-Driven Loading
```markdown
# Load based on what task requires, not what might be useful
Task: "Add login endpoint"
  → Load: API structure, auth module
  → Don't load: Frontend code, tests (yet)

# Add more as task evolves
```

### Rule 5: Compact Proactively
```markdown
# Don't wait for 90%
- 70% → Run /compact
- Save summary
- Continue fresh

# Better than hitting limit
```

---

## Context Budget Allocation

### Quick Fix (25% target)
- Session state: 5%
- Target file: 15%
- Tool outputs: 5%

### Feature Work (50% target)
- Session state: 5%
- Project context: 10%
- Implementation files: 25%
- Tool outputs: 10%

### Research (60% target)
- Session state: 5%
- Exploration: 30% (Explore agent)
- Documentation: 20%
- Notes: 5%

### Architecture (70% target)
- Session state: 5%
- Full context: 20%
- Architecture docs: 25%
- Planning: 15%
- Compacted summaries: 5%

---

## Anti-Patterns to Avoid

### ❌ Upfront Loading
```
User: @README.md @ARCHITECTURE.md @API.md @GUIDE.md
Claude: [Loaded 15k tokens before understanding task]
```

### ❌ No Compacting
```
[Context at 85%]
User: "Keep going"
[Context hits 95%, performance degrades]
```

### ❌ Kitchen Sink Context
```
"Here's everything you might need..."
[Loads entire codebase summary]
```

### ✅ Progressive Loading
```
User: "Add validation to login endpoint"
Claude: [Reads session-state, understands last work]
Claude: [Uses Read to load login endpoint file]
Claude: [Implements, tests]
Context: 30% ✅
```

### ✅ Proactive Compacting
```
[Context at 70%]
Claude: "I'll compact to free up space"
[Runs /compact, saves summary]
[Continues with 40% context]
```

### ✅ Minimal Context
```
User: "Fix typo in README"
Claude: [Reads session-state]
Claude: [Reads README, fixes typo]
Context: 15% ✅
```

---

## Session Type Indicators

Add to your prompt to help Claude optimize:

```markdown
# Quick fix indicator
"[QUICK FIX] ..." → Claude loads minimally

# Feature work indicator
"[FEATURE] ..." → Claude loads progressively

# Research indicator
"[RESEARCH] ..." → Claude uses Explore agent

# Architecture indicator
"[ARCHITECTURE] ..." → Claude loads full context, plans compacting
```

---

**Usage**: Reference this file when starting sessions to optimize context loading.

**Related**:
- Context loading: `CLI-CONTEXT-LOADING.md`
- Session strategy: `~/.claude/CLAUDE.md`
- Framework guide: `CLAUDE.md`
