# Roadmap — jeelchatrola.github.io v1 Milestone

**Goal:** Migrate to al-folio v1 (Docker-only local dev), then refresh portfolio content.

**Audit:** [.planning/v1-MILESTONE-AUDIT.md](v1-MILESTONE-AUDIT.md) (2026-07-03, PASS_WITH_FIXES)

---

## Phase 00: Design & Approval Gate

**Goal:** Written design spec with explicit Tailwind visual-delta approval before code changes.

**Requirements:** SPEC-01

**Gap closure:** User approval gate missing from original plan

**Deliverables:**
- `docs/superpowers/specs/2026-07-03-jeelchatrola-website-design.md`
- Docker command cheat sheet in spec
- User sign-off before Phase 01

**Directory:** `.planning/phases/00-design-approval-gate/`

---

## Phase 01: v1 Toolchain Bootstrap

**Goal:** Atomic Gemfile v1 + Gemfile.lock + Docker assets; local `docker compose up` works.

**Requirements:** TOOL-01, TOOL-02, CI-02

**Gap closure:** Gemfile.lock chicken-and-egg; Docker-before-Gemfile ordering; Ruby drift

**Branch (caveman):** `master` = live Pages site. Migration branch = sandbox. `git checkout -b upgrade/al-folio-v1` off fresh `master`. Merge only after Phase 04 GHA green.

**No random scripts:** Use `docker compose`, `bundle exec al-folio upgrade *`, upstream `bin/entry_point.sh`, GHA deploy. Delete stale `bin/deploy`, `bin/cibuild`, `bin/docker_*.sh` — don't replace with new helpers.

**Tasks:**
1. Branch `upgrade/al-folio-v1` (see plan **Workflow rules**)
2. Delete stale `bin/deploy`, `bin/cibuild`, `bin/docker_*.sh`; archive `docker-local.yml`
3. Replace `Gemfile` from upstream al-folio v1 (pin `al_folio_*` versions)
4. Bootstrap lock: `docker run --rm -v "$PWD:/srv/jekyll" -w /srv/jekyll ruby:3.2-slim bash -c "gem install bundler && bundle lock"`
5. Replace `Dockerfile` (`ruby:3.2-slim`), `docker-compose.yml`, `bin/entry_point.sh` (upstream only)
6. Add `.ruby-version` (3.2.2)
7. `docker compose build && docker compose up` — verify :8080

**Directory:** `.planning/phases/01-v1-toolchain-bootstrap/`

---

## Phase 02: Plugin & Asset Migration

**Goal:** Remove gem-duplicating plugins; migrate to Tailwind CSS entry; start override cleanup.

**Requirements:** MIG-01, MIG-02, MIG-04

**Gap closure:** `_plugins/` and `main.scss` blockers; partial override scope

**Tasks:**
1. Delete `_plugins/*.rb` (unless upgrade audit flags gap)
2. Replace `assets/css/main.scss` with v1 Tailwind path (`assets/tailwind/app.css` from upstream)
3. Delete unmodified `assets/js/distillpub/` copies
4. Run `bundle exec al-folio upgrade overrides audit`
5. Delete stale `_includes/`, `_layouts/`, `_sass/` copies; `overrides accept` for intentional ones

**Directory:** `.planning/phases/02-plugin-asset-migration/`

---

## Phase 03: Config Migration & Upgrade CLI

**Goal:** `upgrade audit` returns 0 blockers; CV renders from `_data/cv.yml`.

**Requirements:** MIG-03

**Gap closure:** Broken jsonresume flow; config contract migration

**Tasks:**
1. `bundle exec al-folio upgrade audit`
2. `bundle exec al-folio upgrade apply --safe` (document any manual fixes)
3. `bundle exec al-folio upgrade report` → `.planning/upgrade-report.md`
4. Add `al_folio:` block; merge personal settings (name, scholar, url, social)
5. Remove bootstrap/jquery/mdb version pins (lines 359–387)
6. Remove/fix `jekyll_get_json` + `jsonresume` blocks (lines 393–407)
7. Commit `.al-folio-overrides.yml` if any overrides retained
8. Re-run audit → 0 blockers

**Directory:** `.planning/phases/03-config-upgrade-cli/`

---

## Phase 04: CI & Deploy Verification

**Goal:** GHA build green; production Docker build passes; key pages smoke-tested.

**Requirements:** CI-01

**Gap closure:** mermaid.cli, nbconvert pin, GHA/Docker parity

**Tasks:**
1. Update `.github/workflows/deploy.yml`: drop `mermaid.cli`, pin `nbconvert`, align Ruby
2. `docker compose run --rm -e JEKYLL_ENV=production jekyll bundle exec jekyll build`
3. Smoke test: `/`, `/cv/`, `/publications/`, `/projects/`, dark mode
4. Push branch → verify GHA → merge to `master`

**Directory:** `.planning/phases/04-ci-deploy-verification/`

---

## Phase 05: Content Refresh

**Goal:** Site reflects 2025–2026 public career (manual edits).

**Requirements:** CONTENT-01

**Gap closure:** Expanded content checklist from audit

**Tasks:**
1. `_pages/about.md` — Torc, completed MS, Ann Arbor
2. `_data/cv.yml` — Torc, Magna, IISc, skills
3. `_bibliography/papers.bib` — HSCC 2025
4. `_projects/*.md` — flagship projects
5. `assets/pdf/` + `_pages/cv.md` — replace `example_pdf.pdf`
6. `_news/`, `_data/repositories.yml`, redirect post, `assets/json/resume.json`
7. Verify via `docker compose up`

**Directory:** `.planning/phases/05-content-refresh/`

---

## Deferred

**Phase 06+ (optional):** Per-project interactive demos (Jupyter, Marimo, Plotly) — only when explicitly requested (DEMO-01).

---

## Next

`/gsd:plan-phase 00` — plan first gap-closure phase
