#!/usr/bin/env bash
if ! git diff-index --quiet HEAD; then 
  git add -A && 
  git commit -m "auto: update $(date '+\%F \%T')" && 
  git push; 
fi
