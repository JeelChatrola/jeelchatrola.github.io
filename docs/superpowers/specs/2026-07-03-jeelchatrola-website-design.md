# jeelchatrola.github.io — Website Rebuild Design

**Date:** 2026-07-03  
**Status:** Approved for implementation (user authorized full plan execution)

## Goal

Migrate the personal academic portfolio from pre-v1 monolithic al-folio to **al-folio v1** (gem/plugin architecture), using **Docker-only** local development, then manually refresh stale content from the Feb-2026 resume.

## Constraints

| Constraint | Decision |
|------------|----------|
| Local dev | Docker only — no Ruby/Bundler on host |
| Phase order | v1 migration before content refresh |
| Content updates | Manual YAML/Markdown — no Jeel_Resume_AI sync |
| Demos | Deferred per-project (GIF → Plotly → Jupyter/Marimo) |
| Out of scope | Sphinx+Furo migration, Astro rewrite, mels.ai-level demo |

## Architecture

```
master (live GitHub Pages)
  └── upgrade/al-folio-v1 (migration sandbox)
        Phase 01–04: toolchain + v1 migration + CI
        Phase 05: content refresh
```

**Build path:** content (YAML/MD/BibTeX) → Jekyll + al_folio gems → `_site` → GitHub Actions → jeelchatrola.github.io

## Tailwind visual delta (approval gate)

al-folio v1 defaults to **Tailwind CSS** (`al_folio.style_engine: tailwind`) instead of Bootstrap 4.6.

**Expected changes:**
- Typography, spacing, and navbar/footer styling will differ
- Dark mode behavior preserved but may look subtly different
- Project cards and publication list use v1 component styling
- Custom `_sass/` overrides will be removed unless explicitly retained via `.al-folio-overrides.yml`

**Decision:** Accept Tailwind visual refresh as part of v1 migration. Content and structure take priority over pixel-perfect Bootstrap parity.

## Docker command cheat sheet

All local commands run inside Docker — no host Ruby.

```bash
# Dev server
docker compose up                    # http://localhost:8080

# Production build
docker compose run --rm -e JEKYLL_ENV=production jekyll bundle exec jekyll build

# al-folio upgrade tooling
docker compose run --rm jekyll bundle exec al-folio upgrade audit
docker compose run --rm jekyll bundle exec al-folio upgrade apply --safe
docker compose run --rm jekyll bundle exec al-folio upgrade report

# Override management
docker compose run --rm jekyll bundle exec al-folio upgrade overrides audit
docker compose run --rm jekyll bundle exec al-folio upgrade overrides accept PATH
```

**One-time lockfile bootstrap (Phase 01 only):**
```bash
docker run --rm -v "$PWD:/srv/jekyll" -w /srv/jekyll ruby:3.2-slim \
  bash -c "apt-get update -qq && apt-get install -y -qq build-essential git && gem install bundler && bundle lock"
```

## Phased delivery

| Phase | Deliverable |
|-------|-------------|
| 00 | This design spec |
| 01 | Gemfile v1, Gemfile.lock, Docker toolchain, `.ruby-version` |
| 02 | Remove `_plugins/`, Tailwind CSS entry, override cleanup |
| 03 | Config migration, upgrade audit = 0 blockers, `/cv/` works |
| 04 | CI aligned, production build green, merge to master |
| 05 | Content refresh (about, cv, papers, projects, news, PDF) |

## Content refresh checklist (Phase 05)

- `_pages/about.md` — Torc Simulation SWE, MS completed May 2025
- `_data/cv.yml` — Torc, Magna, IISc Research Associate
- `_bibliography/papers.bib` — HSCC 2025
- `_projects/*.md` — flagship projects
- `assets/pdf/` + `_pages/cv.md` — current CV PDF
- `_news/`, `_data/repositories.yml`, redirect post, `resume.json`

## Optional demo ladder (deferred)

1. Screenshot/GIF + GitHub link (default)
2. Plotly via `al_charts`
3. Jupyter static embed or Marimo iframe

## Rollback

- Work on `upgrade/al-folio-v1` until GHA passes
- Revert merge on `master` if deploy breaks — GitHub Pages serves last good build

## Tooling policy

Use upstream tooling only: `docker compose`, `bundle exec al-folio upgrade *`, `bin/entry_point.sh`, GHA deploy. No custom migration scripts in repo.
