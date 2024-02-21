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

# get the pull request number
pr_number=$(gh pr view --json number --jq '.number' | tr -d '\n')

git merge-into "$1" "--no-ff" "-m Merge PR #$pr_number: \"$2\""

lazygit #open log to inspect the merge commit
