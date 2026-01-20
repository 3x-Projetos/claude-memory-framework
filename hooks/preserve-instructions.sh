#!/usr/bin/env bash
# PreCompact Hook - Preserve critical context before compaction
# Called automatically when context reaches ~95% capacity

set -euo pipefail

# Source common utilities
# Use absolute path instead of BASH_SOURCE for Windows/Git Bash compatibility
source "$HOME/.claude/hooks/common.sh"

# Initialize
log_event "PRESERVE_START" "Context compaction detected, preserving critical instructions"

# Create preserved context file
cat > "$PRESERVED_FILE" << 'PRESERVED_HEADER'
# PRESERVED CONTEXT (Auto-Generated)

**Generated**: $(date '+%Y-%m-%d %H:%M:%S')
**Reason**: Context compaction detected
**Token Budget**: 500 tokens max

---

PRESERVED_HEADER

# Section 1: Critical Global Rules (~200 tokens)
if dir_exists "$RULES_DIR"; then
    echo "## Critical Global Rules" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    
    # Agent-first development (highest priority)
    if file_exists "$RULES_DIR/agent-first-development.md"; then
        echo "### Agent-First Development" >> "$PRESERVED_FILE"
        extract_section "$RULES_DIR/agent-first-development.md" "## Absolute Rule" 15 >> "$PRESERVED_FILE"
        extract_section "$RULES_DIR/agent-first-development.md" "## Enforcement Checklist" 8 >> "$PRESERVED_FILE"
        echo "" >> "$PRESERVED_FILE"
        log_event "PRESERVE_RULE" "Agent-first development rule preserved"
    fi
    
    # Data accuracy (critical)
    if file_exists "$RULES_DIR/data-accuracy.md"; then
        echo "### Data Accuracy" >> "$PRESERVED_FILE"
        extract_section "$RULES_DIR/data-accuracy.md" "## Absolute Rule" 12 >> "$PRESERVED_FILE"
        echo "" >> "$PRESERVED_FILE"
        log_event "PRESERVE_RULE" "Data accuracy rule preserved"
    fi
else
    log_event "PRESERVE_WARN" "Rules directory not found, skipping global rules"
fi

# Section 2: Current Project Context (~150 tokens)
CURRENT_PROJECT=$(get_current_project)

if [[ -n "$CURRENT_PROJECT" ]]; then
    echo "## Current Project Context" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    echo "**Active Project**: $CURRENT_PROJECT" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    
    # Check if project has specific rules
    if has_project_config "$CURRENT_PROJECT"; then
        PROJECT_CLAUDE="$MEMORY_DIR/projects/$CURRENT_PROJECT/.claude/CLAUDE.md"
        
        if file_exists "$PROJECT_CLAUDE"; then
            echo "**Project Instructions** (from .claude/CLAUDE.md):" >> "$PRESERVED_FILE"
            head -20 "$PROJECT_CLAUDE" >> "$PRESERVED_FILE"
            echo "" >> "$PRESERVED_FILE"
            log_event "PRESERVE_PROJECT" "Project context for $CURRENT_PROJECT preserved"
        fi
        
        # Check for project-specific rules
        PROJECT_RULES_DIR="$MEMORY_DIR/projects/$CURRENT_PROJECT/.claude/rules"
        if dir_exists "$PROJECT_RULES_DIR"; then
            echo "**Project Rules Available**: $(ls "$PROJECT_RULES_DIR" 2>/dev/null | tr '\n' ', ' | sed 's/,$//')" >> "$PRESERVED_FILE"
            echo "" >> "$PRESERVED_FILE"
        fi
    fi
    
    log_event "PRESERVE_PROJECT" "Current project: $CURRENT_PROJECT"
else
    echo "## Current Project Context" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    echo "**No active project detected**" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    log_event "PRESERVE_WARN" "No current project found in session-state.md"
fi

# Section 3: Session State (~100 tokens)
if file_exists "$SESSION_STATE"; then
    echo "## Session State" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    extract_section "$SESSION_STATE" "## Current Focus" 15 >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    log_event "PRESERVE_SESSION" "Session state preserved"
fi

# Section 4: Available Agents
if dir_exists "$CLAUDE_DIR/agents"; then
    echo "## Available Global Agents" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    ls "$CLAUDE_DIR/agents" 2>/dev/null | sed 's/^/- /' >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    log_event "PRESERVE_AGENTS" "Global agents list preserved"
fi

if [[ -n "$CURRENT_PROJECT" ]] && dir_exists "$MEMORY_DIR/projects/$CURRENT_PROJECT/.claude/agents"; then
    echo "## Project-Specific Agents" >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    ls "$MEMORY_DIR/projects/$CURRENT_PROJECT/.claude/agents" 2>/dev/null | sed 's/^/- /' >> "$PRESERVED_FILE"
    echo "" >> "$PRESERVED_FILE"
    log_event "PRESERVE_AGENTS" "Project agents list preserved"
fi

# Footer
cat >> "$PRESERVED_FILE" << 'PRESERVED_FOOTER'

---

**Restoration**: This context will be automatically restored in the next session.
**Location**: `~/.claude/.preserved-context.md`
**Self-destruct**: File will be deleted after restoration.

PRESERVED_FOOTER

# Check token count
TOKEN_COUNT=$(count_tokens "$PRESERVED_FILE")
log_event "PRESERVE_COMPLETE" "Preserved context created: $TOKEN_COUNT tokens"

if (( TOKEN_COUNT > MAX_TOKENS )); then
    log_event "PRESERVE_WARN" "Token count ($TOKEN_COUNT) exceeds budget ($MAX_TOKENS)"
fi

# Output summary (visible to Claude if run manually)
echo "✓ Context preserved: $TOKEN_COUNT tokens"
echo "✓ Location: $PRESERVED_FILE"
if [[ -n "$CURRENT_PROJECT" ]]; then
    echo "✓ Project: $CURRENT_PROJECT"
fi

exit 0
