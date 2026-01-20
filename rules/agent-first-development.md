# Agent-First Development

**Priority**: CRITICAL
**Enforcement**: ABSOLUTE
**Tokens**: ~150

> **Context Expansion**: For full agent patterns and team workflows, load `.claude/docs/TEAMS-FRAMEWORK.md`

---

## Absolute Rule

**NEVER IMPLEMENT CODE WITHOUT AGENTS IN PROJECTS**

### ❌ PROHIBITED: Direct Implementation
```
# WRONG
1. Read file
2. Write code
3. Commit
```

### ✅ REQUIRED: Agent-First Workflow
```
# CORRECT
1. Use tech-lead to plan implementation
2. Use specialist agents to implement
3. Use validators to review
4. Only THEN commit
```

## Enforcement Checklist

**Before writing ANY code in a project**:
- [ ] Did I consult tech-lead-coordinator for planning?
- [ ] Did I use appropriate specialist agent for implementation?
- [ ] Did I use validator agent to review?
- [ ] If NO to any above → STOP and use agents first

## Available Agents

Check `.claude/agents/` directory:
- `api-debugger` - Debug API issues, analyze Postman/scripts
- `test-specialist` - Analyze coverage, suggest test cases
- `ui-specialist` - Evaluate layout, visual design, responsiveness
- `ux-specialist` - Analyze usability, flows, accessibility

Project-specific agents (check project `.claude/agents/`):
- `backend-validator` - Validate routes, schemas, error handling
- `frontend-validator` - Validate accessibility, performance, UX
- `tech-lead-coordinator` - Assess architecture, coordinate agents

> **Note**: For agent persona details, read `.claude/agents/{name}/GUIDE.md`

## Why This is CRITICAL

- ✅ Prevents context bloat (agents work in isolation)
- ✅ Maintains quality standards (specialist expertise)
- ✅ Catches issues early (validation before commit)
- ✅ Survives context compaction (agents reload their personas)
- ❌ WITHOUT agents: Quality degrades, context bloats, errors accumulate

## Consequence of Violation

**Implementation will be rejected, must redo with agents.**

## Use Agents for Exploration

- ✅ ALWAYS use agents/workers for exploration (codebase analysis, payload inspection, log analysis)
- ✅ Use Task tool with Explore subagent for codebase exploration
- ✅ Use Task tool with general-purpose subagent for data analysis
- ✅ **ALWAYS specify working directory in agent prompts** (prevents wrong project searches)
- ❌ NEVER perform deep exploration directly in main conversation
- ❌ NEVER grep/glob/read multiple files directly for investigation

---

**Related Documentation**:
- Full team patterns: `.claude/docs/TEAMS-FRAMEWORK.md`
- Agent creation guide: `.claude/agents/{name}/GUIDE.md` (examples)
- Context preservation: `.claude/docs/CONTEXT-PRESERVATION.md`
