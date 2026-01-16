# Discover Updates - Usage Examples

## Example 1: Monthly Broad Scan

**User**: "What's new with Claude this month?"

**Agent Workflow**:
1. Search Anthropic blog (past 30 days)
2. Check Claude Code CLI releases (last 3 versions)
3. Scan r/ClaudeAI top posts (past month)
4. Check Hacker News mentions

**Output**:
```
## 🎯 Highlights (December 2025)

1. **Model** Claude 3.7 Sonnet Released
   - What: 15% faster, better code reasoning
   - Impact: Faster responses, fewer errors in complex code
   - Source: https://anthropic.com/news/claude-3-7

2. **CLI** New `/compact` command (v1.2.0)
   - What: Summarize context to free tokens
   - Impact: Work longer without hitting limits
   - Source: GitHub release v1.2.0

3. **Community** Claude MCP Protocol gaining traction
   - What: Standard for Claude tool integrations
   - Impact: Easier to add external tools
   - Source: r/ClaudeAI discussion

## 💡 How to Apply

- **Use Claude 3.7**: Already available via API, expect better code reviews
- **Try /compact**: Use at 70% context to extend sessions
- **Explore MCP**: Check awesome-claude-mcp for ready tools

## 🤖 Agent Notes

- New capabilities: Faster inference, context compression
- Workflow optimizations: Use /compact proactively
- Tools to integrate: MCP-compatible tools (file watchers, databases)

## ✅ Suggested Actions

- [ ] Test Claude 3.7 on complex refactoring task
- [ ] Install MCP file-watcher tool
- [ ] Update workflow to use /compact at 70% context
```

---

## Example 2: Feature-Specific Research

**User**: "Are there better ways to handle context limits in Claude Code?"

**Agent Workflow**:
1. Check API changelog for context-related updates
2. Search GitHub issues: `is:issue context limit`
3. Search Reddit: `site:reddit.com/r/ClaudeAI context management`
4. Look for community tools: `topic:claude-ai context`

**Output**:
```
## 🎯 Context Management Updates

1. **Official** Prompt Caching (API feature)
   - What: Reuse common context across requests
   - Impact: 90% cost reduction for repeated context
   - Source: API changelog Nov 2025

2. **CLI** /compact command (built-in)
   - What: Summarize and compress current context
   - Impact: Continue work without clearing
   - Source: Claude Code v1.2.0

3. **Community** Context Rotator tool
   - What: Auto-rotate context based on relevance scoring
   - Impact: Keep only relevant context loaded
   - Source: github.com/user/claude-context-rotator

## 💡 How to Apply

- **Enable prompt caching**: Add system context once, reuse across session
- **Use /compact regularly**: At 70% capacity, not 95%
- **Try Context Rotator**: If working with many files

## ✅ Suggested Actions

- [ ] Configure prompt caching for framework docs
- [ ] Test /compact effectiveness (measure token savings)
- [ ] Evaluate Context Rotator for multi-file projects
```

---

## Example 3: Workflow Optimization

**User**: "Show me latest best practices for Claude Code workflows"

**Agent Workflow**:
1. Search Reddit: `flair:Tutorial site:reddit.com/r/ClaudeAI`
2. Check GitHub discussions: `label:best-practices`
3. Search Twitter: `#ClaudeAI tips OR tricks`
4. Review community guides

**Output**:
```
## 🎯 Best Practices (Community Insights)

1. **Progressive Loading** (Reddit tip)
   - Load summaries first, details on-demand
   - Example: Read README headers, then use @mentions
   - Impact: 60-80% context savings

2. **Commit Early, Commit Often** (GitHub discussion)
   - Claude works best with clean checkpoints
   - Use /end after each meaningful change
   - Impact: Better session recovery, clearer history

3. **Subagent Pattern** (Community guide)
   - Use Task tool for isolated work
   - Keep main context focused
   - Impact: Avoid context pollution

4. **@-References Over Read** (Official rec)
   - Reference files with @ instead of reading
   - Let Claude decide what to load
   - Impact: Smarter context management

## 💡 How to Apply

- **Adopt progressive loading**: Start sessions with quick files only
- **Commit workflow**: After each feature/fix, run /end
- **Use subagents**: For research, exploration, isolated tasks
- **Switch to @-refs**: In prompts like "update @config.json"

## ✅ Suggested Actions

- [ ] Refactor session start (load .quick.md files only)
- [ ] Create /end alias for faster commits
- [ ] Identify tasks suitable for subagents
- [ ] Update prompting style to use @-references
```

