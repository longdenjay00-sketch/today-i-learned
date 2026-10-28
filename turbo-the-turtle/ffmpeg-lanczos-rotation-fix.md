# Re-encode upside-down phone video clips in ffmpeg to bake rotation

2026-10-24

Phone clips recorded with a `-180°` display matrix (such as `baby-fishey-dance-magic-show.mp4`) can open upside down in raw frame tools unless re-encoded so the rotation metadata is baked into the pixel stream.

`10_DEV/turtle_edit/turtle_youtube.py` compiles, pads (`1920x1080`), and scales Turbo the Turtle and Fishy clips using `ffmpeg` Lanczos without requiring an AI upscaler.
