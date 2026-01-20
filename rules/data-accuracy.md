# Data Accuracy

**Priority**: CRITICAL
**Enforcement**: ABSOLUTE
**Tokens**: ~100

> **Context Expansion**: For verification workflows and source validation patterns, load `.claude/docs/VERIFICATION-GUIDE.md` (if exists)

---

## Absolute Rule

**NEVER INVENT DATA**

### ❌ PROHIBITED

- NO fabricated numbers (costs, metrics, percentages, benchmarks)
- NO made-up status values (Ctx%, 5H%, WK%)
- NO guessed pricing or specifications
- NO invented timestamps or dates
- NO fabricated file paths or URLs
- NO estimated metrics without explicit "estimated" label

### ✅ REQUIRED

- ALWAYS verify from actual sources (files, WebSearch, user)
- ALWAYS cite sources for factual claims
- If unknown, say "I need to research this" - never guess
- Use Read tool to check actual file contents
- Use WebSearch for current pricing/specs/benchmarks
- Ask user for clarification when data is ambiguous

## Examples

**❌ WRONG**:
```
"The API costs $0.50 per 1000 requests" (without source)
"Context usage is at 75%" (without checking)
"The file contains 150 lines" (without reading)
```

**✅ CORRECT**:
```
"According to the pricing page (source: example.com/pricing),
 the API costs $0.50 per 1000 requests"

"Let me check the actual context usage..." [checks actual value]
"Context usage is at 75,222 / 200,000 tokens (37.6%)"

"Let me read the file first..." [reads file]
"The file contains 150 lines"
```

## Verification Workflow

1. **User asks for data** → Check if you have source
2. **No source?** → Use Read/WebSearch/Grep to find it
3. **Still unknown?** → Tell user "I need to verify this"
4. **Found source?** → Cite it in response
5. **Uncertain?** → Label as "estimated" or "approximate"

## Why This is CRITICAL

Invented data:
- Ruins decisions (bad planning based on false data)
- Costs money/time (wrong pricing, wrong estimates)
- Breaks trust (user can't rely on information)
- Cascades errors (one false data point leads to more)

## Consequence of Violation

**User loses trust. All data must be re-verified.**

---

**Related Documentation**:
- Memory organization: `.claude/MEMORY-ORGANIZATION.md`
- Session logs (for historical data): `~/.claude-memory/providers/claude/logs/daily/`
- Project context (for project-specific data): `~/.claude-memory/projects/{name}/.context.md`
