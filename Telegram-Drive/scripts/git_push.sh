#!/bin/sh
set -e

if [ -z "$GITHUB_PUSH_TOKEN" ] || [ -z "$GITHUB_REPO" ]; then
  echo "GITHUB_PUSH_TOKEN and GITHUB_REPO must be set in environment"
  exit 1
fi

BRANCH=${1:-main}
git add -A
git commit -m "chore: prepare deployment configs" || true
git remote remove origin 2>/dev/null || true
git remote add origin "https://${GITHUB_PUSH_TOKEN}@github.com/${GITHUB_REPO}.git"
git push -u origin $BRANCH
