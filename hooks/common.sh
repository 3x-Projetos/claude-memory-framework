#!/usr/bin/env bash
# Common utilities for context preservation hooks

# Directories
CLAUDE_DIR="$HOME/.claude"
PRESERVED_FILE="$CLAUDE_DIR/.preserved-context.md"
RULES_DIR="$CLAUDE_DIR/rules"
MEMORY_DIR="$HOME/.claude-memory"
SESSION_STATE="$MEMORY_DIR/providers/claude/session-state.md"
LOG_DIR="$CLAUDE_DIR/debug"

# Token budget
MAX_TOKENS=500
GLOBAL_RULES_TOKENS=200
PROJECT_CONTEXT_TOKENS=150
SESSION_STATE_TOKENS=100

# Logging
log_event() {
    local event="$1"
    local details="$2"
    mkdir -p "$LOG_DIR"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $event: $details" >> "$LOG_DIR/context-preservation.log"
}

# File existence checks
file_exists() {
    [[ -f "$1" ]]
}

dir_exists() {
    [[ -d "$1" ]]
}

# Token counting (word-based approximation)
count_tokens() {
    local file="$1"
    if file_exists "$file"; then
        wc -w < "$file" | tr -d ' '
    else
        echo "0"
    fi
}

# Extract section from markdown file
extract_section() {
    local file="$1"
    local start_marker="$2"
    local max_lines="${3:-50}"
    
    if file_exists "$file"; then
        awk -v start="$start_marker" -v max="$max_lines" '
            $0 ~ start {found=1; count=0}
            found {
                print
                count++
                if (count >= max) exit
            }
            /^## / && found && count > 0 {exit}
        ' "$file"
    fi
}

# Get current project from session-state.md
get_current_project() {
    if file_exists "$SESSION_STATE"; then
        grep -A 1 "^## Current Focus" "$SESSION_STATE" | grep "^**Projeto" | sed 's/\*\*Projeto\*\*: //' | tr -d '\n'
    fi
}

# Check if project has .claude directory
has_project_config() {
    local project="$1"
    [[ -d "$MEMORY_DIR/projects/$project/.claude" ]]
}

export -f log_event file_exists dir_exists count_tokens extract_section get_current_project has_project_config
