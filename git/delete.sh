#!/usr/bin/env bash

function branch {
	# check if brach is checked out
	# if it is, use fzf to choose another branch
	if [[ $(git branch --show-current) == "$1" ]]; then
		git checkout "$(git branch | fzf --header "Select a branch to checkout" | tr -d ' *')"
	fi
	# check if the branch exists
	if git show-ref --verify --quiet refs/heads/"$1"; then
		# check if it is merged
		if git branch --merged | grep "$1"; then
			# if it is, delete it
			git branch -d "$1"
		else
			# if it isn't, ask the user if they want to force delete it
			read -p "Branch $1 is not merged. Do you want to force delete it? (y/n) " -n 1 -r
			# if they do, delete it
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				git branch -D "$1"
			fi

		fi
		# check if remote exists
		if git show-ref --verify --quiet refs/remotes/origin/"$1"; then
			# ask if the user wants to delete the remote branch
			read -p "Do you want to delete the remote branch? (y/n) " -n 1 -r
			if [[ $REPLY =~ ^[Yy]$ ]]; then
				git push origin --delete "$1"
			fi
		fi
	else
		# if it doesn't exist, tell the user
		echo "error: branch $1 not found"
	fi
}

# check if 1st argument is "branch" (use a case statement)
# if it is, delete the branch specified in the 2nd argument
case $1 in
branch)
	# if the second argument is empty, use fzf to select a branch
	if [[ -z $2 ]]; then
		branch "$(git branch | fzf | tr -d ' *')"
	else
		branch "$2"
	fi
	;;
*)
	echo "I don't know how to delete that"
	;;
esac
