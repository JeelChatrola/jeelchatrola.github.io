# Research Summary: Personal Academic/Professional Website

**Domain:** Academic portfolio with optional interactive research demos
**Researched:** 2026-07-03
**Overall confidence:** HIGH (stack/hosting), MEDIUM (custom framework perf claims)

## Executive Summary

The personal academic website ecosystem in 2026 still centers on **static site generators hosted free on GitHub Pages**. For CV, publications, BibTeX, and blog — **al-folio remains the best-in-class choice** and is actively maintained (v1.0 released Jan 2026 with a gem/plugin architecture and official upgrade CLI). The user's current site (`jeelchatrola.github.io`) runs **pre-v1 monolithic al-folio** with local layout overrides, which creates real upgrade friction but is fixable.

**Sphinx + Furo** is the wrong primary tool for a portfolio. It excels at project documentation (API refs, tutorials) but lacks academic table stakes: BibTeX publication pipelines, CV layouts, Google Scholar integration. Use it as a **docs subdomain**, not a portfolio replacement.

**Custom sites (Astro recommended over Next.js)** make sense when **interactive demos are a core product differentiator** — not a nice-to-have. Sites like research.mels.ai/ide are full web applications (custom physics engine, real-time RL), not SSG features. Realistic patterns: Astro/React **islands** for tier-2–4 demos (charts, WebGL widgets, bento grids); **iframe or subdomain** for tier-5 labs. Astro ships near-zero JS by default; Next.js is justified only if you need SSR, auth, or API routes in-repo.

**Hosting:** GitHub Pages remains sufficient for personal academic traffic ($0, custom domain, 100 GB/mo soft limit). Cloudflare Pages adds unlimited bandwidth. Vercel/Netlify add preview deploys and serverless — only needed for API-backed demos.

**Migration:** Lowest risk = upgrade al-folio to v1.x in place. Highest flexibility = Astro greenfield or hybrid (al-folio for publications + Astro subdomain for demos).

---

## Recommendations Table

| Criterion | al-folio (stay/upgrade) | Sphinx + Furo | Astro custom | Next.js custom |
|-----------|-------------------------|---------------|--------------|----------------|
| **Publications / BibTeX** | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐ (script needed) | ⭐⭐⭐ |
| **CV / academic layout** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **Maintenance burden** | ⭐⭐⭐ (medium) | ⭐⭐⭐ | ⭐⭐ (higher) | ⭐⭐ (higher) |
| **Customization ceiling** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **Interactive demos** | ⭐⭐ (notebooks, charts) | ⭐⭐ (notebooks) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **GitHub Pages fit** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ (GHA) | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ (static export OK) |
| **Time to first ship** | ⭐⭐⭐⭐⭐ (done) | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| **Perf / Lighthouse** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Learning curve** | ⭐⭐⭐⭐ (you know it) | ⭐⭐⭐ (Python) | ⭐⭐⭐ (JS/TS) | ⭐⭐⭐ (React) |

### Verdict by user goal

| Your priority | Recommendation |
|---------------|----------------|
| Keep site running, minimal work | **Upgrade al-folio v0.16 → v1.x** |
| Add 1–3 chart/notebook demos | **Stay on al-folio** (Distill, Jupyter, Plotly) |
| Demo gallery is the main attraction | **Astro + React islands** (hybrid or full migration) |
| Project documentation site | **Sphinx + Furo on `docs.` subdomain** |
| mels.ai-level interactive lab | **Separate web app** + link/embed from any portfolio |

---

## Key Tradeoffs

### al-folio: stay vs leave

| Stay | Leave |
|------|-------|
| Publications/CV already working | Local `_includes/`/`_layouts/` block clean v1 upgrade |
| Community themes, plugins, citation GHA | Liquid is painful for complex logic |
| Zero migration cost if minor upgrade | Interactive demos require fighting Jekyll |
| GitHub Pages deploy already configured | Ruby toolchain is niche vs npm ecosystem |

### Sphinx + Furo vs al-folio

| Sphinx wins | al-folio wins |
|-------------|---------------|
| Python project API docs | BibTeX → publication pages |
| Built-in doc search | Academic visual design |
| Versioned documentation | Google Scholar citations |
| MyST markdown + notebooks | CV, news, projects out of the box |

### Astro vs Next.js (if going custom)

| Astro wins | Next.js wins |
|------------|--------------|
| Content-first portfolio | Need SSR / auth / API in same repo |
| 0 KB default JS | Team standardized on React App Router |
| GitHub Pages static deploy | Server Actions, ISR for dynamic pages |
| Per-demo code splitting | Full SPA pages for complex apps |

### Hosting: GitHub Pages vs alternatives

| GitHub Pages | Cloudflare / Vercel / Netlify |
|--------------|-------------------------------|
| $0, already integrated | Preview deploys per PR |
| Perfect for Jekyll/Astro static | Serverless for API-backed demos |
| 100 GB/mo bandwidth soft cap | Cloudflare: unlimited bandwidth |
| 10 min build timeout | More build minutes (Vercel 6000/mo) |

---

## Questions to Answer Before Choosing

