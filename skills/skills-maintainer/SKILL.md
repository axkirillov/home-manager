---
name: skills-maintainer
description: Create, update, rename, and delete Roo skill definitions (global or local) while keeping structure, naming, and docs consistent.
---

# Skills Maintainer Instructions

Use this skill when the user asks to **create**, **update**, **rename**, or **delete** a Roo skill (i.e., a folder containing a `SKILL.md`).

## Process

1. Classify the requested operation
   - Determine whether the user wants to:
     - **Create** a new skill
     - **Update** an existing skill
     - **Rename** a skill (directory + internal `name:`)
     - **Delete** a skill
   - If deletion or rename is requested, confirm it is intentional and identify what should happen to the old name (remove entirely vs keep a compatibility stub).

2. Gather requirements (minimum set)
   - **Scope** (required unless user already specified)
     - Ask whether the skill should be **global** or **local**.
     - Global skills live in `~/.roo/skills/`.
     - Local skills live in `<project-root>/.roo/skills/`.
   - **Skill name** (required)
     - Must exactly match the skill directory name under the chosen skills folder.
     - 1–64 characters.
     - Lowercase letters, numbers, hyphens only.
     - No leading/trailing hyphens.
     - No consecutive hyphens.
     - Pattern: `^[a-z0-9]+(?:-[a-z0-9]+)*$`.
   - **Description** (required for create/update)
     - 1–1024 characters after trimming.
     - Must be specific about when Roo should use the skill (triggers + scope).
   - **Primary use cases** (what user requests should trigger it).
   - **Constraints** (safety rules, languages/libraries, environment assumptions).
   - **Output expectations** (templates, checklists, common issues).

3. Choose file name and location
   - Always store the skill at: `<skills-root>/<name>/SKILL.md`.
   - If scope is **global**:
     - `<skills-root>` = `~/.roo/skills`.
   - If scope is **local**:
     - `<skills-root>` = `<project-root>/.roo/skills`.
   - Ensure the directory name exactly matches `name` and the file is named `SKILL.md`.
   - Create missing directories as needed (e.g., create `<skills-root>/<name>/`).

4. Create or update the skill content
   - Use YAML frontmatter **exactly** as:
     - `name: <name>`
     - `description: <specific, trimmed description>`
   - Start with an H1 title: `# <Skill Title> Instructions`.
   - Provide a step-by-step checklist for how the assistant should respond.
   - Include at least one reusable template section (snippets/checklists) relevant to the skill.
   - Include a “Common Issues” section with practical troubleshooting notes.

5. Rename a skill (if requested)
   - Treat rename as a coordinated change:
     - Move/rename the directory to the new `<name>`.
     - Update the `name:` field in the `SKILL.md` frontmatter to match.
     - Search for and update references to the old skill name (docs, indexes, automation).
   - If the user wants a compatibility alias:
     - Keep a stub directory under the old name with a minimal `SKILL.md` that points to the new skill.
     - Otherwise, delete the old directory after successful move.

6. Delete a skill (if requested)
   - Confirm the exact target skill directory and scope.
   - Perform a reference check (search the repo/config for the skill name) before deletion.
   - Delete the entire `<skills-root>/<name>/` directory (not just `SKILL.md`).
   - If the user wants a reversible change, rename it to a backup (e.g., `<name>.bak`) instead of permanent deletion.

## Templates

### Skill Template

```md
---
name: <name>
description: <specific description of when to use it>
---

# <Title> Instructions

When the user requests <topic>:

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

- [ ] Confirm scope (global vs local) and exact skill name.
- [ ] Search for references to the skill name.
- [ ] Remove or update references.
- [ ] Delete the entire skill directory (or rename to `.bak` if rollback desired).

## Common Issues

- Skill name doesn’t match directory name: ensure `<skills-root>/<name>/SKILL.md` uses the same `name` as the folder.
- Wrong scope: global skills must be under `~/.roo/skills/`; project-local skills must be under `<project-root>/.roo/skills/`.
- YAML frontmatter formatting errors: ensure the frontmatter is the first lines in the file and uses the exact keys `name:` and `description:`.
- Rename performed but references remain: search and update any docs/config that mention the old skill name.
- Deleted skill still appears: confirm you removed the directory and reloaded any tooling that caches skills.

