# Isolate secrets in 90_VAULT while symlinking Johnny Decimal areas into gdrive

2026-11-23

Symlink `00_INBOX` through `80_ARCHIVE` into `70_BACKUP/longden/gdrive` from Termux `$HOME` and every `proot-distro` `/root`, while keeping `90_VAULT` (`chmod 700` dirs, `chmod 600` keys) strictly outside `gdrive`. Symlink active SSH/ADB keys back into `55_INFRA/dotfiles/` and `source` tokens such as `gh_pat_token.env` conditionally so cloud sync never leaks credentials.

Initialize `90_VAULT` on a local-only branch (`vault-local`) with zero remotes and an inclusive `*` `.gitignore` tracking only `.gitignore` and metadata-only `VAULT_INDEX.md`, and push-lock reference index repos with `git remote set-url --push <remote> DISABLED-LOCAL-ONLY`.
