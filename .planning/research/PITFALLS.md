# Domain Pitfalls

**Domain:** Personal academic/professional website
**Researched:** 2026-07-03

## Critical Pitfalls

### Pitfall 1: Forking al-folio instead of using template
**What goes wrong:** Permanent link to upstream repo; merge conflicts on every update; v1 upgrade blocked.
**Why it happens:** "Fork" button is prominent on GitHub; users don't read INSTALL.md.
**Consequences:** Stuck on old version; security/stale dependencies; can't use upgrade CLI cleanly.
**Prevention:** "Use this template" → new repo. For existing fork, migrate to template copy.
**Detection:** `git remote -v` shows alshedivat/al-folio as upstream you never intended.

### Pitfall 2: v1 upgrade with stale local overrides (user at risk)
**What goes wrong:** Site breaks after gem update; duplicate layouts; missing features.
**Why it happens:** Pre-v1 sites copied `_includes/head.liquid`, `_includes/scripts.liquid`, `assets/js/distillpub/**` locally. User's repo has local `_includes/`, `_layouts/`, `_sass/`.
**Consequences:** Upgrade audit shows blocking findings; subtle JS/CSS bugs.
**Prevention:** Run `bundle exec al-folio upgrade audit`; delete copies you didn't intentionally customize; use `overrides accept` for real customizations.
**Detection:** `.al-folio-overrides.yml` missing; many local files mirror gem-owned paths.

### Pitfall 3: Choosing Sphinx for portfolio because you know Python
**What goes wrong:** Weeks spent building publication/CV features that al-folio gives free.
**Why it happens:** Sphinx is familiar from research code; Furo looks clean.
**Consequences:** Manual bibtex maintenance; portfolio feels like documentation site.
**Prevention:** Use Sphinx only for project docs; keep portfolio on Jekyll/Astro.
**Detection:** Rebuilding publication list by hand; no citation counts.

### Pitfall 4: Underestimating interactive demo scope (mels.ai trap)
**What goes wrong:** Months building browser-based simulation lab inside static site generator.
**Why it happens:** research.mels.ai looks like "a page" but is a full product (custom AI physics engine, real-time RL).
**Consequences:** Abandoned half-built demos; portfolio worse than simple screenshots.
**Prevention:** Tier demos (see FEATURES.md); ship iframe to hosted demo or 2–3 scoped islands first.
**Detection:** Demo requirements include WebGL engine, training loop, multi-user — that's an app, not a page.

### Pitfall 5: GitHub Pages build timeout (10 minutes)
**What goes wrong:** Deploy fails on large site with many notebooks/images.
**Why it happens:** jekyll-imagemagick, many Jupyter notebooks, full bibtex corpus.
**Consequences:** Site doesn't deploy; silent until GHA email.
**Prevention:** Optimize images pre-commit; limit notebook count; use GHA caching; split heavy assets to CDN.
**Detection:** GHA deploy job exceeds 10 min (official limit).

---

## Moderate Pitfalls

### Pitfall 6: Liquid templating frustration
**What goes wrong:** Hours debugging `{% assign %}` syntax, whitespace issues.
**Why it happens:** Liquid is limited and poorly documented (known Jekyll pain point).
**Prevention:** Minimize custom Liquid; use data files; consider Astro if templating becomes core workflow.

### Pitfall 7: `_config.yml` requires full rebuild
**What goes wrong:** Slow iteration on site settings.
**Why it happens:** Jekyll architecture; config changes aren't hot-reloaded.
**Prevention:** Batch config changes; use `docker compose up` for consistent local env (al-folio provides Docker).

### Pitfall 8: Custom domain misconfiguration
**What goes wrong:** Domain takeover risk if Pages disabled; SSL errors; www/apex redirect loops.
**Prevention:** Add domain in GitHub settings before DNS; use both apex + www records; verify domain.
**Source:** [GitHub Pages custom domain docs](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)

### Pitfall 9: Bandwidth soft limit (100 GB/mo on GitHub Pages)
**What goes wrong:** Site throttled or support email after viral post.
**Prevention:** Cloudflare Pages (unlimited bandwidth) or Cloudflare CDN in front; compress assets.

### Pitfall 10: Ruby version drift local vs CI
**What goes wrong:** `bundle install` works locally, fails in GHA.
**Prevention:** Pin Ruby in `.ruby-version` and GHA `ruby-version` (user has 3.2.2 in deploy.yml — good).

### Pitfall 11: Jupyter + mermaid build deps in CI
**What goes wrong:** Fragile GHA (pip + npm global + ruby); breaks when mermaid.cli deprecated.
**User context:** deploy.yml installs `jupyter` and `mermaid.cli` globally — maintenance surface.
**Prevention:** Pin versions; consider pre-rendering notebooks; al-folio v1 may change diagram pipeline.

---

## Minor Pitfalls

### Pitfall 12: SEO duplicate content (www vs non-www)
**Prevention:** Configure redirects in host settings.

### Pitfall 13: Dark mode flash on load
**Prevention:** al-folio handles this; custom sites need inline script in `<head>`.

### Pitfall 14: BibTeX encoding errors
**Prevention:** UTF-8 bib files; avoid special chars in keys; test `bundle exec jekyll build` locally.

### Pitfall 15: Over-engineering analytics
**Prevention:** Defer analytics until needed; use privacy-friendly options (al-folio ANALYTICS.md).

---

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| al-folio v1 upgrade | Stale local overrides | `upgrade audit` + delete unintentional copies |
| Astro migration | Rebuilding bibtex pipeline | Script bibtex → JSON at build; or keep publications on al-folio subdomain |
| First interactive demo | Bundle bloat | `client:visible`; code-split per demo route |
| Custom domain cutover | DNS propagation downtime | Lower TTL beforehand; keep old site until verified |
| Sphinx docs site | Confusing nav with portfolio | Separate subdomain |
| Demo with backend | GitHub Pages can't host API | Vercel/Netlify/CF Workers for API only |

---

## User-Specific Risk Assessment

Based on `jeelchatrola.github.io` inspection:

| Risk | Severity | Evidence |
|------|----------|----------|
| v1 upgrade override drift | **High** | Local `_includes/`, `_layouts/`, `_sass/` present |
| CI fragility | **Medium** | pip + npm + ruby in single GHA job |
| Pre-v1 dependency lock | **Medium** | Gemfile pins Jekyll 4.3.2, no al_folio gems |
| Interactive demo ambition mismatch | **High** if targeting mels.ai | Current stack supports tier 2–3, not tier 5 |

---

## Sources

- [al-folio upgrade tooling](https://github.com/al-org-dev/al-folio-upgrade)
- [al-folio v1.0 release notes](https://github.com/alshedivat/al-folio/releases)
- [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)
- [Adrian Sampson on Liquid pain](https://www.cs.cornell.edu/~asampson/blog/jekyll.html)
- User repo deploy.yml and directory structure
