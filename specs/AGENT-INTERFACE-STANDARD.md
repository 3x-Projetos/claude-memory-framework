# Agent Interface Standard (v4.0)

**Version**: 1.0.0
**Date**: 2026-01-06
**Status**: Draft

Multi-agent orchestration standard for Claude Memory System v4.0, using Claude Agent Skills API format.

---

## 1. Architecture Overview

### Orchestrator-Specialist Pattern

```
User Request
    ↓
[Orchestrator] (Claude Sonnet/Opus)
    ↓
┌───────────┬──────────────┬──────────────┐
│ Researcher│  Engineer    │  Analyst     │
│ (Haiku)   │  (Sonnet)    │  (Haiku)     │
└───────────┴──────────────┴──────────────┘
    ↓            ↓             ↓
[Orchestrator] ← Aggregates Results
    ↓
User Response
```

**Core Components**:
- **Orchestrator**: Task decomposition, delegation, result synthesis
- **Specialists**: Domain-specific execution (research, code, analysis)
- **Context Manager**: Minimal context passing, state compression

---

## 2. Agent Definition Format

### 2.1 Skills API Structure

All agents are defined using Claude Agent Skills API format (Tool Use standard):

```json
{
  "name": "researcher_analyst",
  "description": "Research and analyze information from web, docs, and memory. Use when user needs: data collection, fact verification, literature review, competitive analysis. Returns: structured findings with citations.",
  "input_schema": {
    "type": "object",
    "properties": {
      "task": {
        "type": "string",
        "description": "The research question or analysis objective. Be specific about what information is needed and why."
      },
      "sources": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["web", "docs", "memory", "code"]
        },
        "description": "Which sources to search. Default: all available."
      },
      "depth": {
        "type": "string",
        "enum": ["quick_scan", "deep_dive", "comprehensive"],
        "description": "Research rigor level. quick_scan=5 min, deep_dive=15 min, comprehensive=30 min."
      },
      "output_format": {
        "type": "string",
        "enum": ["summary", "detailed_report", "bullet_points"],
        "description": "How to structure findings. Default: summary."
      }
    },
    "required": ["task", "depth"],
    "additionalProperties": false
  }
}
```

### 2.2 Required Fields

**All agent definitions MUST include**:

1. **`name`**: Snake_case identifier (e.g., `code_writer`, `data_analyst`)
2. **`description`**: Detailed natural language explanation of:
   - What the agent does
   - When to use it (trigger scenarios)
   - What it returns (output type)
3. **`input_schema`**: JSON Schema (Draft 2020-12) with:
   - `type: "object"`
   - `properties`: All input parameters
   - `required`: List of mandatory fields
   - `additionalProperties: false` (strict mode)

---

## 3. Context Passing Strategy

### 3.1 Minimal Context Handoff

**Problem**: Full context → 200K tokens per agent → expensive, slow
**Solution**: Compressed context → ~2-5K tokens per agent → 95% savings

**Pattern**:
```json
{
  "source_agent": "orchestrator",
  "target_agent": "researcher_analyst",
  "message_type": "task_delegation",
  "payload": {
    "task_id": "r_001",
    "instruction": "Find latest Haiku 4.5 pricing",
    "context_summary": "User asked about cost optimization. We need current API pricing to calculate savings.",
    "constraints": ["verified_sources_only", "max_2_minutes"],
    "required_output_format": "json_table"
  }
}
```

**Context Summary Guidelines**:
- **What**: 1-2 sentences on current task
- **Why**: 1 sentence on broader goal
- **Constraints**: List of limitations (time, sources, format)
- **No full history**: Orchestrator holds complete context

### 3.2 Return Format

**All agents MUST return structured data**:

```json
{
  "status": "success",  // or "error", "partial"
  "result": {
    // Agent-specific data (structured, not free text)
    "findings": [...],
    "citations": [...]
  },
  "metadata": {
    "execution_time_ms": 1250,
    "tokens_used": 3200,
    "confidence": 0.95,
    "model_used": "claude-haiku-4-5"
  },
  "reasoning_log": "..." // Optional: for debugging, orchestrator discards to save tokens
}
```

