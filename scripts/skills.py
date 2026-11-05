#!/usr/bin/env python3
"""Keep SKILLS.md (the vendored-skill checklist) and the symlinks in skills/ in step.

  skills.py sync   rebuild SKILLS.md from vendor/*/ — keeps your ticks and // notes,
                   adds new upstream skills unticked, drops ones upstream removed
  skills.py apply  make skills/ hold exactly one symlink per ticked skill
"""
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
CHECKLIST = REPO / "SKILLS.md"
SKILLS = REPO / "skills"
VENDOR = REPO / "vendor"
LINE = re.compile(r"^- \[([ xX])\] .*?`(vendor/[^`]+)`(?:\s*//\s*(.*))?$")
HEADER = """# Skills checklist

Vendored skills from `vendor/`. Tick `[x]` to install, untick to remove, then run `./install.sh`.
Text after `//` is your own note and survives updates. My own skills (real folders in `skills/`) are always installed.
"""


def frontmatter_description(skill_md: Path) -> str:
    lines = skill_md.read_text().splitlines()
    if not lines or lines[0].strip() != "---":
        return ""
    for i, line in enumerate(lines[1:], 1):
        if line.strip() == "---":
            break
        m = re.match(r"^description:\s*(.*)$", line)
        if m:
            value = m.group(1).strip()
            if value in (">", ">-", "|", "|-", ">+", "|+"):
                block = []
                for nxt in lines[i + 1:]:
                    if nxt.startswith((" ", "\t")) or not nxt.strip():
                        block.append(nxt.strip())
                    else:
                        break
                value = " ".join(b for b in block if b)
            return value.strip("'\"")
    return ""


def read_checklist() -> dict:
    state = {}
    if CHECKLIST.exists():
        for line in CHECKLIST.read_text().splitlines():
            m = LINE.match(line)
            if m:
                state[m.group(2)] = (m.group(1).lower() == "x", m.group(3) or "")
    return state


def sync() -> None:
    state = read_checklist()
    out = [HEADER]
    for source in sorted(p for p in VENDOR.iterdir() if p.is_dir()):
        groups = {}
        for skill_md in sorted(source.glob("skills/**/SKILL.md")):
            rel = skill_md.parent.relative_to(REPO).as_posix()
            category = skill_md.parent.parent.relative_to(source / "skills").as_posix()
            groups.setdefault(category, []).append((rel, skill_md))
        for category, items in groups.items():
            title = source.name if category == "." else f"{source.name} / {category}"
            out.append(f"## {title}\n")
            for rel, skill_md in items:
                ticked, note = state.get(rel, (False, ""))
                desc = frontmatter_description(skill_md)
                if len(desc) > 160:
                    desc = desc[:157].rstrip() + "…"
                line = f"- [{'x' if ticked else ' '}] **{skill_md.parent.name}** — {desc} `{rel}`"
                if note:
                    line += f" // {note}"
                out.append(line)
            out.append("")
    CHECKLIST.write_text("\n".join(out).rstrip() + "\n")


def apply() -> None:
    wanted = {}
    for rel, (ticked, _) in read_checklist().items():
        if not ticked:
            continue
        if not (REPO / rel / "SKILL.md").exists():
            sys.exit(f"SKILLS.md: {rel} has no SKILL.md (run ./update-vendor.sh or untick it)")
        name = Path(rel).name
        if name in wanted:
            sys.exit(f"SKILLS.md: two ticked skills are named '{name}': {wanted[name]} and {rel}")
        wanted[name] = rel
    # remove vendor links that are no longer ticked (or point somewhere else)
    for link in SKILLS.iterdir():
        if link.is_symlink() and str(link.readlink()).startswith("../vendor/"):
            target = wanted.get(link.name)
            if target is None or link.readlink().as_posix() != f"../{target}":
                link.unlink()
                print(f"unlink {link.name}")
    for name, rel in sorted(wanted.items()):
        link = SKILLS / name
        if link.is_symlink():
            continue
        if link.exists():
            sys.exit(f"SKILLS.md: '{name}' is ticked but skills/{name} is your own skill — untick one")
        link.symlink_to(f"../{rel}")
        print(f"enable {name}")


if __name__ == "__main__":
    {"sync": sync, "apply": apply}[sys.argv[1] if len(sys.argv) > 1 else ""]()
