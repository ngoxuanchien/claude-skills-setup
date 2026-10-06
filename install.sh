#!/usr/bin/env bash
# Install the Claude Code plugins/skills from this machine onto a new one.
# Safe to re-run: steps that fail (already installed, etc.) are reported and skipped.
# Usage: install.sh [user|project]   (default: user; project = current directory)
set -u

scope="${1:-user}"
case "$scope" in
  user)    skills_flag=-g;  skills_dir="$HOME/.claude/skills" ;;
  project) skills_flag=;    skills_dir="$PWD/.claude/skills" ;;
  *) echo "usage: $0 [user|project]" >&2; exit 1 ;;
esac

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

for m in "${marketplaces[@]}"; do run claude plugin marketplace add --scope "$scope" "$m"; done
for p in "${plugins[@]}"; do run claude plugin install --scope "$scope" "$p"; done

# Standalone skills (skills CLI)
run npx -y skills add vercel-labs/skills --skill find-skills $skills_flag -y
run npx -y skills add stablyai/orca --skill orchestration $skills_flag -y

# open-code-review-delegate: clone, then symlink (user) or copy (project, so the repo stays portable)
ocr="$HOME/.local/share/open-code-review"
[ -d "$ocr" ] || run git clone https://github.com/alibaba/open-code-review.git "$ocr"
mkdir -p "$skills_dir"
if [ "$scope" = user ]; then
  run ln -sfn "$ocr/skills/open-code-review-delegate" "$skills_dir/open-code-review-delegate"
else
  run cp -R "$ocr/skills/open-code-review-delegate" "$skills_dir/"
fi

# Karpathy-style coding guidelines: append to CLAUDE.md (never overwrite), skip if already there
claude_md="$HOME/.claude/CLAUDE.md"; [ "$scope" = project ] && claude_md="$PWD/CLAUDE.md"
karpathy_url=https://raw.githubusercontent.com/multica-ai/andrej-karpathy-skills/main/CLAUDE.md
if grep -qs "reduce common LLM coding mistakes" "$claude_md"; then
  echo "+ $claude_md already has Karpathy guidelines, skipping"
elif guidelines=$(curl -fsSL "$karpathy_url"); then
  mkdir -p "$(dirname "$claude_md")"
  [ -s "$claude_md" ] && printf '\n\n' >> "$claude_md"
  printf '%s\n' "$guidelines" >> "$claude_md"
  echo "+ added Karpathy guidelines to $claude_md"
else
  echo "  ! failed: download $karpathy_url"
fi

cat <<'EOF'

Done. Manual steps remaining:
  - agent-reach:   follow https://github.com/Panniantong/Agent-Reach (or copy ~/.claude/skills/agent-reach)
  - cua-driver:    install cua-driver; skill lives at ~/.cua-driver/skills/cua-driver
  - collab-canvas: source unknown; copy ~/.claude/skills/collab-canvas and its CLI from ~/.local/bin/
EOF
