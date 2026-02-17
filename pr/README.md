# PR Packet Templates and Workflow

This folder contains PR packet templates. The goal is repeatable PR execution with receipts.

## What gets committed

- Templates under `.github/pr/PR-000/` are committed.
- The PR body template is committed at `.github/pull_request_template.md`.

## What does not get committed

- Generated receipts and logs
- Temp patch bundles
- Local automation artifacts

Recommended .gitignore entries (already added in your repo):

- `docs/pr/**/receipts/`
- `.patches/`

## How to start a PR

1) Copy the templates to a new packet folder:
   - `docs/pr/PR-###/AGENTPACK.md`
   - `docs/pr/PR-###/INPUT.md`
   - `docs/pr/PR-###/CHECKLIST.md`
   - `docs/pr/PR-###/FIXLOG.md`

2) Fill AGENTPACK:
   - locked facts
   - gate commands
   - workstreams (if needed)
   - breakpoints

3) Run the loop:
   - `PR_NUM=### ./scripts/run_pr.sh`
   - Fix only what receipts show
   - Rerun until PASS or BREAKPOINT

4) PR body hygiene:
   - generate: `./scripts/pr_body_hygiene.sh`
   - apply: `SOLSERVER_PR=<num> REPO_SLUG=<owner/repo> ./scripts/pr_body_hygiene.sh` (if gh auth enabled)

5) Before merge:
   - CHECKLIST has evidence and PASS gates checked
   - FIXLOG has a clear summary and breakpoints logged
   - Promote to Canon section filled (even if TBD)

## Workstreams

Use workstreams when:

- work can be split cleanly (config vs env vs runtime vs docs)
- you want parallel worktrees/threads

Each workstream:

- updates CHECKLIST evidence for the items it owns
- appends FIXLOG with receipts
- runs the runloop at end

## Human-only steps

Anything involving:

- secrets
- DNS
- Apple accounts
- vendor access
must be treated as a BREAKPOINT and logged in FIXLOG.

## Scripts

If `scripts/` exists, treat it as the enforcement layer.
If scripts are missing, create them once and keep using them.
