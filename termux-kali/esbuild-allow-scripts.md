# Allow esbuild postinstall scripts under npm 12 on aarch64

2026-10-24

When npm 12 blocks the `esbuild` postinstall script via `allowScripts`, Vite and bundler installs can fail if the native binary is not linked.

Re-enable it for the user profile with `npm config set allow-scripts=esbuild --location=user` or per-install with `npm install -g --allow-scripts=esbuild`.
