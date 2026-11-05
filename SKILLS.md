# Skills checklist

Vendored skills from `vendor/`. Tick `[x]` to install, untick to remove, then run `./install.sh`.
Append `` as `new-name` `` after the path to install a skill under a different name (Claude Code names a skill after its folder).
Text after `//` is your own note. Both survive updates. My own skills (real folders in `skills/`) are always installed.

## mattpocock / engineering

- [x] **ask-matt** — Ask which skill or flow fits your situation. A router over the skills in this repo. `vendor/mattpocock/skills/engineering/ask-matt`
- [x] **code-review** — Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes: Standards (does the code follow this repo's documented coding sta… `vendor/mattpocock/skills/engineering/code-review` as `pocock-review` // Renamed so Claude Code's built-in /code-review stays available
- [x] **codebase-design** — Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a… `vendor/mattpocock/skills/engineering/codebase-design`
- [x] **diagnosing-bugs** — Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. `vendor/mattpocock/skills/engineering/diagnosing-bugs`
- [x] **domain-modeling** — Build and sharpen a project's domain model. Use when discussing codebase terminology, writing or editing a GLOSSARY.md, or recording or editing an ADR. `vendor/mattpocock/skills/engineering/domain-modeling`
- [x] **grill-with-docs** — A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. `vendor/mattpocock/skills/engineering/grill-with-docs`
- [x] **implement** — Implement a piece of work based on a spec or set of tickets. `vendor/mattpocock/skills/engineering/implement`
- [x] **implement-spec** — Implement the result of /to-spec and /to-tickets in code. `vendor/mattpocock/skills/engineering/implement-spec`
- [x] **improve-codebase-architecture** — Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. `vendor/mattpocock/skills/engineering/improve-codebase-architecture`
- [x] **pr** — Use when writing a PR body. `vendor/mattpocock/skills/engineering/pr`
- [x] **prototype** — Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what… `vendor/mattpocock/skills/engineering/prototype`
- [x] **research** — Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched… `vendor/mattpocock/skills/engineering/research`
- [x] **retro** — Conduct a retrospective on a coding session. `vendor/mattpocock/skills/engineering/retro`
- [x] **setup-matt-pocock-skills** — Configure this repo for the engineering skills: set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the ot… `vendor/mattpocock/skills/engineering/setup-matt-pocock-skills`
- [x] **tdd** — Test-driven development. Use when the user wants to build features or fix bugs test-first, mentions "red-green-refactor", or wants integration tests. `vendor/mattpocock/skills/engineering/tdd`
- [x] **to-spec** — Turn the current conversation into a spec and publish it to the project issue tracker: no interview, just synthesis of what you've already discussed. `vendor/mattpocock/skills/engineering/to-spec`
- [x] **to-tickets** — Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker (… `vendor/mattpocock/skills/engineering/to-tickets`
- [x] **triage** — Move issues and external PRs through a state machine of triage roles, categorise, verify, grill if needed, and write agent-ready briefs. `vendor/mattpocock/skills/engineering/triage`
- [x] **wayfinder** — Plan a huge chunk of work (more than one agent session can hold) as a shared map of decision tickets on your issue tracker, and resolve them one at a time un… `vendor/mattpocock/skills/engineering/wayfinder`
- [x] **wizard** — Generate an interactive bash wizard that walks a human through steps only they can perform. Use when provisioning infrastructure, setting up credentials or C… `vendor/mattpocock/skills/engineering/wizard`

## mattpocock / in-progress

- [ ] **chief-of-staff** — Pursue a long-running goal in a single session by co-ordinating subagents. `vendor/mattpocock/skills/in-progress/chief-of-staff`
- [ ] **claude-handoff** — Hand the current conversation off to a fresh background agent that picks up the work immediately. `vendor/mattpocock/skills/in-progress/claude-handoff`
- [ ] **loop-me** — Grill me about specs for the workflows I want to build, within this workspace. `vendor/mattpocock/skills/in-progress/loop-me`
- [ ] **setup-ts-deep-modules** — Wire dependency-cruiser into a TypeScript repo so each package is a deep module, with implementation hidden in subfolders and reachable only through its entr… `vendor/mattpocock/skills/in-progress/setup-ts-deep-modules`
- [ ] **software-factory** — Shared language for designing a software factory: the tasks it runs and the services it plugs into. `vendor/mattpocock/skills/in-progress/software-factory`
- [ ] **writing-beats** — Writing, exploit; assemble raw material into a journey of beats, grounding each term before a beat leans on it. `vendor/mattpocock/skills/in-progress/writing-beats`
- [ ] **writing-fragments** — Writing, explore: mine raw fragments, no structure yet. `vendor/mattpocock/skills/in-progress/writing-fragments`
- [ ] **writing-shape** — Writing, exploit: shape raw material into an article, paragraph by paragraph. `vendor/mattpocock/skills/in-progress/writing-shape`

## mattpocock / misc

- [ ] **git-guardrails-claude-code** — Set up Claude Code hooks to block dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent des… `vendor/mattpocock/skills/misc/git-guardrails-claude-code`
- [ ] **migrate-to-shoehorn** — Migrate test files from `as` type assertions to @total-typescript/shoehorn. Use when user mentions shoehorn, wants to replace `as` in tests, or needs partial… `vendor/mattpocock/skills/misc/migrate-to-shoehorn`
- [ ] **scaffold-exercises** — Create exercise directory structures with sections, problems, solutions, and explainers that pass linting. Use when user wants to scaffold exercises, create… `vendor/mattpocock/skills/misc/scaffold-exercises`
- [ ] **setup-pre-commit** — Set up Husky pre-commit hooks with lint-staged (Prettier), type checking, and tests in the current repo. Use when user wants to add pre-commit hooks, set up… `vendor/mattpocock/skills/misc/setup-pre-commit`

## mattpocock / productivity

- [x] **grill-me** — A relentless interview to sharpen a plan or design. `vendor/mattpocock/skills/productivity/grill-me`
- [x] **grilling** — Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases. `vendor/mattpocock/skills/productivity/grilling`
- [x] **handoff** — Compact the current conversation into a handoff document for another agent to pick up. `vendor/mattpocock/skills/productivity/handoff`
- [x] **teach** — Teach the user a new skill or concept, within this workspace. `vendor/mattpocock/skills/productivity/teach`
- [x] **to-questionnaire** — Turn a decision you can't fully answer into a questionnaire for someone else to fill in. `vendor/mattpocock/skills/productivity/to-questionnaire`
- [x] **wait-what** — Stop. That last message did not land: re-pitch it. `vendor/mattpocock/skills/productivity/wait-what`
- [x] **writing-for-agents** — Writing documents for agents. Use when creating or editing skills, or modifying AGENTS.md or CLAUDE.md. `vendor/mattpocock/skills/productivity/writing-for-agents`

## t3dotgg

- [x] **babysit-pr** — Monitor a pull request through review and CI. Use when the user asks to monitor, watch, or babysit a PR. `vendor/t3dotgg/skills/babysit-pr`
- [x] **council** — Trigger this if the user says 'council'. `vendor/t3dotgg/skills/council` // Asks three models from three different AI providers to review your work at once
- [x] **file-pr** — File a concise pull request. Use when the user asks to file, open, or create a PR. `vendor/t3dotgg/skills/file-pr`
- [ ] **full-send** — Trigger this if the user says 'full send'. `vendor/t3dotgg/skills/full-send` // Hands-off: the agent finishes the work all the way to a merged PR
- [x] **full-stop** — Trigger this if the user says 'full stop', even as a closing "Full stop." that reads like emphasis. `vendor/t3dotgg/skills/full-stop` // Same as full-send, but stops at a PR that's ready to merge (reads full-send's file)
- [x] **leaving-pr-comments** — Use whenever leaving comments on GitHub. `vendor/t3dotgg/skills/leaving-pr-comments` // Labels every GitHub comment the agent leaves as written by the agent for you
- [x] **modernize** — For getting old prs up to date. Use when asked to rebase a pr or "modernize". `vendor/t3dotgg/skills/modernize`
- [x] **sol-loop** — Use when the user says "sol loop". `vendor/t3dotgg/skills/sol-loop` // Has OpenAI's GPT Sol review your changes in a loop, 3 rounds by default
- [x] **takeover** — Take over existing work. Use when the user asks to take over a PR, branch, or agent thread, or requests a takeover. `vendor/t3dotgg/skills/takeover`
