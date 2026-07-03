# Feature Landscape

**Domain:** Personal academic/professional website
**Researched:** 2026-07-03

## Table Stakes

Features users expect. Missing = product feels incomplete.

| Feature | Why Expected | Complexity | al-folio | Sphinx+Furo | Astro custom |
|---------|--------------|------------|----------|-------------|--------------|
| About / bio page | Identity | Low | ✅ | ✅ manual | ✅ |
| CV / resume | Academic hiring norm | Med | ✅ RenderCV, YAML CV | ⚠️ manual | ✅ MDX/data |
| Publication list from BibTeX | Standard in academia | Med | ✅ jekyll-scholar | ❌ needs extension | ⚠️ custom script |
| Google Scholar citations | Credibility signal | Med | ✅ al_citations plugin | ❌ | ⚠️ custom |
| Project portfolio | Showcase work | Low | ✅ `_projects/` | ⚠️ manual toctree | ✅ content collections |
| Blog / news | Updates, visibility | Low | ✅ | ⚠️ ablog extension | ✅ |
| Dark mode | UX expectation 2026 | Low | ✅ | ✅ Furo | ✅ |
| Mobile responsive | Table stakes | Low | ✅ | ✅ | ✅ |
| Custom domain + HTTPS | Professionalism | Low | ✅ | ✅ | ✅ |
| SEO / social cards | Discoverability | Low | ✅ | ✅ | ✅ |
| Code syntax highlighting | CS/robotics audience | Low | ✅ | ✅ | ✅ |
| Contact / social links | Reachability | Low | ✅ | ✅ | ✅ |

## Differentiators

Features that set a site apart. Not expected, but valued.

| Feature | Value Proposition | Complexity | Best stack |
|---------|-------------------|------------|------------|
| **Interactive research demos** | Prove work, not just describe it | High | Astro/Next custom |
| Distill-style explainer posts | Rich ML paper communication | Med | al-folio (`al_folio_distill`) |
| Embedded Jupyter notebooks | Reproducible results | Med | al-folio, myst-nb (Sphinx) |
| Live WebGL / 3D sims | Robotics/CV visual impact | High | Custom app + embed |
| Bento-grid project tiles | Modern portfolio UX | Med | Astro + React islands |
| Auto-updated publication metrics | Low-maintenance credibility | Med | al-folio (GHA citation job) |
| Multi-language (i18n) | International audience | Med | Astro (best), al-folio (limited) |
| Full-text search | Large content libraries | Med | al-folio al_search; Sphinx built-in |
| RSS / Atom feed | Research followers | Low | All stacks |

## Anti-Features

Features to explicitly NOT build.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| Full CMS (WordPress) | Security, hosting cost, overkill | Static SSG + git workflow |
| SPA for entire portfolio | Poor SEO, slow TTI, unnecessary JS | Static HTML + islands |
| Self-hosted comments | Moderation burden, spam | Disable or use Giscus (al-folio supports) |
| Custom bibtex parser | Reinventing jekyll-scholar | Use existing tooling or export JSON at build time |
| Backend for every demo | Hosting cost, complexity | Browser-only demos; separate API only when needed |
| Forking al-folio repo | Upgrade nightmare | "Use this template" + gem updates (v1) |
| Sphinx for full portfolio | Wrong tool; docs UX not portfolio UX | Sphinx for project docs subdomain only |

## Feature Dependencies

```
BibTeX file → publication pages → Google Scholar citation counts
CV YAML → CV page → PDF export (RenderCV)
Interactive demo component → build toolchain (npm) → hosting with JS assets
Distill post → al_folio_distill plugin → optional Plotly/Chart.js
Custom domain → DNS records → SSL (automatic on all major hosts)
```

## Interactive Demo Spectrum

| Tier | Example | Stack fit | Effort |
|------|---------|-----------|--------|
| 1. Static + image/GIF | Screenshot of results | Any | Hours |
| 2. Client-side chart | Plotly, D3, Chart.js | al-folio, Astro island | Hours–days |
| 3. Embedded notebook | Jupyter in iframe | al-folio, Sphinx | Days |
| 4. Canvas/WebGL widget | 3D viz, simulation preview | Astro/React custom | Days–weeks |
| 5. Full interactive lab | research.mels.ai/ide | Separate web app + embed | Weeks–months |

**Key insight:** research.mels.ai is a **product** (browser AI robotics sandbox with custom physics engine), not a static-site feature. Embedding it on a portfolio means iframe/link to hosted app, not "add a plugin."

## MVP Recommendation

### If staying academic-portfolio focused:
1. About + CV + publications (BibTeX)
2. 3–5 project pages with screenshots
3. News/blog for updates
4. Custom domain

**Defer:** Interactive demo gallery, multi-language, custom search

### If pivoting to demo-showcase portfolio:
1. Astro shell with about + project grid
2. 2–3 flagship interactive demos (islands)
3. MDX write-ups per project
4. Publications as simpler list (manual or scripted bibtex import)

**Defer:** Google Scholar auto-sync, Distill posts, full CV automation

## Sources

- al-folio CUSTOMIZE.md (features: search, CV, charts, notebooks, Distill)
- [mateokadiu/portfolio-site](https://github.com/mateokadiu/portfolio-site) — bento demo pattern
- [cuberhaus/PersonalPortfolio](https://github.com/cuberhaus/PersonalPortfolio) — 20 Astro demos
- [mels.ai](https://mels.ai/) — reference for full interactive lab scope
- User site inventory: jeelchatrola.github.io (pre-v1 al-folio, Plotly, Distill, Jupyter assets present)
