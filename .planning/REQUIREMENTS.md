# Requirements — jeelchatrola.github.io v1 Milestone

**Coverage:** 11 requirements | 11 satisfied | 0 pending

## Must

| ID | Requirement | Phase | Status |
|----|-------------|-------|--------|
| TOOL-01 | Bootstrap and commit Gemfile.lock before Docker build | 01 | Satisfied |
| TOOL-02 | Gemfile v1 + Docker toolchain as atomic step | 01 | Satisfied |
| MIG-01 | Remove duplicate `_plugins/*.rb` | 02 | Satisfied |
| MIG-02 | Migrate CSS to v1 Tailwind entry | 02 | Satisfied |
| MIG-03 | Fix broken CV config (`jekyll_get_json` / `jsonresume`) | 03 | Satisfied |

## Should

| ID | Requirement | Phase | Status |
|----|-------------|-------|--------|
| MIG-04 | Reconcile override drift (layouts, includes, sass, distillpub JS) | 02 | Satisfied |
| CI-01 | Update deploy.yml (drop mermaid.cli, pin nbconvert) | 04 | Satisfied |
| CI-02 | Pin Ruby 3.2.2 via `.ruby-version` + `ruby:3.2-slim` | 01 | Satisfied |
| SPEC-01 | Design spec with Tailwind visual delta approval | 00 | Satisfied |
| CONTENT-01 | Full content refresh (about, cv, papers, projects, news, repos) | 05 | Satisfied |

## Nice (deferred)

| ID | Requirement | Phase | Status |
|----|-------------|-------|--------|
| DEMO-01 | Optional per-project interactive demos | — | Deferred |
