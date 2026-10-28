# Offline GGUF inference with hf download and llama-cli

2026-10-20

Download a single GGUF quantization for offline `llama.cpp` inference without pulling the entire repository using `hf download LiquidAI/LFM2.5-1.2B-Instruct-GGUF --include LFM2.5-1.2B-Instruct-Q4_K_M.gguf`.

The `698 MiB` model caches under `/root/.cache/huggingface/hub/` and runs locally via `llama-cli -m <snapshot-path> -c 2048 -t 4 -cnv`.
