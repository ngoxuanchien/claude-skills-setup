#!/usr/bin/env bash
# Install the Claude Code plugins/skills from this machine onto a new one.
# Safe to re-run: steps that fail (already installed, etc.) are reported and skipped.
set -u

run() { echo "+ $*"; "$@" || echo "  ! failed: $*"; }

marketplaces=(
  anthropics/claude-plugins-official
  https://github.com/affaan-m/ECC.git
  VoltAgent/awesome-claude-code-subagents
  AgriciDaniel/claude-obsidian
  cathrynlavery/diagram-design
  kaankiziltug/logo-design-skill
  DietrichGebert/ponytail
)

plugins=(
  superpowers@claude-plugins-official
  frontend-design@claude-plugins-official
  code-review@claude-plugins-official
  code-simplifier@claude-plugins-official
  context7@claude-plugins-official
  playwright@claude-plugins-official
  github@claude-plugins-official
  swift-lsp@claude-plugins-official
  gopls-lsp@claude-plugins-official
  ecc@ecc
  voltagent-qa-sec@voltagent-subagents
  claude-obsidian@agricidaniel-claude-obsidian
  diagram-design@diagram-design
  logo-design@logo-design-skill
  ponytail@ponytail
)

for m in "${marketplaces[@]}"; do run claude plugin marketplace add "$m"; done
for p in "${plugins[@]}"; do run claude plugin install "$p"; done

# Standalone skills (skills CLI)
run npx -y skills add vercel-labs/skills --skill find-skills
run npx -y skills add stablyai/orca --skill orchestration

# open-code-review-delegate: clone + symlink
ocr="$HOME/.local/share/open-code-review"
[ -d "$ocr" ] || run git clone https://github.com/alibaba/open-code-review.git "$ocr"
mkdir -p "$HOME/.claude/skills"
run ln -sfn "$ocr/skills/open-code-review-delegate" "$HOME/.claude/skills/open-code-review-delegate"

cat <<'EOF'

Done. Manual steps remaining:
  - agent-reach:   follow https://github.com/Panniantong/Agent-Reach (or copy ~/.claude/skills/agent-reach)
  - cua-driver:    install cua-driver; skill lives at ~/.cua-driver/skills/cua-driver
  - collab-canvas: source unknown; copy ~/.claude/skills/collab-canvas and its CLI from ~/.local/bin/
EOF
