# Termux X11 recovery flags and Turnip vs VirGL GPU acceleration

2026-11-23

When `termux-x11 :0` renders a black screen with a cursor, pass `-legacy-drawing` to bypass `AHardwareBuffers`; pass `-force-bgra` for inverted colors, `-disable-gpu-present` for flicker, `-ac` for local PRoot clients, and `-disable-dri3` when running software Vulkan (`lavapipe`).

For 3D acceleration, Snapdragon Adreno GPUs use Turnip + Zink (`pkg install mesa-vulkan-icd-freedreno` with `GALLIUM_DRIVER=zink`), while Mali and `proot-distro` guests can forward OpenGL ES through `virgl_test_server_android &` on the Termux host with `proot-distro login <guest> --shared-tmp` and `GALLIUM_DRIVER=virpipe`.
