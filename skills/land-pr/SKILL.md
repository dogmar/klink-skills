---
name: land-pr
description: Drive a pull request until it auto-merges, fixing CI and conflicts and reporting anything only a human can clear. Use when the user asks to land a PR, auto-merge it, or watch it until it merges.
---

# Land PR

Load the `babysit-pr` skill and follow it for waiting, review bots, rate limits, and fixing CI. This skill changes its finish line from _ready_ to **merged**, and adds the rules below. Where the two disagree, this skill wins.

## Guardrails

Approval and merge policy belong to humans. Your lane is the code on the PR branch and one `gh pr merge --auto` call at the start. Hard rules, with no exceptions:

- Never approve the PR, from any account or token.
- Never merge with `--admin` or otherwise bypass branch protection.
- Never dismiss a review or resolve a human's review thread.
- Never change repository or branch-protection settings.
- Never weaken CI to get green: no skipped or deleted tests, no `continue-on-error`, no edits to which checks are required.
- Never turn auto-merge back on after it turns off. Turning it on once in step 1 is the only time.

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

Send a report when the blocker set changes, every 8 hours, and at the finish. Write it in the thread:

```
<PR url> @ <short head SHA>
CI: <green | failing: names | pending>
Review: <approved | review required | changes requested by @x>
Auto-merge: <on (method) | off>
Blockers: <each, with how long it has waited | none>
Fixed since last report: <commits/actions | nothing>
```

Where a `PushNotification` tool exists, also send one line (under 200 characters) leading with what the user would act on, e.g. `land-pr #123: needs approval (waiting 2h); CI green`. Where it does not, the thread report is all; keep going either way.

The 8-hour timer:

- **T3 Code:** `schedule_task` with `{type: "interval", everyMs: 28800000}`, bound to this thread, prompt `land-pr: send the 8-hour report for <PR url>`. Keep its id; `delete_scheduled_task` it at the finish.
- **Claude Code:** `pr-wait` runs under Monitor with `timeout_ms: 3600000`. On each timeout, check the time since the last report and send one if 8 hours have passed, then restart the watcher.
- **Codex, Gemini CLI:** cap each wait at the time left until the next report: `perl -e 'alarm shift; exec @ARGV' <seconds> <pr-wait> <pr> --until …`. An alarm exit (142) means a report is due.
