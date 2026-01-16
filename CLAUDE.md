# Claude Memory System - Framework Guide

Multi-device memory system for AI providers. This complements ~/.claude/CLAUDE.md with framework-specific context.

## 🚨 CRITICAL: Data Accuracy

**ABSOLUTE RULE - NEVER INVENT DATA**:
- ❌ NO fabricated numbers (costs, metrics, percentages, benchmarks)
- ❌ NO made-up status values (Ctx%, 5H%, WK%)
- ❌ NO guessed pricing or specifications
- ✅ ALWAYS verify from actual sources (files, WebSearch, user)
- ✅ ALWAYS cite sources for factual claims
- ✅ If unknown, say "I need to research this" - never guess

**Why**: Invented data ruins decisions, costs money/time, breaks trust.

---

## 🤖 CRITICAL: Agent-First Development

**ABSOLUTE RULE - ALWAYS USE SPECIALIZED AGENTS AND TEAMS**:
- ✅ ALWAYS use existing specialized agents for tasks that match their domain
- ✅ If no suitable agent exists, CREATE ONE before starting work
- ✅ Use TEAMS for complex tasks requiring multiple agents (see TEAMS-FRAMEWORK.md)
- ✅ Agents prevent context bloat and enable focused, specialized problem-solving
- ✅ Agents maintain expertise and best practices in their domain
- ❌ NEVER do complex work directly without considering agents first
- ❌ NEVER skip agent creation when a new specialization is needed

**Key Concepts**:
- **Persona/Agent Definition**: GUIDE.md file defining expertise (e.g., `backend-validator/GUIDE.md`)
- **Worker/Agent Instance**: Parallel execution using Task tool
- **Team**: Structured coordination of multiple agents (Sequential, Parallel, Hierarchical, Iterative, Hub-and-Spoke)

**Available Agents (check `.claude/agents/` directory)**:
- `backend-validator` - Validate routes, schemas, error handling, security
- `frontend-validator` - Validate accessibility, performance, UX, type safety
- `tech-lead-coordinator` - Assess architecture, coordinate agents, identify risks
- `test-specialist` - Analyze coverage, suggest test cases, validate quality
- `ui-specialist` - Evaluate layout, spacing, visual design, responsiveness
- `ux-specialist` - Analyze usability, flows, accessibility, error handling
- `api-debugger` - Compare implementations, debug API issues, analyze Postman/scripts

**Agent-First Workflow**:
1. **Identify task complexity**: Single agent or team needed?
2. **Consult TEAMS-FRAMEWORK.md**: Choose appropriate team pattern (see `.claude/docs/TEAMS-FRAMEWORK.md`)
3. **Check existing agents**: Use `.claude/agents/` directory
4. **Create missing agents**: Define persona before starting work
5. **Execute team workflow**: Parallel, Sequential, or Iterative based on pattern
6. **Synthesize results**: Coordinate between agents

**Team Patterns** (see TEAMS-FRAMEWORK.md for details):
- **Sequential Team**: Tasks depend on previous results (e.g., Plan → Design → Implement → Validate)
- **Parallel Team**: Independent tasks run simultaneously (e.g., validate multiple files)
- **Hierarchical Team**: Complex problems with sub-teams (e.g., Backend Team + Frontend Team)
- **Iterative Team**: Refinement until approval (e.g., Design → Review → Refine → Approve)
- **Hub-and-Spoke Team**: Coordinator consults specialists (e.g., Pre-deployment checklist)

**Why**: Agents provide consistent expertise, teams enable complex problem-solving, both reduce errors and prevent context waste.

**Reference Documentation**:
- Full team patterns: `.claude/docs/TEAMS-FRAMEWORK.md`
- Agent creation: Follow patterns in existing agents
- Examples: See Sprint 3 in TEAMS-FRAMEWORK.md

---

## Quick Reference

**Memory Location**: `~/.claude-memory/`
**Cloud Sync**: `~/.claude-memory-cloud/` (optional)
**Framework Version**: v3.4

## Essential Structure

```
~/.claude-memory/
├── providers/claude/
│   ├── session-state.md       # START HERE (current state)
│   └── logs/daily/            # Session logs
├── projects/{name}/
│   ├── .context.quick.md      # Load this (summary)
│   └── .context.md            # Load on-demand (full)
└── integration/
    └── provider-activities.quick.md  # Recent activity
```

## Session Commands (Skills)

| Command | Action | Context Impact |
|---------|--------|----------------|
| `/continue` | Resume last session | ~1k tokens (state + quick files) |
| `/end` | Save & sync | None (saves context) |
| `/switch {project}` | Change project | Minimal (quick context only) |

Execute via: `Skill("command-name")`

## Progressive Loading Pattern

**First load**:
1. `session-state.md` (where you left off)
2. `provider-activities.quick.md` (recent work)
3. If continuing project: `.context.quick.md` only

**Load on-demand**:
- `.context.md` - when modifying project details
- `.status.md` - when checking roadmap
- Full logs - when researching history

## Current Work (v3.4)

**Active**: Issue #13 (Progressive Context Loading), #12 (Labels), #9 (CHANGELOG)
**GitHub**: https://github.com/luisromano-gf/claude-memory-system-repo/issues

## File Conventions

- Logs: `YYYY.MM.DD.md` (daily), `YYYY.WW.md` (weekly)
- Quick files: Summaries (<500 tokens)
- Full files: Complete context (load only when editing)

## On-Demand References

Load these ONLY when modifying:
- `@README.md` - Framework overview
- `@QUICKSTART.md` - Setup guide
- `@MEMORY-ORGANIZATION.md` - Architecture details
- `.claude/skills/{name}/GUIDE.md` - Skill documentation

---

**This file loads when working in claude-memory-system-repo/**
**General session practices: see ~/.claude/CLAUDE.md**
