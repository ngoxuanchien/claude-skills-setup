#!/usr/bin/env bash
# Install the Claude Code plugins/skills from this machine onto a new one.
# Safe to re-run: steps that fail (already installed, etc.) are reported and skipped.
# Usage: install.sh [user|project] [name ...]   (default: user, everything)
#        install.sh --list                      (show selectable names)
# project = current directory; names pick a subset, e.g. install.sh superpowers ponytail karpathy
set -u

# name  plugin@marketplace  marketplace-source
plugins=(
  "superpowers      superpowers@claude-plugins-official      anthropics/claude-plugins-official"
  "frontend-design  frontend-design@claude-plugins-official  anthropics/claude-plugins-official"
  "code-review      code-review@claude-plugins-official      anthropics/claude-plugins-official"
  "code-simplifier  code-simplifier@claude-plugins-official  anthropics/claude-plugins-official"
  "context7         context7@claude-plugins-official         anthropics/claude-plugins-official"
  "playwright       playwright@claude-plugins-official       anthropics/claude-plugins-official"
  "github           github@claude-plugins-official           anthropics/claude-plugins-official"
  "swift-lsp        swift-lsp@claude-plugins-official        anthropics/claude-plugins-official"
  "gopls-lsp        gopls-lsp@claude-plugins-official        anthropics/claude-plugins-official"
  "ecc              ecc@ecc                                  https://github.com/affaan-m/ECC.git"
  "voltagent-qa-sec voltagent-qa-sec@voltagent-subagents     VoltAgent/awesome-claude-code-subagents"
  "claude-obsidian  claude-obsidian@agricidaniel-claude-obsidian AgriciDaniel/claude-obsidian"
  "diagram-design   diagram-design@diagram-design            cathrynlavery/diagram-design"
  "logo-design      logo-design@logo-design-skill            kaankiziltug/logo-design-skill"
  "ponytail         ponytail@ponytail                        DietrichGebert/ponytail"
)
extras="find-skills open-code-review-delegate karpathy"

all_names="$extras"
for line in "${plugins[@]}"; do all_names="$all_names ${line%% *}"; done

if [ "${1:-}" = --list ]; then printf '%s\n' $all_names; exit 0; fi

scope=user
case "${1:-}" in user|project) scope=$1; shift ;; esac
case "$scope" in
  user)    skills_flag=-g;  skills_dir="$HOME/.claude/skills" ;;
  project) skills_flag=;    skills_dir="$PWD/.claude/skills" ;;
esac

selected="$*"
for n in $selected; do
  [[ " $all_names " == *" $n "* ]] || { echo "unknown name: $n (see $0 --list)" >&2; exit 1; }
done
want() { [ -z "$selected" ] || [[ " $selected " == *" $1 "* ]]; }

run() { echo "+ $*"; "$@" || echo "  ! failed: $*"; }

added=" "
for line in "${plugins[@]}"; do
  read -r name plugin source <<<"$line"
  want "$name" || continue
  if [[ "$added" != *" $source "* ]]; then
    run claude plugin marketplace add --scope "$scope" "$source"; added="$added$source "
  fi
  run claude plugin install --scope "$scope" "$plugin"
done

# Standalone skills (skills CLI)
want find-skills   && run npx -y skills add vercel-labs/skills --skill find-skills $skills_flag -y

# open-code-review-delegate: clone, then symlink (user) or copy (project, so the repo stays portable)
if want open-code-review-delegate; then
  ocr="$HOME/.local/share/open-code-review"
  [ -d "$ocr" ] || run git clone https://github.com/alibaba/open-code-review.git "$ocr"
  mkdir -p "$skills_dir"
  if [ "$scope" = user ]; then
    run ln -sfn "$ocr/skills/open-code-review-delegate" "$skills_dir/open-code-review-delegate"
  else
    run cp -R "$ocr/skills/open-code-review-delegate" "$skills_dir/"
  fi
fi

# Karpathy-style coding guidelines: append to CLAUDE.md (never overwrite), skip if already there
claude_md="$HOME/.claude/CLAUDE.md"; [ "$scope" = project ] && claude_md="$PWD/CLAUDE.md"
karpathy_url=https://raw.githubusercontent.com/multica-ai/andrej-karpathy-skills/main/CLAUDE.md
if ! want karpathy; then
  :
elif grep -qs "reduce common LLM coding mistakes" "$claude_md"; then
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
