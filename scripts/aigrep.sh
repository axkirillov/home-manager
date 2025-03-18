#!/bin/bash

# Exit if no prompt provided
if [ $# -eq 0 ]; then
	echo "Usage: $(basename "$0") <search prompt>"
	exit 1
fi

# Get the prompt from all arguments
prompt="$*"

# Generate project structure
get_project_structure() {
  echo "Project structure:"
  if command -v tree &> /dev/null; then
    tree -L 2 -d --noreport
  else
    find . -type d -not -path "*/\.*" -maxdepth 2 | sort | sed 's/[^-][^\/]*\//--/g'
  fi
}

# Capture project structure
project_structure=$(get_project_structure)

# Generate the ripgrep command
rg_command=$(aichat "you are a ripgrep expert assistant

PROJECT CONTEXT:
$project_structure

USER QUERY: \"$prompt\"

Generate the most effective ripgrep command to find relevant files matching this query.

REQUIREMENTS:
- Return ONLY the ripgrep command with no explanations or backticks
- Use -l to list only file paths
- Include smart pattern matching with context-aware regex
- Consider relevant file types using -t when appropriate 
- Use --ignore-case (-i) for better matching
- Leverage -C for context if needed
- Add --glob=!'*.git*' to exclude git-related files

Example outputs:
'rg -l -i \"config.*setup\" --type=python'
'rg -l -i -C2 \"api.*(auth|token)\" --type=js scripts/'
'rg -l -i \"(script|tool).*search\" --glob=!\"*.git*\" scripts/'")

# Execute the ripgrep command
files="$(eval "$rg_command")"

# if -d flag is passed
if [ "$1" == "-d" ]; then
	echo "Files matching the query \"$prompt\":"
	echo "$files"
fi

echo -n "/add $files" | pbcopy