Answer these to pick a stack — be honest about time budget and demo ambition.

### 1. What is the site's primary job?
- [ ] **Credentialing** (CV, publications, hireability) → al-folio
- [ ] **Showcasing interactive work** (demos are the hero) → Astro custom
- [ ] **Documenting a codebase/project** → Sphinx + Furo (subdomain)
- [ ] **All three equally** → Hybrid architecture

### 2. How many interactive demos do you want in year one?
- [ ] **0–2** (screenshots + maybe a chart) → stay al-folio
- [ ] **3–8** (bento grid, WebGL, widgets) → Astro islands
- [ ] **1 full lab app** (mels.ai tier) → separate app repo + embed

### 3. Do demos need a backend (GPU, database, planner API)?
- [ ] **No** — browser-only → any static host
- [ ] **Yes** → need Vercel/Netlify/CF Workers; GitHub Pages alone insufficient

### 4. How much time per month for site maintenance?
- [ ] **<1 hour** → al-folio, minimize custom overrides
- [ ] **2–5 hours** → al-folio v1 upgrade + occasional demos
- [ ] **5+ hours** → Astro custom is viable

### 5. How important is BibTeX / auto citation counts?
- [ ] **Critical** → al-folio (or port bibtex script to Astro — extra work)
- [ ] **Nice to have** → any stack with manual publication list
- [ ] **Don't care** → any stack

### 6. Are you willing to run a v1 al-folio upgrade audit?
- [ ] **Yes** → upgrade in place (recommended first step regardless)
- [ ] **No, rather rebuild** → Astro migration with content export

### 7. Custom domain status?
- [ ] **Using `*.github.io` only** → any host, zero DNS work
- [ ] **Have custom domain** → verify DNS on chosen host; GitHub Pages domain verification required
- [ ] **Need to buy one** → ~$10–15/yr at any registrar

### 8. Python vs JavaScript comfort for build tooling?
- [ ] **Prefer Python** → Sphinx for docs; still use al-folio or Astro for portfolio
- [ ] **Prefer JavaScript/TypeScript** → Astro
- [ ] **Neither strongly** → al-folio (you already have it working)

---

## Implications for Roadmap

Suggested phase structure based on research:

### Phase 1: Assess & stabilize (if staying al-folio)
- Run `bundle exec al-folio upgrade audit` on current site
- Inventory local overrides in `_includes/`, `_layouts/`, `_sass/`
- Upgrade to v1.x or pin current version explicitly
- **Avoids:** v1 override drift pitfall

### Phase 2: Content refresh
- Update CV, publications, projects
- Add 1–2 tier-2 demos (Plotly/chart) using existing al-folio tooling
- **Addresses:** table stakes features

### Phase 3: Demo strategy (only if demos are priority)
- Prototype one Astro island demo
- Decide hybrid (demos subdomain) vs full migration
- **Addresses:** differentiator features from FEATURES.md

### Phase 4: Optional docs subdomain
- Sphinx + Furo for project documentation if needed
- **Avoids:** Sphinx-as-portfolio pitfall

### Phase 5: Custom domain & polish
- DNS, SSL, SEO, analytics
- **Standard across all stacks**

**Phase ordering rationale:** Stabilize existing investment before greenfield rebuild. Demo ambition should be proven with 1–2 demos before committing to Astro migration.

**Research flags:**
- Phase 1 (v1 upgrade): **Needs deeper research** — run audit on user's actual repo
- Phase 3 (Astro demos): Standard patterns, unlikely to need more research
- Phase 3 (API-backed demos): Needs phase-specific research on serverless host choice

---

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | **HIGH** | al-folio v1 verified via releases; Furo via official docs |
| Features | **HIGH** | User repo inspected; mels.ai scope verified |
| Architecture | **HIGH** | Islands pattern in Astro official docs |
| Pitfalls | **HIGH** | User has specific v1 override risk |
| Hosting limits | **HIGH** | GitHub official docs |
| Astro vs Next perf | **MEDIUM** | Independent benchmarks, not controlled |

---

## Gaps to Address

- **research.mels.ai/ide exact embed stack** — page is a thin shell; underlying app is proprietary (mels.ai product). Treat as reference for ambition level, not copyable architecture.
- **al-folio v1 upgrade on user's exact repo** — needs running `upgrade audit` locally to list blocking findings.
- **BibTeX → Astro pipeline** — no standard package; would need custom build script or third-party tool (e.g. `bibtex-converter`, citeproc).
- **Sphinx academic extensions** — `sphinxcontrib-bibtex` exists but is docs-oriented, not portfolio-polished.

---

## Quick Decision Tree

```
Need mels.ai-level lab?
  YES → Build separate app → embed in any portfolio
  NO ↓
Are demos the #1 site priority?
  YES → Astro (+ consider hybrid for publications)
  NO ↓
Happy with current al-folio content workflow?
  YES → Upgrade to v1.x, add tier-2 demos in place
  NO ↓
Primary need is Python project docs?
  YES → Sphinx on docs subdomain + keep/fix portfolio separately
  NO → Astro greenfield
```
