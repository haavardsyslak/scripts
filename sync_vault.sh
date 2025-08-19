#!/usr/bin/env bash
cd $HOME/vault || exit 1

# Check if a rebase is in progress
if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then
  echo "Rebase in progress, skipping sync at $(date)" >> /tmp/sync_vault_debug.log
  exit 0
fi

# Stage all changes
git add -A

local_changes=false
remote_behind=false

# Commit local changes if any
if ! git diff-index --quiet --cached HEAD; then
  git commit -m "auto: update $(date '+%F %T')"
  local_changes=true
fi

# Fetch remote updates
git fetch

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

# Check if remote has new commits (local behind remote)
if [ "$LOCAL" = "$BASE" ] && [ "$REMOTE" != "$BASE" ]; then
  remote_behind=true
fi

if $remote_behind; then
  echo "Remote ahead, pulling with rebase at $(date)" >> /tmp/sync_vault_debug.log
  git pull --rebase
fi

if $local_changes || $remote_behind; then
  echo "Pushing changes at $(date)" >> /tmp/sync_vault_debug.log
  git push
else
  echo "No changes to push at $(date)" >> /tmp/sync_vault_debug.log
fi
