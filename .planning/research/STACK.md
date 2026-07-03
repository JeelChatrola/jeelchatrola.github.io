# Technology Stack

**Project:** Personal academic/professional website
**Researched:** 2026-07-03

## Recommended Stack (by goal)

| Goal | Recommended | Runner-up | Avoid |
|------|-------------|-----------|-------|
| Minimal maintenance, academic CV/publications | **al-folio v1.x** on GitHub Pages | Hugo + academic theme | Sphinx for portfolio |
| Technical docs + light about page | **Sphinx + Furo** + MyST | MkDocs Material | al-folio for API docs |
| Interactive demo showcase (mels.ai-style) | **Astro 5 + React islands** | Next.js static export | al-folio for heavy interactivity |
| Maximum performance, simple portfolio | **Hugo** + custom theme | Astro | Jekyll for greenfield |

**Opinionated default for this user:** Stay on al-folio if publications/CV are the core and demos are occasional. Move to **Astro** if interactive demos become a primary differentiator.

---

## Option 1: al-folio (Jekyll)

### Core Framework
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Jekyll | 4.3.x (user) / 4.x (v1 starter) | Static site generator | Native academic theme ecosystem |
| al-folio | v0.16.x (user) → **v1.0+** (current) | Academic theme + plugins | 15K+ stars, active maintenance, bibtex/CV/Distill built-in |
| Ruby | 3.2+ | Build runtime | Required; GitHub Actions handles CI |
| jekyll-scholar | via `al_citations` plugin (v1) | BibTeX → publication pages | Table stakes for academics |
| Tailwind v4 | v1 runtime | Styling (v1) | Replaces Bootstrap/SCSS in v1 |

### v1 Architecture Change (critical)
As of **v1.0 (Jan 2026)**, al-folio split from monolithic repo to **thin starter + RubyGems plugins** (`al_folio_core`, `al_folio_distill`, `al_folio_cv`, `al_search`, `al_charts`, etc.). The user's current site (`jeelchatrola.github.io`) is **pre-v1 monolithic** with local `_includes/`, `_layouts/`, `_sass/` — upgrading requires migration tooling.

### Interactive demo support (built-in)
| Capability | Mechanism | Complexity |
|------------|-----------|------------|
| Charts | `al_charts` / Chart.js plugin | Low |
| Diagrams | Mermaid (build-time via mermaid.cli) | Low |
| Notebooks | jekyll-jupyter-notebook (iframe) | Medium |
| Distill articles | `al_folio_distill` | Medium |
| Custom WebGL/canvas demos | Manual JS in `assets/` or page overrides | High — not first-class |

### Deployment
| Platform | Fit | Notes |
|----------|-----|-------|
| GitHub Pages | **Excellent** | Official path; GHA builds + deploys `_site` |
| Netlify/Vercel | Good | Overkill unless adding serverless |
| Custom domain | Supported | DNS at registrar + repo settings |

### Maintenance burden: **Medium**
- **Low** if you use template defaults, update gems periodically, run `bundle exec al-folio upgrade audit`
- **High** if you forked/customized layouts (user has local `_includes`, `_layouts` — v1 upgrade will surface override drift)
- Ruby/Jekyll ecosystem is mature but niche; fewer contributors than JS frameworks