---

## 4. Error Handling

### 4.1 Self-Correction Loop

**Pattern**: Agent fails → System prompts retry → Max 2 attempts → Escalate

```json
{
  "error_type": "validation_error",  // or "runtime_error", "timeout"
  "message": "Invalid source 'reddit' not in allowed list",
  "correction_hint": "The 'sources' field must be from: ['web', 'docs', 'memory', 'code']. Please retry with valid sources.",
  "retry_count": 1,
  "max_retries": 2
}
```

**Error Schema Requirements**:
- **`error_type`**: enum of known error categories
- **`message`**: Human-readable error
- **`correction_hint`**: Specific instruction to fix the request
- **`retry_count`**: Current retry number

### 4.2 Escalation

If agent fails after max retries:
1. Return to orchestrator with `status: "failed"`
2. Orchestrator re-plans (try alternative agent or approach)
3. Log failure for post-mortem analysis

---

## 5. Model Allocation Strategy

### 5.1 Cost-Optimized Distribution

**Target**: 70% Haiku, 25% Sonnet, 5% Opus

| Agent Type | Model | Use Cases | Cost/1M tokens |
|------------|-------|-----------|----------------|
| Orchestrator | Sonnet 4.5 | Task decomposition, synthesis | $3/$15 |
| Orchestrator (simple) | Haiku 4.5 | Routine delegation | $1/$5 |
| Researcher | Haiku 4.5 | Data collection, validation | $1/$5 |
| Analyst | Haiku 4.5 | Structured analysis | $1/$5 |
| Engineer (simple) | Haiku 4.5 | Code review, docs | $1/$5 |
| Engineer (complex) | Sonnet 4.5 | New features, refactoring | $3/$15 |
| Architect | Opus 4.5 | System design, critical decisions | $7.50/$37.50 |

### 5.2 Dynamic Selection

**Orchestrator presents options to user**:

```
I can handle this task with:

A) Haiku Researcher (~2K tokens, $0.002, 30s)
   - Fast, cost-effective
   - Good for straightforward research

B) Sonnet Engineer (~15K tokens, $0.045, 90s)
   - Higher quality, better reasoning
   - Recommended for complex analysis

Choose [A/B] or let me decide:
```

**User decides** for non-routine tasks. **Auto-select** with notification for routine work.

---

## 6. Agent Catalog (v4.0)

### 6.1 Phase 1 Agents (Week 1-2)

**Orchestrator** (Built-in)
- Model: Sonnet 4.5 (default) / Opus 4.5 (complex)
- Capabilities: Task decomposition, delegation, synthesis
- Tools: All specialist agents

**Researcher-Analyst** (First specialist)
- Model: Haiku 4.5
- Capabilities: Web search, doc analysis, memory search
- Tools: WebSearch, WebFetch, Grep, Read
- Use cases: Fact verification, data collection, literature review

### 6.2 Phase 2 Agents (Week 3-4)

**Code-Engineer-Executor**
- Model: Haiku 4.5 (review/docs) / Sonnet 4.5 (implementation)
- Capabilities: Code writing, review, refactoring
- Tools: Read, Write, Edit, LSP (semantic navigation)
- Use cases: Feature implementation, bug fixes, code review

**Data-Analyst**
- Model: Haiku 4.5
- Capabilities: Data processing, metrics calculation, reporting
- Tools: Read (CSV/JSON), Bash (data tools)
- Use cases: Log analysis, metrics aggregation, performance reports

### 6.3 Phase 3 Agents (Future)

**System-Architect**
- Model: Opus 4.5
- Capabilities: System design, architectural decisions
- Tools: All agents (meta-orchestrator)
- Use cases: Major refactoring, system redesign, critical decisions

---

## 7. JSON Schema Best Practices

### 7.1 Input Schema Principles

**✅ DO**:
- Use `enum` for finite choices (forces valid options)
- Set `additionalProperties: false` (prevents hallucinated params)
- Make fields `required` by default (explicit is better)
- Add detailed `description` for each field (this is the prompt!)
- Use `minLength`, `maximum`, `pattern` for validation

