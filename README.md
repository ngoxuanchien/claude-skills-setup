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

Safe to re-run: any step that fails (e.g. already installed) prints a warning and the script continues.

## What it installs

**Marketplaces + plugins** (via `claude plugin`):

| Plugin | Marketplace |
|---|---|
| superpowers, frontend-design, code-review, code-simplifier, context7, playwright, github, swift-lsp, gopls-lsp | `anthropics/claude-plugins-official` |
| ecc | `affaan-m/ECC` |
| voltagent-qa-sec | `VoltAgent/awesome-claude-code-subagents` |
| claude-obsidian | `AgriciDaniel/claude-obsidian` |
| diagram-design | `cathrynlavery/diagram-design` |
| logo-design | `kaankiziltug/logo-design-skill` |
| ponytail | `DietrichGebert/ponytail` |

**Standalone skills:**

- `find-skills` (`vercel-labs/skills`) and `orchestration` (`stablyai/orca`), installed globally via `npx skills`
- `open-code-review-delegate`: clones `alibaba/open-code-review` into `~/.local/share/open-code-review` and symlinks the skill into `~/.claude/skills/`

**Coding guidelines:**

- [Karpathy-style `CLAUDE.md`](https://github.com/multica-ai/andrej-karpathy-skills/blob/main/CLAUDE.md), appended to `~/.claude/CLAUDE.md` (user) or `./CLAUDE.md` (project). Existing content is kept; skipped if already present.

## Manual steps

- **agent-reach**: see https://github.com/Panniantong/Agent-Reach
- **cua-driver**: the skill ships with cua-driver (`~/.cua-driver/skills/cua-driver`)
- **collab-canvas**: copy `~/.claude/skills/collab-canvas` and its CLI from `~/.local/bin/` on the old machine

Restart Claude Code after installing so the plugins are loaded.
