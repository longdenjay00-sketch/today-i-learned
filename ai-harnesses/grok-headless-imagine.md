# Run Grok in headless mode with GenerateImage for 16:9 hero banners

2026-10-28

Grok Build can execute non-interactively from scripts or another agent harness via `grok --always-approve -p "<prompt>"`.

Passing an explicit file-save prompt to headless Grok invokes its `GenerateImage` (`image_gen`) tool and writes 16:9 (`1280x720`) hero assets directly to disk without launching the fullscreen TUI.