**Confidence:** HIGH (verified via al-folio releases, BOUNDARIES.md, user's repo)

---

## Option 2: Sphinx + Furo

### Core Framework
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Sphinx | 7.x / 8.x | Documentation generator | Python ecosystem standard |
| Furo | latest (PyPI) | HTML theme | Clean, responsive, customizable; 3.5K stars |
| MyST Parser | latest | Markdown support | Sphinx defaults to reStructuredText; MyST fixes this |
| myst-nb | optional | Jupyter notebook pages | Notebook rendering in docs |

### Fit assessment
| Use case | Fit |
|----------|-----|
| API / project documentation | **Excellent** |
| Tutorial / research notes | **Good** |
| CV with structured sections | **Poor** — manual RST/MD, no academic theme |
| BibTeX publication list | **Poor** — no `jekyll-scholar` equivalent; needs custom extension or manual |
| Blog / news | **Mediocre** — possible via ablog extension, not idiomatic |
| Interactive landing page | **Poor** — docs sidebar UX, not portfolio UX |

### Deployment
- GitHub Pages: **Good** — requires GHA workflow (`sphinx-build` → `peaceiris/actions-gh-pages`)
- Read the Docs: **Excellent** if docs-heavy
- Build: Python venv + `pip install -r requirements.txt`; no native GitHub Pages integration (unlike Jekyll)

### Ease of updates
- Content: edit `.rst` or `.md` files; rebuild required for all changes
- Publications: no automated Google Scholar / bibtex pipeline out of the box
- Theming: Furo CSS variables in `conf.py`; less visual polish for "personal brand" than al-folio

**Confidence:** HIGH (Furo docs, Sphinx ecosystem comparisons, federico-trotta portfolio example)

---

## Option 3: Independent Custom Site

### Recommended: Astro 5 + React islands
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| Astro | 5.x | Static site + partial hydration | Zero JS by default; islands for demos; content collections |
| React / Svelte | 19 / latest | Interactive demo components | `client:visible` lazy hydration |
| TypeScript | 5.x | Type safety | Standard for demo-heavy sites |
| MDX | via Astro | Project write-ups | Content + components in one file |
| Tailwind CSS | v4 | Styling | Fast iteration, matches modern portfolio aesthetic |

### Alternative: Next.js 15
| When to choose | Reason |
|----------------|--------|
| Need SSR, auth, API routes in same repo | App Router + Server Actions |
| Team already deep in React ecosystem | Familiar patterns |
| Heavy client-side app pages | Full hydration acceptable |

**For content-first academic portfolio with demo islands, Astro wins** on bundle size (~0–9 KB vs 100–400+ KB JS), Lighthouse scores, and hosting cost. Next.js is overkill unless demos need server-side compute.

### Real-world reference patterns
- **research.mels.ai/ide**: Custom browser app (WebGL/physics engine), not an SSG — demonstrates that **full interactive labs require a separate app**, embeddable via iframe or subdomain
- **mateokadiu.pages.dev**: Astro 5 + React islands + r3f; bento-grid of live mini-demos
- **polcasacubertagil.com**: Astro 5 + 20 React demos on GitHub Pages

### Cost / complexity
| Aspect | al-folio | Astro custom |
|--------|----------|--------------|
| Initial setup | Hours | Days–weeks |
| Per-demo cost | High friction | 1 component per demo |
| Ongoing maintenance | Gem upgrades | npm dep updates |
| Hosting cost | $0 (GitHub Pages) | $0 (same hosts) |
| Build time | 1–5 min (Ruby) | 30s–2 min |

**Confidence:** HIGH for Astro recommendation (official docs, multiple 2026 portfolio examples); MEDIUM for comparative perf numbers (independent benchmarks, not controlled)

---

## Hosting Stack

| Platform | Cost | Best for | Limits (free tier) |
|----------|------|----------|-------------------|
| **GitHub Pages** | $0 | al-folio, Sphinx, Astro static | 100 GB/mo bandwidth, 10 min build timeout, 1 GB site |
| **Cloudflare Pages** | $0 | High-traffic static | **Unlimited bandwidth**; 500 build min/mo |
| **Netlify** | $0 | Preview deploys, forms, edge functions | 100 GB/mo, 300 build min/mo |
| **Vercel** | $0 | Next.js, preview deploys | 100 GB/mo, 6000 build min/mo |
| **Custom domain** | ~$10–15/yr | All above | DNS at registrar; free SSL on all hosts |

**Recommendation:** GitHub Pages if already on `*.github.io` and traffic is modest. Add Cloudflare Pages or Cloudflare CDN in front if bandwidth becomes a concern. Use Vercel only if adopting Next.js with SSR/API needs.

---

## Installation (if choosing Astro greenfield)

```bash
npm create astro@latest my-site -- --template minimal
cd my-site
npx astro add react tailwind mdx
npm install
npm run dev
```

Deploy to GitHub Pages:
```bash
npm install -D @astrojs/github-pages
# astro.config.mjs: output: 'static', site: 'https://username.github.io'
```

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Academic SSG | al-folio | Academic Pages, Hugo Academic | al-folio has richest feature set + community |
| Docs SSG | Sphinx+Furo | MkDocs Material, Docusaurus | Sphinx if Python-centric; Docusaurus if React team |
| Custom SSG | Astro | Next.js, Gatsby | Next.js heavier; Gatsby declining |
| Hosting | GitHub Pages | WordPress | WP overkill, security burden, not static |

---

## Sources

- [al-folio GitHub](https://github.com/alshedivat/al-folio) — v1.0 release notes, v0.16.3 (Jan 2026)
- [al-folio BOUNDARIES.md / CUSTOMIZE.md](https://github.com/alshedivat/al-folio/blob/main/docs/BOUNDARIES.md)
- [al-folio-upgrade CLI](https://github.com/al-org-dev/al-folio-upgrade)
- [Furo documentation](https://pradyunsg.me/furo/)
- [GitHub Pages limits](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)
- [Astro islands architecture](https://docs.astro.build/en/concepts/islands/)
- User repo: `/home/jeel/jeelchatrola.github.io` (pre-v1 al-folio, Jekyll 4.3.2)
