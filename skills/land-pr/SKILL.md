---
name: land-pr
description: Drive a pull request until it auto-merges, fixing CI and conflicts and reporting anything only a human can clear. Use when the user asks to land a PR, auto-merge it, or watch it until it merges.
---

# Land PR

Load the `babysit-pr` skill and follow it for waiting, review bots, rate limits, and fixing CI. This skill changes its finish line from _ready_ to **merged**, and adds the rules below. Where the two disagree, this skill wins.

## Guardrails

Approval and merge policy belong to humans. Your lane is the code on the PR branch, one `gh pr merge --auto` call at the start, and the message refresh below. Hard rules, with no exceptions:

- Never approve the PR, from any account or token.
- Never merge with `--admin` or otherwise bypass branch protection.
- Never dismiss a review or resolve a human's review thread.
- Never change repository or branch-protection settings.
- Never weaken CI to get green: no skipped or deleted tests, no `continue-on-error`, no edits to which checks are required.
- Turn auto-merge on in step 1 and, after that, only in a message refresh. Once auto-merge is off for any other reason, leave it off: that is a blocker.

**Message refresh.** GitHub fixes a squash merge's commit message when auto-merge is turned on, so a later edit to the PR's title or body never reaches the commit. When you have edited them and auto-merge is on, turn it off and straight back on with the same method: `gh pr merge <pr> --disable-auto`, then `gh pr merge <pr> --auto --<method>`. Do this only while auto-merge is on, and only to carry the edited title and body into the commit.

## 1. Start

1. Read the PR: `gh pr view <pr> --json url,state,isDraft,reviewDecision,autoMergeRequest,mergeStateStatus,headRefOid,baseRefName,headRepositoryOwner,maintainerCanModify`.
2. If it is a draft, run `gh pr ready <pr>`.
3. If auto-merge is off, turn it on with `gh pr merge <pr> --auto --<method>`. Pick the method: the only one the repo allows (`gh api repos/<owner>/<repo> --jq '{allow_auto_merge,allow_squash_merge,allow_merge_commit,allow_rebase_merge}'`); else the one recent merged PRs used; else squash. If `allow_auto_merge` is false, that is a blocker.
4. Collect the blockers (see [Blockers](#blockers)) and send the first report.
5. Start the 8-hour report timer (see [Reporting](#reporting)).

Done when auto-merge is on or reported as a blocker, the first report is sent, and the timer exists.

## 2. Loop until merged or closed

Each wake: handle what changed, re-check blockers, report if the blocker set changed, then wait again. Blockers never end the loop. Keep fixing what you can while humans clear theirs.

- **CI failure:** fix it. Rerun an infrastructure flake once. If the same check also fails on the base branch, report it as a blocker instead of fixing it here.
- **Conflict (DIRTY) or BEHIND:** with squash merges, merge the base branch into the PR branch. Otherwise rebase and push with `--force-with-lease` per `modernize`. A conflict that turns on a product decision is a blocker.
- **Human review feedback:** fix what they asked for, reply on their comments, leave their threads open, and re-request their review with `gh pr edit <pr> --add-reviewer <login>`.
- **Merge queue drops the PR:** fix the failure like any CI failure. Rejoining the queue needs auto-merge back on, which is a blocker for a human.
- **After every push:** re-read `reviewDecision` and `autoMergeRequest`. A push can dismiss an approval as stale or turn auto-merge off; both change the blocker set.
- **After you edit the PR's title or body:** if auto-merge is on, run the [message refresh](#guardrails) so the commit carries the edit.

Wait with one watcher, as `babysit-pr` describes:

- **T3 Code:** `watch_pull_request`. Reporting a blocker is not a hand-off: stay watching.
- **Elsewhere:** `babysit-pr`'s `scripts/pr-wait <pr> --until green`. Once checks are green and the PR has not merged, switch to `--until any-change`. Exit 0 on merge ends the loop; exit 1 means act.

Done when the PR state is MERGED or CLOSED.

## 3. Finish

Send the final report (with notification), unwatch, and delete the report timer. Leave the local branch and worktree alone. A closed PR is reported as closed and left closed.

Done when the final report is sent and no watcher or timer remains.

## Blockers

Anything that stops auto-merge and needs a human:

- `reviewDecision` is `REVIEW_REQUIRED` or `CHANGES_REQUESTED`, including an approval dismissed after your push, and pending CODEOWNERS or required reviewers.
- Auto-merge turned off after step 1, or the repo disallows it.
- You cannot push to the branch (a fork without `maintainerCanModify`, or a rejected push).
- A required check never reports, or also fails on the base branch.
- A conflict that needs a product decision.

## Reporting

Send a report when the blocker set changes, every 8 hours, and at the finish. Write it in the thread as rendered Markdown (not inside a code block), following this template:

```markdown
### [#123 PR title](<pr url>)

- ✋ **Review:** [changes requested](<review url>) by @reviewer · waiting 3h
- 🔧 **CI:** fixing [test (ubuntu)](<check run url>)
- ✅ **Auto-merge:** on (squash)

**Fixed:** [Fix flaky date test](<commit url>)
```

- One line per status, always CI, Review, and Auto-merge, plus a line per other blocker. Each opens with ✋ (needs a human: a blocker), 🔧 (you are fixing it), or ✅ (fine), sorted in that order.
- Every URL becomes a link whose text is plain words: no bare URLs, no code spans inside links, at most one link per line. People are plain @login text, not links.
- **Fixed:** lists what you changed since the last report as linked commit subjects, comma-separated; drop the line when nothing changed.
- The finish report heads with `### ✅ Merged [#123 PR title](<pr url>)` or `### Closed …`.

Where a `PushNotification` tool exists, also send one plain-text line (under 200 characters; notifications do not render Markdown) leading with what the user would act on, e.g. `land-pr #123: needs approval (waiting 2h); CI green`. Where it does not, the thread report is all; keep going either way.

The 8-hour timer:

- **T3 Code:** `schedule_task` with `{type: "interval", everyMs: 28800000}`, bound to this thread, prompt `land-pr: send the 8-hour report for <PR url>`. Keep its id; `delete_scheduled_task` it at the finish.
- **Claude Code:** `pr-wait` runs under Monitor with `timeout_ms: 3600000`. On each timeout, check the time since the last report and send one if 8 hours have passed, then restart the watcher.
- **Codex, Gemini CLI:** cap each wait at the time left until the next report: `perl -e 'alarm shift; exec @ARGV' <seconds> <pr-wait> <pr> --until …`. An alarm exit (142) means a report is due.
