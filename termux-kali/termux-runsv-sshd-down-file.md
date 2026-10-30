# Termux runsv keeps sshd stopped when a down trigger file is present

2026-10-30

When `runsvdir` supervises Termux services (`$PREFIX/var/service`), a service will remain stopped if a file named `down` exists in its service directory: `/data/data/com.termux/files/usr/var/service/sshd/down`. Even if `runsv sshd` and `svlogd` processes appear in `ps`, the actual daemon does not spawn.

Clear the down state or start the service with `sv-enable sshd` or `SVDIR=/data/data/com.termux/files/usr/var/service sv up sshd`, and inspect local Wi-Fi addresses via `ip addr show wlan0` to detect DHCP lease changes before connecting.
