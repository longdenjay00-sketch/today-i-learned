# /root has no loose files

2026-10-26

`ls /root` shows the numbered areas and `dotfiles`. `91_OBSIDIAN` is the Obsidian area, symlinked like the others. Notes, scripts, and the editor CLI are not linked from `/root` anymore.

`AGENTS.md` and `LAYOUT.md` are real files in `30_DOCS`. The sshd one-liner `ssb` is in `50_OPS/ssb`. `code` is `55_INFRA/code`. `vscode_cli.tar.gz` is in `70_BACKUP`.
