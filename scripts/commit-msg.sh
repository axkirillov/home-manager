#!/bin/bash

# Generate a commit message using staged files and gemini model

# Check if API key is provided as environment variable
if [ -z "$OPENAI_API_KEY" ]; then
	echo "Error: OPENAI_API_KEY environment variable is not set"
	echo "Usage: OPENAI_API_KEY=your_api_key ./commit-msg.sh"
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
# Define the system prompt (instructions)
SYSTEM_PROMPT="You are an expert programmer tasked with writing a concise and informative git commit message.
Analyze the provided staged file contents and the corresponding diff, then generate a commit message adhering strictly to the Conventional Commits specification.

**Format Requirements:**
- Structure: \`<type>[optional scope]: <description>\`
  - Example: \`feat(api): add user authentication endpoint\`
- Allowed Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert
- Subject (\`<description>\`):
  - Use the imperative, present tense (e.g., 'add', 'fix', 'change' not 'added', 'fixed', 'changed').
  - Be concise, ideally under 50 characters.
  - Do not capitalize the first letter.
  - No trailing period.
- Body (Optional):
  - If necessary, add a blank line after the subject and provide a brief explanation of the 'why' behind the change.
  - Keep body lines wrapped at 72 characters.
- Footer (Optional):
  - Use for referencing issues (e.g., \`Closes #123\`) or breaking changes (\`BREAKING CHANGE: ...\`).

Generate *only* the commit message text, without any additional explanation or markdown formatting like backticks."

# Define the user prompt (data)
USER_PROMPT="**Staged File Contents:**
\`\`\`
$(cat "$TMP_FILES_CONTENT")
\`\`\`

**Diff of Changes:**
\`\`\`diff
$(cat "$TMP_DIFF")
\`\`\`"

# Properly escape the prompt for JSON using jq
# Properly escape the prompts for JSON using jq
ESCAPED_SYSTEM_PROMPT=$(echo "$SYSTEM_PROMPT" | jq -Rs .)
ESCAPED_USER_PROMPT=$(echo "$USER_PROMPT" | jq -Rs .)

# Create a temporary file for the payload
PAYLOAD_FILE=$(mktemp)

# Write properly formatted JSON to the temp file
# Write properly formatted JSON payload for OpenAI API
cat >"$PAYLOAD_FILE" <<EOF
{
  "model": "gpt-4o",
  "messages": [
    {
      "role": "system",
      "content": $ESCAPED_SYSTEM_PROMPT
    },
    {
      "role": "user",
      "content": $ESCAPED_USER_PROMPT
    }
  ],
  "temperature": 0.7,
  "max_tokens": 150,
  "top_p": 1.0,
  "frequency_penalty": 0.0,
  "presence_penalty": 0.0
}
EOF

# Create temp files for API response and error output
API_RESPONSE=$(mktemp)
ERROR_OUTPUT=$(mktemp)

# Make the API call
curl -s "https://api.openai.com/v1/chat/completions" \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer $OPENAI_API_KEY" \
	-d @"$PAYLOAD_FILE" >"$API_RESPONSE" 2>"$ERROR_OUTPUT"

# Check if response contains error
# Check if response contains error (OpenAI format)
if jq -e '.error' "$API_RESPONSE" > /dev/null; then
	echo "Error calling OpenAI API:"
	cat "$API_RESPONSE" # Print the full error response
	COMMIT_MSG=""
else
	# Extract the commit message from the JSON response
	if [ -s "$API_RESPONSE" ]; then
		COMMIT_MSG=$(cat "$API_RESPONSE" | jq -r '.choices[0].message.content')
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
