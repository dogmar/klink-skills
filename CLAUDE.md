# klink-skills

Personal agent skills. Each skill is `skills/<name>/SKILL.md` (YAML frontmatter with `name` + `description`, then Markdown body); supporting files sit beside it in the same folder.

- The frontmatter `name` must match the folder name.
- After adding, renaming, or deleting a skill, run `./install.sh` to refresh the symlinks in `~/.claude/skills` (Claude Code) and `~/.agents/skills` (Codex, Gemini CLI).
- Skills must work in all three agents: keep frontmatter `name` equal to the folder name (Gemini requires it; an `as` rename in `SKILLS.md` needs the vendored `name:` changed too).
- Use the `new-skill` skill to scaffold new ones.
- `vendor/<who>/` holds upstream skill sets as git subtrees. `SKILLS.md` is the checklist of which ones are enabled; `./install.sh` turns ticks into symlinks in `skills/`. Never hand-create vendor symlinks in `skills/` — tick them in `SKILLS.md`. `./update-vendor.sh` merges upstream changes.