---

## Example 4: Integration Discovery

**User**: "What tools can extend Claude Code's capabilities?"

**Agent Workflow**:
1. Search GitHub: `topic:claude-ai topic:integration stars:>10`
2. Check awesome lists: "awesome claude", "awesome anthropic"
3. Scan community showcases on Reddit
4. Review MCP protocol implementations

**Output**:
```
## 🎯 Tool Integrations

### Official
1. **MCP Protocol** (Model Context Protocol)
   - Standard for Claude tool integrations
   - 50+ community tools available
   - Categories: File ops, DBs, APIs, search

### Community Tools
2. **Claude Code Runner** (GitHub: 200+ stars)
   - Execute code in sandboxed environments
   - Supports Python, JS, Rust, Go

3. **Claude Memory Plus** (GitHub: 150+ stars)
   - Enhanced memory with vector search
   - Semantic retrieval across sessions

4. **Claude Git Flow** (GitHub: 100+ stars)
   - Advanced git workflows (rebasing, cherrypick)
   - PR management integration

### Integrations
5. **VS Code Extension** (Official)
   - Claude Code directly in VS Code
   - Context-aware completions

6. **Obsidian Plugin** (Community)
   - Use Claude with your notes
   - RAG over personal knowledge base

## 💡 How to Apply

- **Start with MCP**: Install 2-3 tools (file watcher, database, search)
- **Try Code Runner**: For safe execution of untrusted code
- **Explore Memory Plus**: If session history is large (>100 sessions)

## ✅ Suggested Actions

- [ ] Install MCP file-system tool
- [ ] Test Code Runner with Python scripts
- [ ] Evaluate VS Code extension for IDE workflow
- [ ] Review Obsidian plugin for note integration
```

---

## Example 5: Troubleshooting with Latest Info

**User**: "I'm hitting rate limits, are there any updates to help with this?"

**Agent Workflow**:
1. Check API changelog: "rate limit" OR "quotas"
2. Search GitHub issues: `is:issue rate limit label:enhancement`
3. Search Reddit: `site:reddit.com/r/ClaudeAI rate limit workaround`
4. Look for community tools: rate limiting, retry logic

**Output**:
```
## 🎯 Rate Limit Solutions

1. **API Update** Increased Rate Limits (Nov 2025)
   - Tier 2: 100 → 200 RPM
   - Tier 3: 500 → 1000 RPM
   - Source: API changelog

2. **Feature** Batch API (Beta)
   - Send multiple requests as single batch
   - 50% cost reduction
   - Source: Anthropic blog

3. **Community** Claude Queue Manager
   - Auto-retry with exponential backoff
   - Request prioritization
   - Source: github.com/user/claude-queue

## 💡 How to Apply

- **Check your tier**: May already have higher limits
- **Use Batch API**: For non-interactive requests (e.g., bulk processing)
- **Install Queue Manager**: For production apps with high request volume

## ✅ Suggested Actions

- [ ] Verify current rate limit tier (check dashboard)
- [ ] Apply for Batch API beta access
- [ ] Test Queue Manager with current workflow
```

---

## Tips for Effective Usage

### When to Use This Skill
- **Monthly check-ins**: Stay updated on major changes
- **Before new projects**: Ensure using latest capabilities
- **When stuck**: See if new tools solve your problem
- **Learning sessions**: Discover best practices

### How to Prompt
- Specific: "What's new with Claude API this month?"
- Focused: "Updates on context management in Claude Code"
- Broad: "Latest Claude and CLI updates"
- Problem-oriented: "Are there tools to help with [problem]?"

### Follow-Up Actions
After discovering updates:
1. **Test immediately**: Try new features hands-on
2. **Document learnings**: Add to memory system
3. **Update workflows**: Integrate improvements
4. **Share insights**: Contribute to community (optional)

---

**Remember**: Discovery is just the first step. Application creates value!
