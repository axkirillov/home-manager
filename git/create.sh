#!/usr/bin/env bash

function branch {
	# replace spaces with hyphens
	name=$(echo "$1" | tr ' ' '-')
	git checkout -b "$name"
}

# check if 1st argument is "branch" (use a case statement)
# if it is, create the branch specified in the 2nd argument
case $1 in
branch)
	branch "$2"
	;;
*)
	echo "I don't know how to create that"
	;;
esac
