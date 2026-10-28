# Find the Termux SSH host after a DHCP change with Python connect_ex

2026-10-26

Inside this Kali PRoot container, a bash `/dev/tcp` subnet sweep prints nothing when scanning for the phone's `sshd` on port `8022`.

Use a Python `socket.connect_ex((ip, 8022))` sweep across `192.168.0.0/24` to locate the phone, then update `HostName` under `Host termux` in `~/.ssh/config` (`/root/55_INFRA/dotfiles/.ssh/config`).
