# Chromium in a Container

This project provides a simple way to run a sandboxed Chromium browser within a container, forwarding its display to your local X11 server.

## Prerequisites

Before you begin, ensure you have the following installed on your host machine:

-   A container runtime such as [Docker](https://www.docker.com/) or [Podman](https://podman.io/). The commands below are interchangeable.
-   An X11 server (e.g., X.Org) running.
-   The `xhost` command-line tool, which is typically included with X11 installations.

## Usage

1.  **Allow local connections to your X server:**
    Open a terminal on your host machine and run the following command. This temporarily allows containers to connect to your X11 display.

    ```bash
    xhost +local:
    ```

2.  **Run the Chromium container:**
    Use either `podman` or `docker`. The command pulls the image `ghcr.io/fmichaud/chromium:0.2.0` and starts Chromium.

    ```bash
    # Using Docker
    docker run -it --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        docker.io/fmichaud/chromium:0.1.0

        # Using Podman
        podman run --rm -it \
            --name teams_main \
            --security-opt seccomp=./seccomp-chromium-base.json \
            -e DISPLAY=$DISPLAY \
            -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
            -e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native \
            -v $XDG_RUNTIME_DIR/pulse/native:$XDG_RUNTIME_DIR/pulse/native \
            --device /dev/dri \
            --device /dev/video0 \
            -v teams_profile:/home/appuser/.config/chromium \
            -v "$HOME/Downloads:/home/appuser/Downloads:rw" \
            -e URL_TAB1="https://teams.microsoft.com/" \
            -e URL_TAB2="https://outlook.office.com/mail/" \
            ghcr.io/fmichaud/chromium:alpine
    ```
        
        **Command breakdown:**
        -   `-it`: Runs the container in interactive mode.
        -   `--rm`: Automatically removes the container when it exits.
        -   `--name teams_main`: Assigns a name to the container, making it easier to reference.
        -   `--security-opt seccomp=./seccomp-chromium-base.json`: Applies a custom seccomp profile for enhanced security.
        -   `-e DISPLAY=$DISPLAY`: Forwards the `DISPLAY` environment variable to the container, enabling graphical output.
        -   `-v /tmp/.X11-unix:/tmp/.X11-unix:ro`: Mounts the X11 socket into the container as read-only, allowing the container to display graphical applications.
        -   `-e PULSE_SERVER=unix:$XDG_RUNTIME_DIR/pulse/native`: Configures PulseAudio server for audio forwarding.
        -   `-v $XDG_RUNTIME_DIR/pulse/native:$XDG_RUNTIME_DIR/pulse/native`: Mounts the PulseAudio socket for audio support.
        -   `--device /dev/dri`: Grants access to the host's DRI (Direct Rendering Infrastructure) devices for hardware acceleration.
        -   `--device /dev/video0`: Grants access to the host's video devices (e.g., webcam).
        -   `-v teams_profile:/home/appuser/.config/chromium`: **Volume for Profile Persistence.** This mounts a named volume `teams_profile` to `/home/appuser/.config/chromium` inside the container. This ensures that your browser profile data (settings, extensions, cache, etc.) persists across container runs.
        -   `-v "$HOME/Téléchargements:/home/appuser/Downloads:rw"`: Mounts your host's `Downloads` directory into the container, allowing files downloaded within the container to be accessible on your host.
        -   `-e URL_TAB1="..."`, `-e URL_TAB2="..."`: Sets environment variables to open specific URLs in different tabs when the browser starts.
    3.  **(Optional but recommended) Revoke access:**
    Once you are done, it's good practice to revoke the access you granted in step 1.

    ```bash
    xhost -local:
    ```

## Build

To build the container image from the `Containerfile` in the root of the project, you can use the following commands.

Choose a tag for your image, for example `fmichaud/chromium:latest`.

```bash
# Using Docker
docker build -t fmichaud/chromium:latest .

# Using Podman
podman build -t fmichaud/chromium:latest .
```

## License

This project is licensed under the MIT License.
