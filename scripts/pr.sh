#!/bin/bash

gh pr list --json "author,number,title" | jq -r '.[] | "\(.number) - \(.title) - \(.author.login)"' | fzf | cut -d' ' -f1 | xargs gh pr checkout
