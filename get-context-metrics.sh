#!/bin/bash
# Get context metrics from ccstatusline and system state

# Try to get ctx(u) from ccstatusline (if available)
# For now, we'll have Claude read it manually from the status line
# and pass it as parameter, or we extract from ccstatusline output

echo "Context metrics helper - requires manual reading from statusline"
echo "Usage: Report ctx(u) value from your statusline in /end"
