#!/usr/bin/env bash

#this script merges the checked out branch into target branch

# help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: merge-into <target-branch> <merge-arguments>"
  echo "Merge the checked out branch into the target branch"
  echo "  <target-branch>  The branch to merge into"
  echo "  <merge-arguments>  The arguments to pass to the merge command"
  exit 0
fi

# remember the current branch
current_branch=$(git symbolic-ref --short HEAD)
# checkout the target branch
git checkout "$1"

git pull origin "$1"

echo "git merge $current_branch $1 $2 $3 $4 $5 $6 $7 $8 $9"

# merge the current branch into the target branch
git merge "$current_branch" "${@:2}"
