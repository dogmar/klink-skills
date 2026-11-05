<img src="assets/icon.svg" width="64" height="64" alt="">

# klink-skills

My personal [Agent Skills](https://docs.claude.com/en/docs/claude-code/skills) for Claude Code (and any other agent that reads `SKILL.md` folders).

## Layout

```
skills/
  <skill-name>/
    SKILL.md        # frontmatter (name, description) + instructions
    ...             # optional references, templates, scripts
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
