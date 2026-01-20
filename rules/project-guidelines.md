# Project Guidelines

**Priority**: MEDIUM
**Enforcement**: STANDARD
**Tokens**: ~100

> **Context Expansion**: For framework details, load `.claude/MEMORY-ORGANIZATION.md` and `.claude/QUICKSTART.md`

---

## General Standards

### Git Commit Rules

**Format**:
```
type: Brief description

Detailed explanation if needed.

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

**Types**: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`

**Rules**:
- Use present tense ("add feature" not "added feature")
- Capitalize first letter
- No period at end of subject line
- Reference issue numbers if applicable
- ALWAYS use HEREDOC for multi-line messages

### Code Review Requirements

**Before committing**:
- [ ] Code follows project style guide
- [ ] Tests pass (if project has tests)
- [ ] No hardcoded secrets or credentials
- [ ] Documentation updated (if needed)
- [ ] Validation from appropriate agent (if using agents)

### Documentation Standards

**When to document**:
- New features (explain usage)
- Breaking changes (migration guide)
- Complex logic (inline comments)
- API changes (update API docs)

**When NOT to document**:
- Self-explanatory code
- Temporary debugging code
- Internal implementation details (unless complex)

### Project Structure

**Respect existing patterns**:
- Follow directory structure already in place
- Match naming conventions used in project
- Use same dependency management approach
- Follow existing error handling patterns

### Progressive Context Loading

**Level 1 - Always Load**:
- Project CLAUDE.md (overview only)
- .context.quick.md (summary)

**Level 2 - Load When Needed**:
- .context.md (full context)
- .status.md (roadmap)
- Project-specific rules

**Level 3 - Load On-Demand**:
- Historical logs
- Full documentation
- Detailed specifications

> **Note**: For progressive loading details, read `.claude/CLI-CONTEXT-LOADING.md`

### Session Commands

| Command | Action | Context Impact |
|---------|--------|----------------|
| `/continue` | Resume last session | ~1k tokens |
| `/end` | Save & sync | None |
| `/switch {project}` | Change project | Minimal |

Execute via: `Skill("command-name")`

> **Note**: For skill documentation, read `.claude/skills/{name}/GUIDE.md`

### Best Practices

1. **Keep context minimal** - Load only what you need
2. **Use agents for exploration** - Don't bloat main context
3. **Verify before committing** - Use validators
4. **Document decisions** - Save to project .context.md
5. **Respect token budget** - Monitor context usage

---

**Related Documentation**:
- Memory system: `.claude/MEMORY-ORGANIZATION.md`
- Framework quickstart: `.claude/QUICKSTART.md`
- Context loading guide: `.claude/CLI-CONTEXT-LOADING.md`
- Skills documentation: `.claude/skills/{name}/GUIDE.md`
- Workflows: `.claude/workflows/{name}.md`
