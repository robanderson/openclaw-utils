# openclaw-utils
My utilities to help with Openclaw

## Scripts

### lastworkstate.sh

A recovery utility script that rolls back your OpenClaw workspace to the last working committed state and optionally restarts the OpenClaw gateway.

**What it does:**
1. Shows your current git status
2. Stashes any uncommitted changes
3. Reverts all files to the last committed state (HEAD)
4. Verifies the rollback by showing the last 3 commits
5. Restarts the OpenClaw gateway (unless `--no-restart` flag is used)

**Usage:**
```bash
# Roll back to last working state and restart gateway
./lastworkstate.sh

# Roll back without restarting gateway
./lastworkstate.sh --no-restart
```

**When to use this:**
- After making experimental changes that broke your OpenClaw setup
- To quickly revert to a known working state
- When you need to restore your workspace and restart services in one command
