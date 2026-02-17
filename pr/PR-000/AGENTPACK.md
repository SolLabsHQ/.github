# AGENTPACK — PR-000 (TEMPLATE)

As-of: YYYY-MM-DD  
Owner: <name>  
Home repo: <repo> (provider-first hub if cross-repo)

## Packet files

- INPUT: ./INPUT.md
- CHECKLIST: ./CHECKLIST.md
- FIXLOG: ./FIXLOG.md

## GitHub mapping

- GitHub PR: <url or number>
- Packet ID: PR-000 (template) or PR-### (milestone)

## Dependency order

If cross-repo, list provider first:

1) <provider repo>
2) <client repo>
3) <docs repo>

## Connected PRs

- <repo1>: TBD
- <repo2>: TBD
- <repo3>: TBD

## Locked facts

Only put facts you will not let drift during this PR.

- Hostnames:
  - staging: TBD
  - prod: TBD
- Region: TBD
- Persistence contract: TBD
- Process model: TBD (example: web + worker, shared DB path)

## Gates

These must be copy/pasteable commands. Avoid guessing.

- unit: TBD
- lint: TBD
- integration: TBD
- other: TBD (optional)

## Workstreams

Workstreams are a map, not automatic spawning. Use them to split work into parallel slices when helpful.
Each workstream must:

- stay within INPUT scope
- update CHECKLIST evidence
- append FIXLOG entries (what changed, why, receipts)
- end by running the runloop: `PR_NUM=<n> ./scripts/run_pr.sh` if available

### Default workstreams (A–D)

A) Config and deployment surface

- Deliver: config files, flags, hostnames, ports, process groups
- Breakpoints: secrets, DNS, Apple accounts, vendor access

B) Env and contracts

- Deliver: env var classification table (required/secret/default/scope/meaning)
- Rule: do not invent values. If unknown and no code default exists, leave TODO.

C) Runtime wiring and health

- Deliver: health endpoint, internal API base, worker handshake, idempotency, DB path consistency
- Evidence: links to code paths and logs

D) Docs and PR hygiene

- Deliver: runbook block for human steps
- Deliver: PR body hygiene from receipts (no invented links/outcomes)

## Breakpoints

Stop and log a BREAKPOINT in FIXLOG when any of these are required:

- credentials, secrets, DNS
- App Store Connect, signing, TestFlight
- anything that requires non-repo access
- anything you cannot prove with receipts

## Runloop

Enforcement contract:

- Use scripts as source of truth when present.
- Rerun until PASS or BREAKPOINT.

Commands:

- run: `PR_NUM=<n> ./scripts/run_pr.sh`
- build only: `PR_NUM=<n> ./scripts/build_pr.sh`
- verify only: `PR_NUM=<n> ./scripts/verify_pr.sh`
- PR body hygiene: `./scripts/pr_body_hygiene.sh` (apply via gh if configured)

## Promote to Canon (post-merge)

Fill these before closing the PR.

- ADR updated: TBD (or N/A)
- Evergreen docs updated: TBD
- Release notes updated: TBD
- Follow-ups created: TBD
