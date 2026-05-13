# Code Management Guide

How to work with git and GitHub on this repository. Covers the everyday change lifecycle, pull requests, reviewing other people's work, and accepting contributions from outside the team.

## ATLAS Conventions

Use these ATLAS rules as the operating default for git and GitHub work in this repository.

| Git or GitHub term | ATLAS rule |
|---|---|
| Branch | Work on a short-lived branch such as `feature/<topic>`, `fix/<topic>`, `chore/<topic>`, or `rdt/<topic>` |
| Commit | Create one small commit per completed DT or RDT |
| Commit message | Include the DT or RDT ID when working from `devcycle.md` |
| Push | Push the branch after each completed DT or RDT when a GitHub remote exists |
| Pull request | Create or update the related pull request after each completed DT or RDT |
| Base branch | Use `main` as the normal pull request base branch unless the repo defines another base branch |
| Head branch | Use the active feature, fix, chore, or `rdt` branch as the pull request head branch |
| Merge | Merge the pull request into `main` when the dev cycle, phase, or reviewable task bundle is ready to close |
| Status checks and review | Merge only after required checks pass and review is complete |
| No remote case | If no GitHub remote exists, record that blocker in closeout or retro notes |
| Protected branch | Never force-push a protected branch |
| Hook bypass | Never use `--no-verify` without explicit permission |
| Secret hygiene | Never commit credentials, tokens, `.env` files, or `secrets.md` |

## Mental Model: Three Places Code Lives

```
YOUR MACHINE                              GITHUB (remote)
============                              ===============

  files on disk
        |
        | git add  (stage)
        v
  staging area
        |
        | git commit  (snapshot, LOCAL ONLY)
        v
  your local git repo
  on your active branch  ----git push---->  remote branch on GitHub
                                                    |
                                                    | open a PR
                                                    v
                                            Pull Request (proposal)
                                                    |
                                                    | click Merge
                                                    v
                                            main branch updated
```

Until you `git push`, no one else can see your work. Until a PR is merged, your work does not appear on the `main` branch (and does not appear by default on the GitHub Code tab).

## Core Commands

| Action | What it does | Visible to others? |
|---|---|---|
| `git add <file>` | Marks the file for inclusion in the next snapshot | No, local only |
| `git commit -m "<msg>"` | Saves a snapshot in your local repo with a message | No, local only |
| `git push` | Uploads your local commits to GitHub on the same branch name | Yes, on that branch |
| Open a Pull Request | Formal proposal to merge one branch into another (typically into `main`) | Yes |
| Merge the Pull Request | Copies the PR's commits onto the target branch (typically `main`) | Yes; now in default Code view |

## Working on a Change

### Branches

A branch is a parallel line of work. This repository has at least one important branch:

- `main` -- the trunk, the official line, the default branch GitHub shows in the Code tab. Treated as the source of truth.

Day-to-day work happens on short-lived branches created from `main`. Use a short prefix that signals scope:

- `feature/<topic>` for new work
- `fix/<topic>` for bug fixes
- `chore/<topic>` for tooling or cleanup
- `rdt/<topic>` for reset devtasks
- `contrib/<topic>` for contributions

Create one:

```
git checkout main
git pull
git checkout -b feature/my-change
```

### Committing

Commits should be small and descriptive. One commit per completed DT or RDT is the ATLAS convention in this repo. Stage specific files rather than using `git add -A`:

```
git add path/to/file1 path/to/file2
git commit -m "docs: DT<n> short imperative summary"
```

Match the commit message style in `git log` (look at recent commits before writing yours). For multi-paragraph messages, use a here-doc or here-string so the formatting is preserved.

Never:

- Commit credentials, tokens, `.env` files, or `secrets.md`
- Use `--no-verify` to skip hooks unless you have explicit permission
- Amend commits that have already been pushed

### Pushing

Push after each completed DT or RDT, and at any other safe stopping point:

```
git push -u origin feature/my-change   # first time on this branch
git push                                # subsequent pushes
```

Your branch now exists on GitHub at the same branch name. Other people can see it. Your work is backed up. The branch is not yet part of `main`.

## Pull Requests

A pull request (PR) is a formal proposal to merge a head branch into a base branch. It is the gate through which changes reach `main`.

### Creating a PR

From the command line:

```
gh pr create --base main --head feature/my-change \
  --title "<short title>" \
  --body "<summary and test plan>"
```

Or in the GitHub UI: after pushing, GitHub shows a "Compare & pull request" prompt on the repo page. Click it, confirm the base branch and head branch, then fill in the title and body.

PR body should include:

- **Summary** -- a few bullets on what changed and why
- **Test plan** -- how to verify the change works (commands, manual steps, or "N/A: docs only")

### What a PR represents

- A diff of every change between your branch and the base branch
- A discussion thread (Conversation tab)
- A set of status checks (CI, if configured)
- A review state: pending, approved, or changes requested
- A merge action

Until the PR is merged, the target branch (`main`) does not change. Anyone with read access can view the PR and comment on it.

## Reviewing a PR

Open the PR and use these tabs:

| Tab | What it shows |
|---|---|
| Conversation | High-level discussion, status checks, the Merge button |
| Commits | List of commits in the PR |
| Files changed | The full diff -- the primary review surface |

On **Files changed**:

- Hover next to any line and click the blue `+` to leave a line comment
- Click **Start a review** to batch comments across multiple files
- When done, click **Finish your review** and pick one of:

| Review type | Effect |
|---|---|
| Comment | General feedback, no opinion on merge |
| Approve | Green light; the Merge button unblocks |
| Request changes | Blocks merge until the author responds |