**❌ DON'T**:
- Use loose objects (`"items": {}` allows anything)
- Make everything optional (LLM will guess defaults)
- Rely on description alone (use enums + constraints)
- Allow free-text when structured options exist

### 7.2 Example: Strict Schema

```json
{
  "type": "object",
  "properties": {
    "query": {
      "type": "string",
      "description": "Search query. Use precise keywords, not full sentences.",
      "minLength": 3,
      "maxLength": 200
    },
    "category": {
      "type": "string",
      "enum": ["technical", "business", "research"],
      "description": "Domain filter. Affects which sources are searched."
    },
    "max_results": {
      "type": "integer",
      "description": "Maximum documents to return. Default: 5.",
      "minimum": 1,
      "maximum": 20,
      "default": 5
    }
  },
  "required": ["query", "category"],
  "additionalProperties": false
}
```

---

## 8. Handoff Patterns

### 8.1 Sequential Delegation

**Use case**: Task B depends on Task A output

```
Orchestrator
    ↓
[Researcher] → Find pricing data
    ↓ (returns structured JSON)
Orchestrator (integrates data)
    ↓
[Analyst] → Calculate cost savings
    ↓ (returns analysis)
Orchestrator → Synthesize final report
```

### 8.2 Parallel Delegation

**Use case**: Independent tasks, aggregate results

```
Orchestrator
    ├─→ [Researcher A] → Web search
    ├─→ [Researcher B] → Memory search
    └─→ [Researcher C] → Doc search
         ↓  ↓  ↓
    Orchestrator (Map-Reduce aggregation)
```

### 8.3 Recursive Decomposition

**Use case**: Complex task requires sub-orchestration

```
Orchestrator
    ↓
[Engineer] (receives complex feature request)
    ├─→ [Self] Break down into 3 sub-tasks
    ├─→ Execute sub-task 1
    ├─→ Execute sub-task 2
    └─→ Execute sub-task 3
    ↓
Orchestrator (integrates feature)
```

---

## 9. Implementation Roadmap

### Week 1: Foundation
- [x] Create AGENT-INTERFACE-STANDARD.md
- [ ] Implement orchestrator model selection UI
- [ ] Design researcher-analyst agent JSON definition
- [ ] Test Haiku vs Sonnet performance empirically

### Week 2: First Specialist
- [ ] Implement researcher-analyst agent
- [ ] Test minimal context handoff
- [ ] Validate error handling (retry loop)
- [ ] Measure token/cost savings

### Week 3: Code Agent + LSP
- [ ] Implement code-engineer-executor agent
- [ ] Integrate LSP tool for semantic navigation
- [ ] Test complex code generation tasks
- [ ] Document best practices

### Week 4: Production Validation
- [ ] Migrate all agent definitions to Skills API format
- [ ] End-to-end multi-agent workflow testing
- [ ] Performance benchmarking (cost, speed, quality)
- [ ] User documentation + examples

---

## 10. Versioning Strategy

### Append-Only Changes (Preferred)
- **Never remove required fields**
- **Add new fields as optional**
- **Deprecate gracefully**: Mark `deprecated: true` in description

### Versioned Agents (Breaking Changes)
- **New major version**: `researcher_analyst_v2`
- **Allows migration**: Old agents continue working
- **Sunset period**: 2 versions supported simultaneously

---

## References

**Research Documents**:
- `global/discoveries/gemini-workers/2026-01-06/worker1-skills-api-format.md`
- `global/discoveries/gemini-workers/2026-01-06/worker2-existing-patterns.md`
- `global/discoveries/gemini-workers/2026-01-06/worker3-json-schema.md`
- `global/discoveries/gemini-workers/2026-01-06/worker4-handoff-patterns.md`

**Standards**:
- Claude Agent Skills API (Tool Use): https://docs.anthropic.com/en/docs/tool-use
- JSON Schema Draft 2020-12: https://json-schema.org/draft/2020-12/
- Model Context Protocol (MCP): https://modelcontextprotocol.io/

---

**Last Updated**: 2026-01-06 11:45
**Contributors**: Claude Sonnet 4.5, Gemini Workers (1-4)
