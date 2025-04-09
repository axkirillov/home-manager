#!/bin/bash

# Generate a commit message using staged files and gemini model

# Check if API key is provided as environment variable
if [ -z "$GEMINI_API_KEY" ]; then
	echo "Error: GEMINI_API_KEY environment variable is not set"
	echo "Usage: GEMINI_API_KEY=your_api_key ./commit-msg.sh"
	exit 1
fi

# Check if any files are staged
if [ -z "$(git diff --cached --name-only)" ]; then
	echo "No staged files found. Stage files with 'git add' first."
	exit 1
fi

# Create temporary files for concatenated content and diff
TMP_FILES_CONTENT=$(mktemp)
TMP_DIFF=$(mktemp)

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only)

# Concatenate all staged files content
echo "Staged files:" >"$TMP_FILES_CONTENT"
for file in $STAGED_FILES; do
	echo "--- $file ---" >>"$TMP_FILES_CONTENT"
	cat "$file" >>"$TMP_FILES_CONTENT"
	echo -e "\n\n" >>"$TMP_FILES_CONTENT"
done

# Get the diff of staged changes
git diff --cached >"$TMP_DIFF"

# Build prompt
PROMPT="Generate a concise and informative git commit message based on these staged changes.
Format the message using the Conventional Commits specification:
- Use one of these types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Include an optional scope in parentheses after the type (e.g. feat(auth): ...)
- The message should be in the imperative mood (e.g., 'add feature' not 'added feature').
- Do not include emoji or trailing periods.
- Keep it under 50 characters if possible.

Example formats:
- feat(ui): add new button component
- fix: resolve memory leak in worker
- refactor(api): simplify authentication logic

Here are the contents of the staged files:

$(cat "$TMP_FILES_CONTENT")

And here's the diff of the changes:

$(cat "$TMP_DIFF")"

# Properly escape the prompt for JSON using jq
ESCAPED_PROMPT=$(echo "$PROMPT" | jq -Rs .)

# Create a temporary file for the payload
PAYLOAD_FILE=$(mktemp)

# Write properly formatted JSON to the temp file
cat >"$PAYLOAD_FILE" <<EOF
{
  "contents": [
    {
      "parts": [
        {
          "text": $ESCAPED_PROMPT
        }
      ]
    }
  ],
  "generationConfig": {
    "temperature": 0.7,
    "topP": 0.95,
    "topK": 40
  }
}
EOF

# Create temp files for API response and error output
API_RESPONSE=$(mktemp)
ERROR_OUTPUT=$(mktemp)

# Make the API call
curl -s "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro-preview-03-25:generateContent?key=$GEMINI_API_KEY" \
	-H 'Content-Type: application/json' \
	-X POST \
	-d @"$PAYLOAD_FILE" >"$API_RESPONSE" 2>"$ERROR_OUTPUT"

# Check if response contains error
if grep -q "error" "$API_RESPONSE"; then
	echo "Error calling Gemini API. Check your API key and try again."
	COMMIT_MSG=""
else
	# Extract the commit message from the JSON response
	if [ -s "$API_RESPONSE" ]; then
		COMMIT_MSG=$(cat "$API_RESPONSE" | jq -r '.candidates[0].content.parts[0].text')
		# Remove ``` backticks from the commit message
		COMMIT_MSG=$(echo "$COMMIT_MSG" | sed -E 's/```|`//g')
	else
		echo "Error: Empty response from API"
		COMMIT_MSG=""
	fi
fi

# Clean up temp files
rm "$API_RESPONSE" "$ERROR_OUTPUT" "$PAYLOAD_FILE" "$TMP_FILES_CONTENT" "$TMP_DIFF"

# Output the generated commit message
echo "Generated commit message: \"$COMMIT_MSG\""

# Read user input (but don't require pressing Enter after)
read -p "Use this message for commit? [Y/n]: " -n 1 INPUT

# If user pressed Enter immediately, INPUT will be empty
if [ -z "$INPUT" ] || [ "$INPUT" = "y" ] || [ "$INPUT" = "Y" ]; then
	# Add newline if the user pressed a key (not just Enter)
	[ -n "$INPUT" ] && echo

	git commit -m "$COMMIT_MSG"
	echo "Changes committed successfully!"
else
	echo
	echo "Commit aborted. You can manually commit with: git commit -m \"your message\""
fi
