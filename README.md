# claude-skills-setup

Script cài lại toàn bộ plugin và skill Claude Code của tôi trên máy mới.

## Cài đặt

Yêu cầu: đã cài [Claude Code](https://docs.claude.com/en/docs/claude-code) (`claude`), `git`, `node`/`npx`.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ngoxuanchien/claude-skills-setup/main/install.sh)
```

Hoặc clone về rồi chạy:

```bash
git clone https://github.com/ngoxuanchien/claude-skills-setup.git
bash claude-skills-setup/install.sh
```

Chạy lại nhiều lần không sao: bước nào lỗi (ví dụ đã cài rồi) chỉ in cảnh báo và đi tiếp.

## Script cài gì

**Marketplace + plugin** (qua `claude plugin`):

| Plugin | Marketplace |
|---|---|
| superpowers, frontend-design, code-review, code-simplifier, context7, playwright, github, swift-lsp, gopls-lsp | `anthropics/claude-plugins-official` |
| ecc | `affaan-m/ECC` |
| voltagent-qa-sec | `VoltAgent/awesome-claude-code-subagents` |
| claude-obsidian | `AgriciDaniel/claude-obsidian` |
| diagram-design | `cathrynlavery/diagram-design` |
| logo-design | `kaankiziltug/logo-design-skill` |
| ponytail | `DietrichGebert/ponytail` |

**Skill độc lập:**

- `find-skills` (`vercel-labs/skills`) và `orchestration` (`stablyai/orca`), cài global qua `npx skills`
- `open-code-review-delegate`: clone `alibaba/open-code-review` về `~/.local/share/open-code-review` rồi symlink vào `~/.claude/skills/`

## Cần cài tay

- **agent-reach**: xem https://github.com/Panniantong/Agent-Reach
- **cua-driver**: skill đi kèm khi cài cua-driver (`~/.cua-driver/skills/cua-driver`)
- **collab-canvas**: chép `~/.claude/skills/collab-canvas` và CLI trong `~/.local/bin/` từ máy cũ

Sau khi cài xong, khởi động lại Claude Code để nạp plugin.
