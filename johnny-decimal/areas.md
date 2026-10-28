# The home areas are the Johnny Decimal system

2026-10-26

These directories live in the Termux home and are linked from `/root`. New files go in one of them.

| Directory | What goes here |
|---|---|
| `00_INBOX` | Landing zone. Sort it. |
| `10_DEV` | Code. One directory per project. |
| `20_MEDIA` | Media you made. |
| `30_DOCS` | Notes and references. |
| `40_BUSINESS` | Business paperwork. The eBay shop is `40_BUSINESS/ebay/`. |
| `50_OPS` | sshd, wake-lock, Termux:X11, and the scripts that keep them up. |
| `55_INFRA` | Dotfiles and config you would copy onto a new phone. |
| `60_TEMPLATES` | Reusable templates. |
| `70_BACKUP` | Small dated backups. |
| `80_ARCHIVE` | Cold storage. The rootfs tarball is `80_ARCHIVE/debian.tar`. |
| `90_VAULT` | Secrets. Mode 700. |
| `91_OBSIDIAN` | Obsidian vaults. One child folder per vault. Added 2026-10-27. |

A category inside an area is `AC_name`. `10_DEV/11_PROJECTS` is category 11. Do not nest another `00_INBOX` inside a project. A new top-level area needs a number, a row in this table, and a `/root` symlink.
