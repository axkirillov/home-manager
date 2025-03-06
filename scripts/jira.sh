#!/bin/bash

list='/tmp/jira_all'
function fetch() {
	jira issue list -a"$(jira me)" -s~Done --plain --columns id,summary,status,type >$list
}

fetch

cat $list | fzf \
	--layout=reverse \
	--header-lines=1 \
	--preview-label 'ctrl-o = View in browser,  ctrl-j = Copy ID' \
	--color 'label:bold:red' \
	--preview 'jira issue view {1}' \
	--bind 'alt-enter:execute(jira issue edit {1})' \
	--bind 'ctrl-o:execute(jira open {1})' \
	--bind 'ctrl-j:execute(~/repo/home-manager/scripts/jira-create-branch.sh {1})+abort'
