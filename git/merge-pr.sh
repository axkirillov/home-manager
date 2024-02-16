#!/usr/bin/env bash

# this script merges the pull request into the target branch

# help
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	echo "Usage: merge-pr <target-branch> <merge-arguments>"
	echo "Merge the pull request into the target branch"
	echo "  <target-branch>  The branch to merge into"
	echo "  <merge-arguments>  The arguments to pass to the merge command"
	exit 0
fi

# remember the current branch
current_branch=$(git symbolic-ref --short HEAD)
# get the pull request number
pr_number=$(gh pr view --json number --jq '.number' | tr -d '\n')

git merge-into "$1" "--no-ff" "-m Merge PR #$pr_number: \"$2\""

lazygit #open log to inspect the merge commit

#ask if the user wants to push the changes
read -p "Do you want to push the changes? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	git push origin "$1"
fi

# ask if the user wants to delete the branch
read -p "Do you want to delete the branch? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	git delete branch "$current_branch"
fi
