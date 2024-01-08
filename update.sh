#!/usr/bin/env bash

if [[ $(git status --porcelain) ]]; then
	echo "branch is not clean"
	exit 1
fi
nix flake update
if [[ -z $(git status -s) ]]; then
	echo "nothing to update"
	exit 0
fi
git add .
git commit -m "update packages"
home-manager switch
