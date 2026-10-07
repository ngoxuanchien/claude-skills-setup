# claude-skills-setup

Script to reinstall all my Claude Code plugins and skills on a new machine.

## Install

Requirements: [Claude Code](https://docs.claude.com/en/docs/claude-code) (`claude`), `git`, `node`/`npx`.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ngoxuanchien/claude-skills-setup/main/install.sh)
```

Or clone and run:

```bash
git clone https://github.com/ngoxuanchien/claude-skills-setup.git
bash claude-skills-setup/install.sh
```

### Project scope

By default everything is installed at user level (`~/.claude`). To install only into the current project instead, run from the project root and pass `project`:

```bash
cd /path/to/your-project
bash <(curl -fsSL https://raw.githubusercontent.com/ngoxuanchien/claude-skills-setup/main/install.sh) project
```

Plugins are then declared in `.claude/settings.json` and skills land in `.claude/skills/` (commit these so teammates get the same setup).

### Pick what to install

With no names, everything is installed. Pass names (after the optional scope) to install only those; marketplaces are added only as needed:

```bash
bash install.sh --list                                    # show selectable names
bash install.sh superpowers ponytail karpathy             # user scope, subset
bash install.sh project code-review context7 find-skills  # project scope, subset

# same via curl:
bash <(curl -fsSL https://raw.githubusercontent.com/ngoxuanchien/claude-skills-setup/main/install.sh) superpowers ponytail
```

Unknown names abort before anything is installed.

Safe to re-run: any step that fails (e.g. already installed) prints a warning and the script continues.

## What it installs

The **Name** column is what you pass to `install.sh` to select it.

**Plugins** (via `claude plugin`):

| Name | What it does | Marketplace |
|---|---|---|
| `superpowers` | Process skills: brainstorming, writing/executing plans, TDD, systematic debugging, code-review requests, verification before completion | `anthropics/claude-plugins-official` |
| `frontend-design` | Guidance for distinctive, non-templated UI design | `anthropics/claude-plugins-official` |
| `code-review` | `/code-review` of the current diff or a PR, with effort levels | `anthropics/claude-plugins-official` |
| `code-simplifier` | Agent that simplifies recently changed code without changing behavior | `anthropics/claude-plugins-official` |
| `context7` | MCP server for up-to-date library/framework docs | `anthropics/claude-plugins-official` |
| `playwright` | MCP server for browser automation (navigate, click, screenshot) | `anthropics/claude-plugins-official` |
| `github` | GitHub MCP server: issues, PRs, reviews, code search | `anthropics/claude-plugins-official` |
| `swift-lsp` | Swift language server for code intelligence | `anthropics/claude-plugins-official` |
| `gopls-lsp` | Go language server (gopls) for code intelligence | `anthropics/claude-plugins-official` |
| `ecc` | Everything Claude Code: large set of agents, skills, commands and hooks (language reviewers, build resolvers, TDD, planning, sessions…) | `affaan-m/ECC` |
| `voltagent-qa-sec` | QA & security subagents: code/security/architecture review, pen-testing, debugging, test automation | `VoltAgent/awesome-claude-code-subagents` |
| `claude-obsidian` | Build and maintain an Obsidian knowledge vault (ingest, query, lint, canvas) | `AgriciDaniel/claude-obsidian` |
| `diagram-design` | Branded architecture/flow/sequence/ER/chart diagrams as HTML/SVG/PNG; imports drawio/excalidraw/mermaid | `cathrynlavery/diagram-design` |
| `logo-design` | Logo design skill | `kaankiziltug/logo-design-skill` |
| `ponytail` | "Lazy senior dev" mode: minimal code, reuse first, no speculative abstractions; plus audit/review commands | `DietrichGebert/ponytail` |

**Standalone skills and extras:**

| Name | What it does | Source |
|---|---|---|
| `find-skills` | Discover and install agent skills ("is there a skill for X?") | `vercel-labs/skills` via `npx skills` |
| `orchestration` | Coordinate supervised Orca workers: task dispatch, DAGs, hand-offs across agents/worktrees | `stablyai/orca` via `npx skills` |
| `open-code-review-delegate` | Code review where OCR picks files/rules and Claude does the review. Cloned to `~/.local/share/open-code-review`; symlinked (user) or copied (project) into `.claude/skills/` | `alibaba/open-code-review` |
| `karpathy` | [Karpathy-style `CLAUDE.md` guidelines](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md), appended to `~/.claude/CLAUDE.md` (user) or `./CLAUDE.md` (project). Existing content is kept; skipped if already present | `multica-ai/andrej-karpathy-skills` |

## Manual steps

- **agent-reach**: see https://github.com/Panniantong/Agent-Reach
- **cua-driver**: the skill ships with cua-driver (`~/.cua-driver/skills/cua-driver`)
- **collab-canvas**: copy `~/.claude/skills/collab-canvas` and its CLI from `~/.local/bin/` on the old machine

Restart Claude Code after installing so the plugins are loaded.
