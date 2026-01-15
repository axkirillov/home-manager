---
name: pr-comments
description: Pull and summarize issue, review, and inline comments from the GitHub PR associated with the current git branch using the GitHub CLI.
compatibility: opencode
---

# PR Comments Instructions

Use this skill when the user asks to **pull / show / summarize comments** from the **pull request for the current git branch**.

## Checklist

1. Confirm prerequisites
   - Ensure we are in a git repository.
   - Ensure GitHub CLI is available and authenticated.
   - If running `gh` commands requires permission, ask before executing.

2. Resolve the PR for the current branch
   - Prefer: `gh pr view --json number,url,title,headRefName,baseRefName`
   - If `gh pr view` fails (no PR for branch), try:
     - `git branch --show-current` to get branch name
     - `gh pr list --head <branch> --json number,url,title --limit 5`
   - If still not found, report: “No open PR found for the current branch.”

3. Fetch all comment types (read-only)
   - Fetch **issue-style PR conversation comments**:
     - `gh api repos/{owner}/{repo}/issues/{pr_number}/comments --paginate`
   - Fetch **code review inline comments**:
     - `gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --paginate`
   - Fetch **review summaries** (approvals / changes requested / review bodies):
     - `gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --paginate`

4. Normalize + present results
   - De-duplicate where necessary (reviews vs review comments are separate).
   - Present a grouped summary:
     - PR: title + URL
     - Counts by type (conversation / reviews / inline)
     - For each item: author, created_at, and short excerpt
   - If the user wants “raw output”, provide JSON (or a trimmed view) instead of summarizing.

5. Safety / scope
   - This skill is **read-only**. Do not post, edit, or delete comments.
   - Do not include secrets from the repo or from private comments in logs beyond what the user requested.

## Templates

### Minimal command sequence (most common)

```bash
# 1) Resolve PR for current branch
gh pr view --json number,url,title

# 2) Fetch comment data (replace OWNER/REPO and PR_NUMBER if needed)
OWNER_REPO="$(gh repo view --json nameWithOwner -q .nameWithOwner)"
PR_NUMBER="$(gh pr view --json number -q .number)"

gh api "repos/$OWNER_REPO/issues/$PR_NUMBER/comments" --paginate
gh api "repos/$OWNER_REPO/pulls/$PR_NUMBER/comments" --paginate
gh api "repos/$OWNER_REPO/pulls/$PR_NUMBER/reviews" --paginate
```

### Suggested output format (human-friendly)

```md
## PR Comments

**PR:** <title> (<url>)

### Summary
- Conversation comments: <n>
- Reviews: <n>
- Inline review comments: <n>

### Conversation comments
- <yyyy-mm-dd> @<author>: <first line / excerpt>

### Reviews
- <yyyy-mm-dd> @<author> [APPROVED|CHANGES_REQUESTED|COMMENTED]: <excerpt>

### Inline review comments
- <yyyy-mm-dd> @<author> <path>:<line> — <excerpt>
```

## Common Issues

- `gh pr view` says no PR found: the current branch may not have an open PR (or the repo/remote is different). Fall back to `gh pr list --head <branch>`.
- `gh api` returns 404: usually wrong `{owner}/{repo}` or PR number; use `gh repo view --json nameWithOwner` and `gh pr view --json number` to verify.
- Missing some “comments”: GitHub has multiple comment types. Use all three endpoints (issue comments, review comments, reviews) to capture them.
- Authentication errors: run `gh auth status` and have the user authenticate if needed.