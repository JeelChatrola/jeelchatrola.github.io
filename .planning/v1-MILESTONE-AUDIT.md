---
milestone: v1
audited: 2026-07-03
source: gsd-plan-checker review of al-folio v1 migration plan
verdict: PASS_WITH_FIXES
---

# Milestone Audit — jeelchatrola.github.io v1 Migration

## Summary

Plan direction is correct (Docker-only local dev, migration before content, demos deferred). Four blockers and several warnings must be closed before Phase 1 execution.

## Gaps

### gaps.requirements

```yaml
- id: TOOL-01
  priority: must
  description: Bootstrap Gemfile.lock before first Docker build
  reason: Repo has no Gemfile.lock; upstream v1 Dockerfile ADD Gemfile.lock fails
  missing:
    - One-off container bundle lock step
    - Commit Gemfile.lock to repo

- id: TOOL-02
  priority: must
  description: Atomic Gemfile + Docker toolchain step
  reason: Docker build before Gemfile swap builds against pre-v1 stack
  missing:
    - Merge plan steps 1.1+1.2 into single atomic sequence

- id: MIG-01
  priority: must
  description: Remove duplicate _plugins/ Ruby files
  reason: 5 local plugins duplicate v1 gems (cache-bust, ext_posts, etc.)
  affected:
    - _plugins/cache-bust.rb
    - _plugins/details.rb
    - _plugins/external-posts.rb
    - _plugins/file-exists.rb
    - _plugins/hideCustomBibtex.rb

- id: MIG-02
  priority: must
  description: Migrate CSS from Bootstrap/_sass to v1 Tailwind entry
  reason: assets/css/main.scss still imports local _sass/*; v1 uses assets/tailwind/app.css
  affected:
    - assets/css/main.scss
    - assets/tailwind/app.css (add from upstream)

- id: MIG-03
  priority: must
  description: Fix broken CV config blocks
  reason: jekyll_get_json/jsonresume point at invalid assets/_layouts/cv.html
  affected:
    - _config.yml lines 393-407

- id: MIG-04
  priority: should
  description: Reconcile theme override drift
  reason: 11 layouts, 45 includes, 6 sass, assets/js/distillpub/ shadow gem-owned files
  missing:
    - overrides audit workflow
    - .al-folio-overrides.yml for intentional customizations

- id: CI-01
  priority: should
  description: Align CI with v1 Docker toolchain
  reason: mermaid.cli deprecated; nbconvert unpinned; Ruby version drift
  affected:
    - .github/workflows/deploy.yml

- id: CI-02
  priority: should
  description: Pin Ruby version across Docker and GHA
  reason: GHA 3.2.2 vs floating ruby:slim
  missing:
    - .ruby-version
    - ruby:3.2-slim in Dockerfile

- id: SPEC-01
  priority: should
  description: User approval gate for Tailwind visual delta
  reason: v1 default look differs from Bootstrap 4.6 site; not in original plan

- id: CONTENT-01
  priority: should
  description: Expand Phase 2 content checklist
  reason: _news/, repositories.yml, redirect post, resume.json still MS-era
  missing:
    - _news/announcement updates
    - _data/repositories.yml
    - _posts/2022-02-01-redirect.md
    - assets/json/resume.json cleanup

- id: DEMO-01
  priority: nice
  description: Optional per-project interactive demos
  reason: Deferred by user; no work until explicitly requested
```

### gaps.integration

```yaml
- id: INT-01
  from: phase-1-toolchain
  to: phase-3-config
  connection: Gemfile.lock must exist before upgrade audit runs in Docker
  priority: must

- id: INT-02
  from: phase-2-assets
  to: phase-3-config
  connection: _plugins removal must precede upgrade apply to avoid duplicate registration
  priority: must

- id: INT-03
  from: phase-3-config
  to: phase-4-ci
  connection: deploy.yml must match Gemfile.lock and nbconvert pin from Dockerfile
  priority: should

- id: INT-04
  from: phase-4-ci
  to: phase-5-content
  connection: Content refresh only after GHA green on migration branch
  priority: must
```

### gaps.flows

```yaml
- id: FLOW-01
  name: Local Docker dev build
  broken_at: First docker compose build
  reason: No Gemfile.lock + old Gemfile
  priority: must

- id: FLOW-02
  name: CV page render
  broken_at: /cv/ after v1 migration
  reason: Broken jsonresume config; must use _data/cv.yml + al_folio_cv
  priority: must

- id: FLOW-03
  name: GHA deploy to GitHub Pages
  broken_at: bundle exec jekyll build in CI
  reason: v1 gems + mermaid.cli + Ruby drift
  priority: should
```
