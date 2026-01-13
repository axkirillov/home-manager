---
name: skill-writer
description: Create or update Roo skill definitions and save them to the correct global (~/.roo/skills) or local (<project-root>/.roo/skills) location
---

# Skill Writer Instructions

Use this skill when the user asks to create a new skill (or modify an existing one).

## Process

1. Gather requirements
   - Scope (required)
     - Ask whether the skill should be **global** or **local** (unless the user already specified)
     - Global skills live in `~/.roo/skills/`
     - Local skills live in `<project-root>/.roo/skills/`
   - Skill name (required)
     - Must exactly match the skill directory name under the chosen skills folder
     - 1–64 characters
     - Lowercase letters, numbers, hyphens only
     - No leading/trailing hyphens
     - No consecutive hyphens
     - Pattern: `^[a-z0-9]+(?:-[a-z0-9]+)*$`
   - Description (required)
     - 1–1024 characters after trimming
     - Must be specific about when Roo should use the skill (triggers and scope)
   - Primary use cases (what user requests should trigger it)
   - Constraints (languages/libraries, environment assumptions, safety rules)
   - Output expectations (code templates, checklists, common issues)

2. Choose file name and location
   - Always write the skill to: `<skills-root>/<name>/SKILL.md`
   - If scope is **global**:
     - `<skills-root>` = `~/.roo/skills`
   - If scope is **local**:
     - `<skills-root>` = `<project-root>/.roo/skills`
   - Ensure the directory name exactly matches `name` and the file is named `SKILL.md`
   - Create missing directories as needed (e.g., create `<skills-root>/<name>/`)
   - Use YAML frontmatter exactly as:
     - `name: <name>`
     - `description: <specific, trimmed description>`

3. Write the skill content
   - Start with an H1 title: `# <Skill Title> Instructions`
   - Provide a step-by-step checklist for how the assistant should respond
   - Include at least one reusable code/template section if applicable
   - Include a “Common Issues” section with practical troubleshooting notes

4. Keep it practical
   - Prefer concrete steps over narrative
   - Provide defaults when the user does not specify details
   - If requirements are unclear, ask targeted clarification questions

## Skill Template

---
name: <name>
description: <specific description of when to use it>
---

Scope rules:
- Ask whether the user wants this skill to be **global** or **local** (unless explicitly specified)
- Global path: `~/.roo/skills/<name>/SKILL.md`
- Local path: `<project-root>/.roo/skills/<name>/SKILL.md`

Name rules:
- Must exactly match the skill directory name under the chosen skills folder (`~/.roo/skills` for global, `<project-root>/.roo/skills` for local)
- 1–64 chars, lowercase letters/numbers/hyphens only, no leading/trailing hyphens, no consecutive hyphens

Description rules:
- Required, 1–1024 chars after trimming
- Must clearly state when Roo should use this skill (specific triggers and scope)

# <Title> Instructions

When the user requests <topic>:

1. <step>
2. <step>
3. <step>

## Code Template

<insert patterns/snippets here>

## Common Issues

- <issue>: <resolution>
- <issue>: <resolution>
