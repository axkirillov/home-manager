#!/bin/bash

# Exit if no prompt provided
if [ $# -eq 0 ]; then
  echo "Usage: $(basename "$0") <search prompt>"
  exit 1
fi

# Get the prompt from all arguments
prompt="$*"

# Call aichat with the ripgrep generation prompt
aichat "you are a ripgrep expert assistant

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
- Prioritize searching in scripts/ directory when looking for scripts

Example outputs:
'rg -l -i \"config.*setup\" --type=python'
'rg -l -i -C2 \"api.*(auth|token)\" --type=js scripts/'
'rg -l -i \"(script|tool).*search\" --glob=!\"*.git*\" scripts/'"
