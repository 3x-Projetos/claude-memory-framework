#!/usr/bin/env bash
# SessionStart Hook - Restore preserved context after compaction
# Called automatically when Claude Code session starts

set -euo pipefail

# Source common utilities
# Use absolute path instead of BASH_SOURCE for Windows/Git Bash compatibility
source "$HOME/.claude/hooks/common.sh"

# Check if preserved context exists
if ! file_exists "$PRESERVED_FILE"; then
    # No preserved context = normal session start (no compaction occurred)
    log_event "RESTORE_SKIP" "No preserved context found, normal session start"
    exit 0
fi

# Log restoration event
log_event "RESTORE_START" "Preserved context found, restoring to session"

# Output preserved context to stdout (Claude will see this)
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 CRITICAL CONTEXT RESTORED FROM PREVIOUS SESSION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Context compaction occurred in the previous session."
echo "Critical instructions and project context have been preserved and are reloaded below."
echo ""

# Output the preserved content
cat "$PRESERVED_FILE"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get token count for logging
TOKEN_COUNT=$(count_tokens "$PRESERVED_FILE")
log_event "RESTORE_COMPLETE" "Context restored: $TOKEN_COUNT tokens"

# Clean up preserved file (self-destruct)
rm -f "$PRESERVED_FILE"
log_event "RESTORE_CLEANUP" "Preserved context file deleted"

# Output confirmation
echo "✓ Context restored successfully ($TOKEN_COUNT tokens)"
echo "✓ Preserved file cleaned up"
echo ""

exit 0
