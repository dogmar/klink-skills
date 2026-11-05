---
name: new-skill
description: Scaffold a new personal skill in the klink-skills repo. Use when the user wants to create, add, or capture a new skill, or turn a workflow they just did into a reusable skill.
---

# New skill

Create the skill inside the klink-skills repo (find it via the `~/.claude/skills/new-skill` symlink: `readlink ~/.claude/skills/new-skill` → `<repo>/skills/new-skill`).

1. **Pin down the trigger.** Get from the user (or the conversation) what the skill does and the distinct situations that should fire it. Done when you can write a one-sentence description that names each situation.
2. **Name it.** Short kebab-case, verb-led where possible (`review-pr`, `draft-email`). Done when `<repo>/skills/<name>/` does not already exist.
3. **Write `<repo>/skills/<name>/SKILL.md`:**
   ```markdown
   ---
   name: <name>
   description: <what it is>. Use when <trigger 1>, <trigger 2>.
   ---

   # <Title>

   <Ordered steps, each ending on a checkable "done when" condition.>
   ```
   Keep the body to what every run needs. Move long reference material, templates, or scripts into sibling files in the same folder and link them from the step that needs them.
4. **Install.** Run `<repo>/install.sh` so the new skill is symlinked into `~/.claude/skills` and `~/.agents/skills`. Done when `ls ~/.claude/skills/<name> ~/.agents/skills/<name>` resolves.
5. **Commit.** `git -C <repo> add skills/<name> && git -C <repo> commit -m "Add <name> skill"`. Push only if the user asks.
