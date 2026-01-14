---
name: mode-maintainer
description: Create, update, and audit Roo Code custom modes and mode rules so configuration, tool permissions, file restrictions, and docs stay consistent.
---

Scope rules:
- This skill is **global**.
- Installed at: `<home-directory>/.roo/skills/mode-maintainer/SKILL.md`

Name rules:
- Must exactly match the skill directory name under the chosen skills folder.
- 1–64 chars, lowercase letters/numbers/hyphens only, no leading/trailing hyphens, no consecutive hyphens.

Description rules:
- Required, 1–1024 chars after trimming.
- Must clearly state when Roo should use this skill (specific triggers and scope).

# Mode Maintainer Instructions

Use this skill when the user asks to create, update, or audit Roo Code **custom modes**, including:
- Creating a new custom mode (global or project-specific)
- Modifying an existing mode’s YAML/JSON definition
- Editing/creating `.roomodes` or `settings/custom_modes.yaml`
- Setting up mode-specific instruction files under `.roo/rules-{slug}/`
- Restricting tool groups or edit permissions via `groups` + `fileRegex`
- Overriding a default mode by creating a custom mode with the same `slug`

## Workflow

1. Clarify scope and target
   - Determine whether the requested mode is **global** or **project-specific**.
   - Confirm the intended `slug` and `name`.
   - If updating: locate the existing mode definition and capture current behavior.

2. Choose the storage location (per Roo Code custom modes docs)
   - **Global modes:** `~/Library/Application Support/Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/custom_modes.yaml`
   - **Project modes:** `.roomodes` (YAML preferred; JSON supported) in the workspace root.
   - If the user doesn’t specify:
     - Default to **project-specific** when the request is clearly tied to one repo/workspace.
     - Default to **global** when they want the mode available across projects.

3. Build/update the mode definition with correct semantics
   - Ensure each field is used appropriately:
     - `slug`: unique internal identifier; must match `/^[a-zA-Z0-9-]+$/`.
     - `name`: display name shown in the UI.
     - `description`: short, user-friendly UI summary.
     - `roleDefinition`: detailed role/expertise/personality; placed at the beginning of the system prompt.
     - `whenToUse` (optional): guidance for orchestration / automated mode selection.
     - `customInstructions` (optional): extra behavioral rules appended near the end of the system prompt.
     - `groups`: allowed tool groups and optional edit file restrictions.
   - Prefer YAML unless the user explicitly requests JSON.

4. Configure `groups` correctly (tools + file restrictions)
   - Valid tool groups: `read`, `edit`, `browser`, `command`, `mcp`.
   - Unrestricted group usage example: `- edit`
   - Restricted edit access must use the **tuple** structure:
     - YAML tuple example:

       ```yaml
       groups:
         - read
         - - edit
           - fileRegex: \.(md|mdx)$
             description: Markdown files only
         - browser
       ```

     - JSON tuple example:

       ```json
       {
         "groups": [
           "read",
           ["edit", { "fileRegex": "\\.(md|mdx)$", "description": "Markdown files only" }],
           "browser"
         ]
       }
       ```

   - If the user requests safety, default to restricted `edit` with a narrow `fileRegex`.

5. Add mode-specific instructions via files/directories (recommended)
   - Preferred: **directory-based rules**:
     - Project modes: `<workspace>/.roo/rules-{slug}/`
     - Global modes: `<home-directory>/.roo/rules-{slug}/`
   - Files in `.roo/rules-{slug}/` are loaded recursively and appended in **alphabetical order**.
   - Fallback: `.roorules-{slug}` (used only if the rules directory does not exist or is empty).
   - Legacy fallback: `.clinerules-{slug}` (avoid for new setups).

6. Check precedence and overrides
   - Mode configuration precedence:
     1. Project-level `.roomodes`
     2. Global `~/Library/Application Support/Code/User/globalStorage/rooveterinaryinc.roo-cline/settings/custom_modes.yaml`
     3. Default built-in modes
   - If the same `slug` exists in both `.roomodes` and global settings, the `.roomodes` version **completely overrides** the global version (all properties).
   - Rules precedence:
     - `.roo/rules-{slug}/` takes precedence over `.roorules-{slug}`.

7. Validate and summarize changes
   - Validate YAML indentation (spaces; no tabs) and top-level keys (e.g., `customModes:`).
   - Summarize:
     - What files were changed/added
     - What behavior changed vs stayed the same
     - How to verify (open the Modes UI, select the mode, confirm permissions and behavior)

## Templates

### Custom Mode (YAML skeleton)

```yaml
customModes:
  - slug: <slug>
    name: <UI display name>
    description: <short UI summary>
    roleDefinition: >-
      You are a <role> who specializes in:
      - <capability>
      - <capability>
    whenToUse: <optional orchestration guidance>
    customInstructions: |-
      <bullet rules>
    groups:
      - read
      - - edit
        - fileRegex: <regex>
          description: <what can be edited>
      - browser
```

### Rules directory layout

```
<workspace>/.roo/rules-<slug>/
  01-overview.md
  02-style-guide.md
  03-safety.txt
```

### Mode Audit Checklist

- [ ] `slug` is unique and matches `/^[a-zA-Z0-9-]+$/`.
- [ ] `description` is short and user-facing (UI summary).
- [ ] `roleDefinition` is detailed and defines expertise/identity.
- [ ] `whenToUse` is present if the mode should be auto-selected by orchestration.
- [ ] `groups` matches desired tool permissions.
- [ ] `edit` restrictions use the tuple form with `fileRegex` when needed.
- [ ] Mode-specific instructions are in `.roo/rules-{slug}/` (preferred) and load order is intentional.
- [ ] Precedence is understood (project `.roomodes` overrides global settings for same slug).

## Common Issues

- Mode appears but behaves “wrong” in a repo: a project `.roomodes` entry with the same `slug` overrides the global one entirely.
- Rules don’t load: ensure `.roo/rules-{slug}/` exists and contains files; otherwise only `.roorules-{slug}` is used.
- `.roorules-{slug}` is ignored: directory-based rules take precedence when present.
- YAML parses but Roo doesn’t show the mode: verify top-level `customModes:` and indentation.
- Regex works in YAML but fails in JSON: JSON requires double escaping (e.g., `\\.` instead of `\.`).
- Confusing summaries: `description` is for the UI, `whenToUse` is for orchestration, and `roleDefinition` is the main identity prompt.
