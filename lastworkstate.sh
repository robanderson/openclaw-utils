#!/bin/bash
# lastworkstate.sh - Roll back to last working state and restart OpenClaw
# Usage: ./lastworkstate.sh [--no-restart]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== OpenClaw Last Working State Recovery ==="
echo ""

# Check for --no-restart flag
NO_RESTART=false
if [[ "$1" == "--no-restart" ]]; then
    NO_RESTART=true
fi

# Step 1: Show current state
echo "1. Current git status:"
git status --short
echo ""

# Step 2: Rollback to last committed state
echo "2. Rolling back to last working commit..."
if git stash; then
    echo "   Stashed current changes (if any)"
fi

if git checkout HEAD -- .; then
    echo "   ✓ Reverted to last committed state"
else
    echo "   ✗ Failed to rollback"
    exit 1
fi
echo ""

# Step 3: Verify rollback
echo "3. Verification:"
echo "   Last 3 commits:"
git log --oneline -3
echo ""

# Step 4: Restart gateway (unless --no-restart)
if [ "$NO_RESTART" = false ]; then
    echo "4. Restarting OpenClaw gateway..."
    if command -v openclaw &> /dev/null; then
        if openclaw gateway restart; then
            echo "   ✓ Gateway restarted successfully"
        else
            echo "   ! Gateway restart failed (manual restart may be required)"
            echo "   Try: openclaw gateway restart"
        fi
    else
        echo "   ! 'openclaw' command not found"
        echo "   Manual restart required: openclaw gateway restart"
    fi
else
    echo "4. Skipping gateway restart (--no-restart flag set)"
fi

echo ""
echo "=== Recovery Complete ==="
echo "Last working state restored. Gateway restarted (if applicable)."
