# klink-skills

Personal agent skills. Each skill is `skills/<name>/SKILL.md` (YAML frontmatter with `name` + `description`, then Markdown body); supporting files sit beside it in the same folder.

- The frontmatter `name` must match the folder name.
- After adding, renaming, or deleting a skill, run `./install.sh` to refresh the symlinks in `~/.claude/skills`.
- Use the `new-skill` skill to scaffold new ones.
- `vendor/<who>/` holds upstream skill sets as git subtrees; a symlink in `skills/` enables one (`./link-skill.sh <path>`). Edit vendored skills in place; `./update-vendor.sh` merges upstream changes.
