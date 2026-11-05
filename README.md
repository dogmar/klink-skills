<img src="assets/icon.svg" width="64" height="64" alt="">

# klink-skills

My personal [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills) for Claude Code (and any other agent that reads `SKILL.md` folders).

## Layout

```
skills/
  <skill-name>/
    SKILL.md        # frontmatter (name, description) + instructions
    ...             # optional references, templates, scripts
vendor/
  mattpocock/       # git subtree of github.com/mattpocock/skills
  t3dotgg/          # git subtree of github.com/t3dotgg/tstack
SKILLS.md           # checklist: tick the vendored skills you want
install.sh          # applies SKILLS.md, then symlinks skills/* into ~/.claude/skills
update-vendor.sh    # pulls upstream changes into vendor/ and reinstalls
scripts/skills.py   # checklist sync/apply logic used by install.sh
.claude-plugin/     # lets this repo be installed as a Claude Code plugin
```

## Install

**Clone + symlinks (edits are live):**

```sh
git clone https://github.com/dogmar/klink-skills.git
cd klink-skills && ./install.sh            # -> ~/.claude/skills
./install.sh ~/.codex/skills               # or any other agent's skills dir
```

Re-run `./install.sh` after adding, renaming, or removing a skill.

**As a Claude Code plugin:**

```
/plugin marketplace add dogmar/klink-skills
/plugin install klink-skills@klink-skills
```

Plugin skills are namespaced, e.g. `/klink-skills:new-skill`.

## Vendored skills

Pick upstream skills in **[`SKILLS.md`](SKILLS.md)**: tick `[x]` to install, untick to remove, then run `./install.sh`. Ticked skills become relative symlinks in `skills/` (which keeps plugin installs working); your own skills are real folders there and are always installed. Append `` as `new-name` `` after a skill's path to install it under another name (Claude Code names skills after their folder), e.g. Matt's `code-review` is installed as `matt-review` so the built-in `/code-review` still works. Text after `//` on a line is your own note. Both survive updates.

```sh
./update-vendor.sh   # pull upstream changes; new upstream skills show up unticked in SKILLS.md
```

Vendored skills can be edited in place under `vendor/`; `git subtree pull` merges upstream changes with yours. To add another upstream set:

```sh
git subtree add --prefix=vendor/<who> https://github.com/<who>/<repo>.git main --squash
```

…add a matching `pull` line to `update-vendor.sh`, then run `./install.sh` to list its skills in `SKILLS.md`.

## Adding a skill

Ask Claude to "make a new skill for …" (the `new-skill` skill handles it), or by hand:

```sh
mkdir skills/my-skill && $EDITOR skills/my-skill/SKILL.md && ./install.sh
```

```markdown
---
name: my-skill
description: What it does. Use when <situation>, <situation>.
---

# My skill

Steps…
```

The `description` decides when the agent loads the skill — name each distinct trigger situation.

## Skills

| Skill | What it does |
| --- | --- |
| `new-skill` | Scaffolds a new skill in this repo and installs it |

Plus the vendored skills ticked in [`SKILLS.md`](SKILLS.md).

## Credits

- `vendor/mattpocock/` is [mattpocock/skills](https://github.com/mattpocock/skills), MIT licensed (see `vendor/mattpocock/LICENSE`).
- `vendor/t3dotgg/` is [t3dotgg/tstack](https://github.com/t3dotgg/tstack), MIT licensed (see `vendor/t3dotgg/LICENSE`).
