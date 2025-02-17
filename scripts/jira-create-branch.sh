#!/bin/bash

jira_title=$(jira issue list -q "key = $1" --plain | awk 'NR==2' | awk -F '\t' '{ print $3 }')
branchName=$(echo "$jira_title" | sed "s/[^[:alpha:].-]/-/g" | tr '[:upper:]' '[:lower:]')

git checkout -b "$1-$branchName"

