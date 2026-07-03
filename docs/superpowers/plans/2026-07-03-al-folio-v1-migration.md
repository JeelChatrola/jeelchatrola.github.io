# al-folio v1 Migration + Content Refresh — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development or executing-plans. Steps use checkbox (`- [ ]`) syntax.

**Goal:** Migrate jeelchatrola.github.io to al-folio v1 with Docker-only local dev, then manually refresh portfolio content.

**Architecture:** Phased migration — design approval → atomic Gemfile/Docker bootstrap → plugin/asset cleanup → config upgrade CLI → CI verify → content refresh. All local commands via `docker compose`.

**Tech Stack:** al-folio v1 gems, Jekyll, Docker (`ruby:3.2-slim`), GitHub Actions, GitHub Pages

**Audit:** PASS_WITH_FIXES — see [.planning/v1-MILESTONE-AUDIT.md](../../.planning/v1-MILESTONE-AUDIT.md)

**Roadmap:** [.planning/ROADMAP.md](../../.planning/ROADMAP.md)

---

## Phase 00: Design & Approval Gate

- [ ] Write `docs/superpowers/specs/2026-07-03-jeelchatrola-website-design.md`
- [ ] Include Tailwind visual-delta approval section (v1 vs current Bootstrap 4.6)
- [ ] Include Docker command cheat sheet (`docker compose run --rm jekyll bundle exec …`)
- [ ] Self-review spec (no TBD, no contradictions)
- [ ] Get user approval before Phase 01

---

## Phase 01: v1 Toolchain Bootstrap (atomic)

**Merge former steps 1.1 + 1.2 — Gemfile before Docker build.**

- [ ] Branch `upgrade/al-folio-v1`
- [ ] Replace `Gemfile` from [upstream al-folio main](https://github.com/alshedivat/al-folio/blob/main/Gemfile) (pin all `al_folio_*` versions)
- [ ] Bootstrap `Gemfile.lock`:
  ```bash
  docker run --rm -v "$PWD:/srv/jekyll" -w /srv/jekyll ruby:3.2-slim \
    bash -c "apt-get update -qq && apt-get install -y -qq build-essential git && gem install bundler && bundle lock"
  ```
- [ ] Commit `Gemfile` + `Gemfile.lock`
- [ ] Replace `Dockerfile` → `ruby:3.2-slim`, nbconvert via pip, `ADD Gemfile.lock`
- [ ] Add `bin/entry_point.sh` from upstream (volume-mounted; compose uses `/srv/jekyll/bin/entry_point.sh`)
- [ ] Update `docker-compose.yml`: `build: .`, ports 8080+35729, `JEKYLL_ENV=development`
- [ ] Add `.ruby-version` → `3.2.2`
- [ ] Delete or archive `docker-local.yml`
- [ ] Verify: `docker compose build && docker compose up` → http://localhost:8080

---

## Phase 02: Plugin & Asset Migration

- [ ] Delete `_plugins/cache-bust.rb`, `details.rb`, `external-posts.rb`, `file-exists.rb`, `hideCustomBibtex.rb`
- [ ] Verify `filtered_bibtex_keywords` still works via jekyll-scholar / al_folio_core
- [ ] Replace `assets/css/main.scss` Bootstrap imports with v1 Tailwind entry (`assets/tailwind/app.css` from upstream)
- [ ] Delete unmodified `assets/js/distillpub/` if audit flags as stale copies
- [ ] `docker compose run --rm jekyll bundle exec al-folio upgrade overrides audit`
- [ ] Reconcile `_includes/` (45), `_layouts/` (11), `_sass/` (6): delete stale copies, `overrides accept` for intentional
- [ ] Commit `.al-folio-overrides.yml` if needed

---

## Phase 03: Config Migration & Upgrade CLI

- [ ] `docker compose run --rm jekyll bundle exec al-folio upgrade audit`
- [ ] `docker compose run --rm jekyll bundle exec al-folio upgrade apply --safe`
- [ ] Save `upgrade report` → `.planning/upgrade-report.md`
- [ ] Add `al_folio:` block from upstream v1 `_config.yml`
- [ ] Merge personal settings: name, email, scholar_userid, url, social, giscus
- [ ] Remove legacy pins: `bootstrap:`, `jquery:`, `bootstrap-table:`, `mdb:` (lines 359–387)
- [ ] Remove/fix broken blocks at lines 393–407 (`jekyll_get_json`, `jsonresume`)
- [ ] Re-run audit → **0 blocking findings**
- [ ] Verify `/cv/` renders from `_data/cv.yml`

---

## Phase 04: CI & Deploy Verification

- [ ] Update `.github/workflows/deploy.yml`:
  - Drop `npm install -g mermaid.cli`
  - Pin `pip install nbconvert==<match Dockerfile>`
  - Ruby `3.2.2` (matches `.ruby-version`)
- [ ] Production build:
  ```bash
  docker compose run --rm -e JEKYLL_ENV=production jekyll bundle exec jekyll build
  ```
- [ ] Smoke test: `/`, `/cv/`, `/publications/`, `/projects/`, dark mode, selected papers
- [ ] If `.jekyll-cache` EACCES: uncomment Dockerfile USERID/GROUPID args, rebuild with `id -u`/`id -g`
- [ ] Push branch → GHA green → merge `master`

**Phase 1 done:** Site on v1, content may still be stale.

---

## Phase 05: Content Refresh (manual)

Source: `Jeel_Chatrola_Resume_Feb-26.pdf` on USB — edit files directly.

- [ ] `_pages/about.md` — Torc Simulation SWE, MS completed May 2025, Ann Arbor
- [ ] `_data/cv.yml` — Torc, Magna, IISc Research Associate, skills, dates
- [ ] `_bibliography/papers.bib` — HSCC 2025 (arxiv 2503.07762)
- [ ] `_projects/*.md` — Isaac Sim grasping, path planning, exploration, AutoCalibration, etc.
- [ ] `assets/pdf/` + `_pages/cv.md` — replace `example_pdf.pdf`
- [ ] `_news/announcement_*.md` — career updates
- [ ] `_data/repositories.yml` — pinned repos
- [ ] `_posts/2022-02-01-redirect.md` — update CV PDF redirect
- [ ] `assets/json/resume.json` — remove or stop referencing if v1 uses cv.yml only
- [ ] Verify each change via `docker compose up`

---

## Phase 06: Optional Demos (deferred)

Per-project ladder when requested:
1. Screenshot/GIF + GitHub link
2. Plotly via `al_charts`
3. Jupyter static embed or Marimo iframe

---

## Rollback

- Migration branch off `master` until GHA passes
- Do not merge half-migrated state
- Revert merge on `master` → GitHub Pages serves last good deploy

## Estimated Effort

| Phase | Effort |
|-------|--------|
| 00 | ~30 min |
| 01–04 | 1–2 weekends (override cleanup is variable) |
| 05 | 1 focused session |
