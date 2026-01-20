#!/usr/bin/env bash
# Context Preservation Testing Script

echo "Running Context Preservation Tests..."

# Test 1: Manual Preservation
echo "Test 1: Manual Preservation"
bash ~/.claude/hooks/preserve-instructions.sh
if [[ -f ~/.claude/.preserved-context.md ]]; then
    echo "✓ Preserved file created"
    TOKEN_COUNT=$(wc -w < ~/.claude/.preserved-context.md)
    if (( TOKEN_COUNT < 500 )); then
        echo "✓ Token count within budget: $TOKEN_COUNT"
    else
        echo "✗ Token count exceeds budget: $TOKEN_COUNT"
    fi
    rm ~/.claude/.preserved-context.md
else
    echo "✗ Preserved file not created"
fi

# Test 2: Manual Restoration
echo ""
echo "Test 2: Manual Restoration"
cat > ~/.claude/.preserved-context.md << 'TEST'
# TEST CONTEXT
- Agent-first development
- Data accuracy
TEST

bash ~/.claude/hooks/restore-instructions.sh > /dev/null
if [[ ! -f ~/.claude/.preserved-context.md ]]; then
    echo "✓ Preserved file cleaned up"
else
    echo "✗ Preserved file not deleted"
    rm ~/.claude/.preserved-context.md
fi

echo ""
echo "Tests complete. Check ~/.claude/debug/context-preservation.log for details."
