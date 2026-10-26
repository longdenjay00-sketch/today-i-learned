# Kali dotfiles live in 55_INFRA

2026-10-26

The live Kali dotfiles are `55_INFRA/dotfiles/`. `/root/dotfiles` is a symlink to that directory.

`/root/.bashrc`, `/root/.ssh`, `/root/.git`, and the other hidden names are also links into `55_INFRA/dotfiles/`. Leave those links. The shell, SSH, and git need them.

Older copies in the same area are `termux-dotfiles`, `dotfiles-from-dev`, `dotfiles-from-inbox`, and `kali-dotfiles`.
