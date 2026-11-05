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
  mattpocock/       # git subtree of github.com/mattpocock/skills (edit freely; changes merge on pull)
link-skill.sh       # adopt a vendored skill: symlinks it into skills/
update-vendor.sh    # pull upstream changes into vendor/
install.sh          # symlinks skills/* into ~/.claude/skills
.claude-plugin/     # lets this repo be installed as a Claude Code plugin
```

## Install

**Local symlinks (recommended on your main machine — edits are live):**

```sh
git clone https://github.com/dogmar/klink-skills.git
cd klink-skills && ./install.sh            # -> ~/.claude/skills
./install.sh ~/.codex/skills               # or any other agent's skills dir
```

Re-run `./install.sh` after adding, renaming, or removing a skill.

**As a Claude Code plugin (handy on other machines):**

```
/plugin marketplace add dogmar/klink-skills
/plugin install klink-skills@klink-skills
```

Plugin skills are namespaced, e.g. `/klink-skills:new-skill`. The repo is private, so `gh auth login` must be set up on that machine.

## Vendored skills

`skills/` is the menu of what gets installed. A vendored skill is enabled by a relative symlink in `skills/` pointing into `vendor/`.

```sh
./link-skill.sh vendor/mattpocock/skills/engineering/code-review   # enable one
rm skills/teach && ./install.sh                                    # disable one
./update-vendor.sh                                                 # pull upstream changes
```

Edit vendored skills in place under `vendor/`; `git subtree pull` merges upstream changes with yours (resolve conflicts like any merge). To add another upstream set:

```sh
git subtree add --prefix=vendor/<who> https://github.com/<who>/<repo>.git main --squash
```

…and add a matching `git subtree pull` line to `update-vendor.sh`.

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

Plus the vendored skills linked in `skills/` (`ls -l skills`).
