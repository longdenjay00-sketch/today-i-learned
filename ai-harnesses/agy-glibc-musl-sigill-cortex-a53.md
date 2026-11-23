# Run glibc agy in musl PRoot guests to avoid Cortex-A53 SIGILL

2026-11-23

The official static `linux-arm64` musl build of `agy` crashes with `SIGILL` on older ARMv8.0 cores (Cortex-A53/A73 without LSE atomics), whereas the glibc binary at `/opt/agy/agy` runs across Alpine, Arch Linux ARM, Debian/Kali, Ubuntu, and Void PRoot containers.

Because `agy` detects `/lib/ld-musl-aarch64.so.1` or `/lib/libc.musl-aarch64.so.1` as a musl machine, wrap `/usr/local/bin/agy` with `export AGY_CLI_DISABLE_AUTO_UPDATE=1` on musl guests so auto-updates do not overwrite it, and handle Void's `/lib -> usr/lib` symlink by placing the glibc loader link in `/usr/lib/ld-linux-aarch64.so.1` or invoking `/opt/agy/glibc/ld-linux-aarch64.so.1 --library-path /opt/agy/glibc /opt/agy/agy "$@"`.
