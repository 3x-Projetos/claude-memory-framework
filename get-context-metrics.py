#!/usr/bin/env python3
"""Get context metrics from current session transcript"""
import json, sys, os

# Get current session ID from history
history_path = os.path.expanduser("~/.claude/history.jsonl")
with open(history_path, 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()
    last_entry = json.loads(lines[-1])
    session_id = last_entry['sessionId']

# Read current session transcript
transcript_path = os.path.expanduser(f"~/.claude/projects/C--Users-Luis-Romano/{session_id}.jsonl")

try:
    with open(transcript_path, 'r', encoding='utf-8', errors='ignore') as f:
        lines = [l for l in f.readlines() if l.strip()]
    
    # Get last message with usage  
    for line in reversed(lines):
        entry = json.loads(line)
        if entry.get('isSidechain'): continue
        usage = entry.get('message', {}).get('usage', {})
        if not usage: continue
        
        # Calculate context length
        ctx = usage.get('input_tokens', 0) + usage.get('cache_read_input_tokens', 0) + usage.get('cache_creation_input_tokens', 0)
        
        # Calculate percentages
        raw_pct = (ctx / 200000) * 100
        ctxu_pct = (ctx / 160000) * 100  # Usable context (80% threshold)
        overhead = ctxu_pct - raw_pct
        
        # Output: tokens|raw%|ctx(u)%|overhead
        print(f"{ctx}|{raw_pct:.1f}|{ctxu_pct:.1f}|{overhead:.1f}")
        sys.exit(0)
        
except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    print("0|0|0|0")
    sys.exit(1)
