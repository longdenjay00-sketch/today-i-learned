# Bridge glibc agy into Termux via proot-distro login wrapper

2026-10-28

Because `/usr/local/bin/agy` inside the Kali rootfs is a `glibc` `aarch64` ELF executable (`/lib/ld-linux-aarch64.so.1`), it cannot execute directly under Termux's `bionic` libc.

Create `/root/50_OPS/agy-termux` (`chmod 755`) wrapping `proot-distro login debian --work-dir "$WORKDIR" -- /usr/local/bin/agy "$@"` and symlink it to `/data/data/com.termux/files/usr/bin/agy` so `agy` runs seamlessly from any Termux shell while preserving working directories under `/data/data/com.termux/files/home`.
