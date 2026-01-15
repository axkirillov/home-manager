---
name: skills-maintainer
description: Create, update, rename, and delete opencode skill definitions while keeping structure, naming, and docs consistent.
compatibility: opencode
---

# Skills Maintainer Instructions

Use this skill when the user asks to create, update, rename, or delete an **opencode** skill (a folder containing a `SKILL.md`).

## Where opencode skills live

OpenCode discovers skills from:

- Project config: `.opencode/skill/<name>/SKILL.md`
- Global config: `~/.config/opencode/skill/<name>/SKILL.md`

In this setup, skills are maintained in the home-manager repo at:

- `~/.config/home-manager/opencode/skill/<name>/SKILL.md`

The skill directory name must exactly match the `name:` in the frontmatter.

## Process

1. Classify the requested operation
   - Determine whether the user wants to:
     - Create a new skill
     - Update an existing skill
     - Rename a skill (directory + internal `name:`)
     - Delete a skill
   - If deletion or rename is requested, confirm it is intentional.

2. Gather requirements (minimum set)
   - Skill name (required)
     - 1–64 characters.
     - Lowercase letters, numbers, hyphens only.
     - No leading/trailing hyphens.
     - No consecutive hyphens.
     - Pattern: `^[a-z0-9]+(?:-[a-z0-9]+)*$`.
   - Description (required for create/update)
     - 1–1024 characters after trimming.
     - Must be specific about when to use the skill.
   - Triggers / use cases
     - What user requests should activate this skill?
   - Constraints / safety
     - What actions are allowed/disallowed when following this skill?

3. Choose location and structure
   - Make changes in the home-manager repo at: `~/.config/home-manager/opencode/skill/<name>/SKILL.md`.
   - Even if the current working directory is a different repo, run git commands against home-manager:
     - `git -C ~/.config/home-manager status`
     - `git -C ~/.config/home-manager diff`
   - Ensure the directory name exactly matches the skill `name`.
   - Create missing directories as needed.

4. Create or update the skill content
   - YAML frontmatter must include:
     - `name: <name>`
     - `description: <specific description of when to use it>`
     - `compatibility: opencode`
   - Start with an H1 title: `# <Title> Instructions`.
   - Provide a checklist-style workflow the assistant should follow.
   - Include at least one reusable template section relevant to the skill.
   - Include a “Common Issues” section.

5. Rename a skill (if requested)
   - Treat rename as a coordinated change:
     - Move/rename the directory to the new `<name>`.
     - Update the `name:` field in the `SKILL.md` frontmatter.
     - Search for and update references to the old skill name.

6. Delete a skill (if requested)
   - Confirm the exact target skill.
   - Search for references to the skill name before deletion.
   - Delete the entire `~/.config/home-manager/opencode/skill/<name>/` directory.

7. Commit changes
   - Create a git commit in `~/.config/home-manager` for any skill changes.
   - Keep commits scoped (one logical change per commit).
   - Prefer commit messages like `feat(skills): ...` / `fix(skills): ...`.

## Templates

### Skill Template

```md
---
name: <name>
description: <specific description of when to use it>
compatibility: opencode
---

# <Title> Instructions

Use this skill when the user requests <topic>.

## Checklist

1. <step>
2. <step>
3. <step>

## Templates

<insert patterns/snippets/checklists here>

## Common Issues

- <issue>: <resolution>
- <issue>: <resolution>
```

### Skill Deletion Checklist

- [ ] Confirm exact skill name.
- [ ] Search for references (prefer `rg`).
- [ ] Update/remove references.
- [ ] Delete the entire `~/.config/home-manager/opencode/skill/<name>/` directory.

## Common Issues

- Skill name doesn’t match directory name: ensure `~/.config/home-manager/opencode/skill/<name>/SKILL.md` uses the same `name` as the folder.
- Missing `compatibility: opencode`: opencode won’t treat the skill as compatible.
- Rename performed but references remain: search and update any docs/config that mention the old skill name.
- Deleted skill still appears: restart/reload opencode if it caches skills.
