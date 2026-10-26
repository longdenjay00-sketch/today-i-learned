# The three-letter directory names are gone

2026-10-26

`INB`, `DEV`, `MED`, `DOC`, `BUS`, `OPS`, `BAK`, `ARC`, `VAU`, `TEM`, `PRO`, `OUT`, and `INF` are not on the home listing. Their contents were moved, then the short names were removed.

| Was | Now |
|---|---|
| `INB` | `00_INBOX` |
| `DEV` | `10_DEV` |
| `MED` and finished clips that were in `OUT` | `20_MEDIA` |
| `DOC` | `30_DOCS` |
| `BUS` | `40_BUSINESS` |
| `OPS` | `50_OPS` |
| `INF` and the dotfiles directory | `55_INFRA` |
| `BAK` | `70_BACKUP` |
| `ARC` | `80_ARCHIVE` |
| `VAU` | `90_VAULT` |

`TEM` was scratch, not templates. `~/bin` was removed. `~/.local/bin` is on the Termux bash `PATH`.
