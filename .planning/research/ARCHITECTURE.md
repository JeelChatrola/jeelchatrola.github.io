# Architecture Patterns

**Domain:** Personal academic/professional website
**Researched:** 2026-07-03

## Recommended Architectures (by ambition)

### A. Academic Static (al-folio) — lowest ops
```
┌─────────────────────────────────────────────────┐
│  GitHub repo (content + config)                 │
│  _config.yml, _data/, _bibliography/, _pages/  │
└────────────────────┬────────────────────────────┘
                     │ push to main
                     ▼
┌─────────────────────────────────────────────────┐
│  GitHub Actions                                 │
│  bundle install → jekyll build → deploy _site   │
└────────────────────┬────────────────────────────┘
                     ▼
┌─────────────────────────────────────────────────┐
│  GitHub Pages (CDN) → username.github.io        │
│  Optional: custom domain (CNAME)                │
└─────────────────────────────────────────────────┘
```

### B. Docs subdomain (Sphinx + Furo)
```
main-site.github.io     →  al-folio or Astro (portfolio)
docs.main-site.com      →  Sphinx build (project documentation)
```
Keep portfolio and documentation as **separate builds**. Do not force one SSG to do both.

### C. Demo-forward (Astro islands) — recommended for interactivity
```
┌──────────────────────────────────────────────────────────┐
│  Astro static shell (HTML/CSS, zero JS default)          │
│  ├── Content collections (projects, posts, CV data)    │
│  ├── Static pages (about, publications list)             │
│  └── Demo routes (/demos/[slug])                         │
│       └── React/Svelte island (client:visible)           │
└────────────────────┬─────────────────────────────────────┘
                     │ optional
                     ▼
┌──────────────────────────────────────────────────────────┐
│  External demo app (Vercel/CF Pages)                       │
│  iframe embed or subdomain (lab.yoursite.com)            │
└──────────────────────────────────────────────────────────┘
```

### D. Hybrid (pragmatic migration path)
```
jeelchatrola.github.io     →  al-folio (publications, CV, blog)
demos.jeelchatrola.com     →  Astro or standalone React app
docs.jeelchatrola.com      →  Sphinx (if needed)
```

---

## Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| Content layer | Markdown/YAML/BibTeX source | Build system only |
| Build pipeline | SSG compile → static HTML/JS/CSS | CI (GHA), package managers |
| Theme/runtime | Layout, nav, dark mode, search | Content via frontmatter |
| Citation engine | BibTeX → publication pages | `_bibliography/*.bib`, GScholar API (GHA) |
| Demo runtime | Interactive widgets | CDN assets, optional API |
| Hosting/CDN | Serve static files, SSL | DNS registrar |
| Analytics | Traffic (optional) | Privacy-compliant script |

---

## Interactive Demo Patterns

### Pattern 1: Static island (Astro `client:visible`)
**What:** React/Svelte component hydrates when scrolled into view.
**When:** Charts, sliders, small simulations, UI prototypes.
**Example:**
```astro
---
import RobotSim from '../components/RobotSim.tsx';
---
<RobotSim client:visible />
```
**Complexity:** Low–medium per demo.

### Pattern 2: iframe embed
**What:** Host demo as separate app; embed via `<iframe>`.
**When:** Heavy WebGL, WASM, Web Workers, apps like mels.ai.
**Pros:** Isolation, independent deploy, no SSG rebuild for demo updates.
**Cons:** SEO weak for demo content, sizing/mobile friction, cross-origin limits.

### Pattern 3: Notebook / Distill page
**What:** Long-form interactive article with inline widgets.
**When:** Research explanations with code + viz.
**al-folio:** Distill layout + optional Plotly; Jupyter via iframe.
**Complexity:** Medium; good for paper-adjacent content, not app-like demos.

### Pattern 4: WASM / Web Workers
**What:** Compute-heavy demos in browser (OpenCV.js, custom physics).
**When:** CV/robotics demos without backend.
**Hosting:** Static assets on any host; watch bundle size.
**Reference:** cuberhaus/PersonalPortfolio uses WASM + Web Workers for CV demos.