If the author pushes more commits in response, the PR updates automatically. Re-review the new commits via the **Commits** tab or by diffing against the previous head.

## Merging a PR

After approval, the green Merge button on the Conversation tab becomes available. GitHub offers three merge styles:

| Style | What it does | When to use |
|---|---|---|
| Create a merge commit | Keeps every PR commit plus a merge commit tying them in | Larger feature branches; preserves history |
| Squash and merge | Combines all PR commits into ONE commit on main | Small contributions; clean linear history |
| Rebase and merge | Replays PR commits onto main with no merge commit | Strictly linear history; rewrites commit SHAs |

Defaults for this repo:

- Multi-DT dev cycles, phase bundles, or larger reviewable branches: **Create a merge commit**
- Single-file or single-commit contributions: **Squash and merge**

### When to Merge to Main

Do not merge to `main` after every DT by default. Under ATLAS, complete each DT or RDT by committing, pushing, updating the pull request, recording validation, and updating the active planning docs. Merge the pull request when the dev cycle, phase, or other reviewable task bundle is ready to close.

A single-DT dev cycle can be merged as soon as that DT is complete, reviewed, and all required status checks pass. A multi-DT dev cycle should usually stay open as one pull request until the cycle is burned down and the bundled change is ready for `main`.

### Pre-Merge Checklist

Read every line in **Files changed**. Then check:

- Status checks are green (if CI is configured)
- File paths follow repo conventions (e.g., stack patterns under `patterns/stack-patterns/`, governance docs under `docs/cgr/`)
- No unrelated files sneaked in (`.env`, IDE settings, large binaries)
- No credentials, tokens, or secrets present
- Commit messages are reasonable -- you can rewrite them at squash time
- Markdown style, naming, and ATLAS doc conventions followed

### After Merging

- The PR flips to a purple **Merged** badge
- The PR's commits (or the single squashed commit) are on `main`
- The files appear in the default GitHub Code view
- A "Delete branch" button appears -- safe to click for branches on this repo (it does not affect any fork)

## Why Pushed Work May Not Appear on the Code Tab

The GitHub Code tab defaults to `main`. If your commits are on a feature branch and the PR is not yet merged, the Code tab will not show your changes by default. To find them before merge:

1. On the Code tab, use the branch dropdown to switch to your feature branch -- your files appear
2. Open the PR and use the **Files changed** tab
3. Merge the PR -- now the Code tab shows the changes

## External Contributors (Fork-Based Workflow)

People without write access to `picostar/Atlas_AI` cannot push branches directly. They use the fork model.

### What the Contributor Does

```
# On GitHub, click the Fork button on picostar/Atlas_AI
# This creates github.com/<them>/Atlas_AI

git clone https://github.com/<them>/Atlas_AI.git
cd Atlas_AI
git checkout -b contrib/my-change

# Make changes, then:
git add <files>
git commit -m "Describe the change"
git push origin contrib/my-change

# On GitHub, click "Compare & pull request" and target picostar/Atlas_AI main
```

The PR appears on **your** repo's Pull Requests tab. The contributor cannot push to your `main` directly -- the PR is the only path in.

### How to Review and Accept a Fork-Based PR

Identical to reviewing any PR. The diff, comments, approval, and merge flow are the same. The only difference is the head reference, which shows as `<their-username>:contrib/my-change` instead of `feature/...`.

After merge, the contributor receives an email notification, the PR shows **Merged**, and your `main` updated. The contributor can sync their fork using GitHub's **Sync fork** button on their fork's Code tab.

### Direct Write Access vs Fork

| Audience | Path | Trust level |
|---|---|---|
| Internal team, regular contributors | Direct write access to the repo, feature branches, PR to main | Higher |
| External contributors, one-off submissions | Fork the repo, branch on the fork, PR back to main | Lower |

Give direct write access for sustained collaborators. Keep external contributors on the fork model to avoid accidental pushes to main.

## Branch Protection

Even with the conventions above, by default anyone with write access can push directly to `main` and bypass PRs entirely. To enforce PRs, configure branch protection rules in **Settings -> Branches**:

- Require a pull request before merging
- Require at least one approval
- Require status checks to pass (once CI is configured)
- Restrict who can push to `main`
- Block force pushes
- Block branch deletion

With protection on, the PR flow is the only way changes reach `main`, including for repo administrators.

## Common Pitfalls

- **"My code isn't on GitHub"** -- check whether you ran `git push`. Local commits do not leave your machine until pushed.
- **"My code isn't on main"** -- check whether the PR was merged. Pushing puts code on the feature branch, not main.
- **"GitHub Code tab doesn't show my work"** -- the Code tab defaults to `main`. Use the branch dropdown or open the PR.
- **Pushed to the wrong branch** -- create the correct branch from your current commit, then either delete the wrong branch or reset it: `git checkout -b feature/correct-name` then handle the wrong branch separately.
- **Conflict on merge** -- resolve by pulling target branch into your feature branch, resolving conflicts locally, committing, and pushing. The PR updates automatically.
- **Committed a secret** -- do not just delete it in a new commit; the history still contains it. Rotate the secret immediately and consider using `git filter-repo` or BFG to scrub history (with team coordination).

## Summary

The flow for every change:

1. Branch off main
2. Commit small, descriptive snapshots locally
3. Push to GitHub
4. Open a PR targeting main
5. Review and respond to feedback
6. Merge the pull request into `main` when the dev cycle or reviewable task bundle is ready to close
7. Delete the feature branch

The PR is the formal handshake. Everything before merge is a proposal; merge is the moment a change becomes part of the project.
