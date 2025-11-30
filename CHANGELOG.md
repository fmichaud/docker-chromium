# Changelog

## v0.2.0

- Updated `README.md` to include comprehensive `podman run` command details, covering security options, audio/video support, volume persistence for profiles, mounting the downloads directory, and setting initial URLs via environment variables.
- Corrected the language in `README.md` for the downloads directory mount example from French to English.
- Modified GitHub Actions workflows (`.github/workflows/build-image.yml` and `.github/workflows/publish-image.yml`) to remove the 'docker-' prefix from the generated image names, ensuring cleaner naming conventions.

## v0.1.0

- Initial release: Provides a containerized Chromium browser with X11 forwarding capabilities, compatible with Docker and Podman.
- Added `README.md` with prerequisites, usage instructions, and build steps.
- Included `LICENSE` file (MIT License).