### Pattern 5: Server island / API-backed demo
**What:** Static shell + `server:defer` or fetch to serverless function.
**When:** Demo needs GPU inference, planner API, live data.
**Requires:** Netlify/Vercel/CF Workers (not pure GitHub Pages).
**Example:** PDDL planner demo with FastAPI backend (PersonalPortfolio pattern).

---

## Data Flow

### Publication update flow (al-folio)
```
papers.bib (edit) → git push → GHA jekyll build → jekyll-scholar generates pages
                                                      ↓
                              optional: citation GHA fetches Google Scholar counts
```

### Demo update flow (Astro)
```
DemoComponent.tsx (edit) → git push → GHA astro build → static HTML + chunked JS
                                                      ↓
                              CDN serves; only demo route loads demo JS bundle
```

---

## Anti-Patterns to Avoid

### Anti-Pattern 1: Monolithic fork of al-folio
**What:** Forking the theme repo and editing core layouts.
**Why bad:** v1 gem architecture makes local overrides drift from upstream; upgrade pain.
**Instead:** Use template repo; customize via `_config.yml`, `_data/`, content only. Use `al-folio upgrade overrides` for intentional overrides.

### Anti-Pattern 2: Heavy JS on every page (Next.js SPA portfolio)
**What:** Wrapping entire portfolio in React client bundle.
**Why bad:** 100–400 KB JS for pages that are mostly text; worse mobile perf.
**Instead:** Astro static shell; hydrate only demo routes.

### Anti-Pattern 3: Sphinx for portfolio + docs in one confusing site
**What:** Using Furo sidebar nav for "About / CV / Publications."
**Why bad:** Docs IA ≠ portfolio IA; bibtex story is weak.
**Instead:** Sphinx for `docs.` subdomain; portfolio on main domain.

### Anti-Pattern 4: Building mels.ai-level interactivity inside Jekyll
**What:** Custom WebGL engine in `assets/js/`.
**Why bad:** No component model, no HMR, no code splitting; unmaintainable.
**Instead:** Separate demo app; link or iframe from portfolio.

---

## Scalability Considerations

| Concern | Personal site (~100 visits/day) | Popular researcher (~10K/mo) | Viral demo post |
|---------|--------------------------------|-------------------------------|-----------------|
| Hosting | GitHub Pages free | GitHub Pages OK | May hit 100 GB bandwidth |
| Build time | <5 min Jekyll/Astro | Same | Same |
| Demo JS size | Irrelevant | Lazy hydration matters | CDN caching critical |
| Backend demos | N/A | Serverless free tier | Rate limit / cost spike |

**At personal scale, all stacks are overprovisioned.** Choose based on DX and demo ambitions, not scale.

---

## Migration Architecture (user-specific)

Current state: **pre-v1 monolithic al-folio** at `jeelchatrola.github.io`
- Local `_includes/`, `_layouts/`, `_sass/` (customization debt)
- GHA: Ruby 3.2.2, pip jupyter, mermaid.cli, jekyll build
- Assets: Distill, Plotly, Jupyter support

### Path 1: Upgrade al-folio v0.16 → v1.x
```
audit local overrides → remove unintentional copies → bundle exec al-folio upgrade apply --safe
→ pin gem versions → test GHA build
```
Preserves URL structure and content. Lowest disruption.

### Path 2: Content export → Astro
```
Extract: _data/cv.yml, _bibliography/*.bib, _projects/*, _posts/*, _pages/*
→ Convert to Astro content collections + bibtex build script
→ New GHA (npm ci && astro build)
→ DNS unchanged
```
Highest flexibility for demos. One-time migration cost.

### Path 3: Hybrid
```
Keep al-folio for publications/CV
New repo: demos-site (Astro) → demos.jeelchatrola.com
Cross-link from project pages
```
Best if publications workflow is fine but demos are the growth area.

---

## Sources

- [al-folio v1.0 architecture](https://github.com/alshedivat/al-folio/releases/tag/v1.0.0)
- [Astro islands](https://docs.astro.build/en/concepts/islands/)
- [Astro server islands](https://docs.astro.build/en/guides/server-islands/)
- [patterns.dev islands architecture](https://www.patterns.dev/vanilla/islands-architecture/)
- User deploy.yml and repo structure
