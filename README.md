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
    Use either `podman` or `docker`. The command pulls the image `docker.io/fmichaud/chromium:0.1.0` and starts Chromium.

    ```bash
    # Using Docker
    docker run -it --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        docker.io/fmichaud/chromium:0.1.0

    # Using Podman
    podman run -it --rm \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        docker.io/fmichaud/chromium:0.1.0
    ```
    
    **Command breakdown:**
    -   `-it`: Runs the container in interactive mode.
    -   `--rm`: Automatically removes the container when it exits.
    -   `-e DISPLAY=$DISPLAY`: Forwards the `DISPLAY` environment variable to the container.
    -   `-v /tmp/.X11-unix:/tmp/.X11-unix`: Mounts the X11 socket into the container.

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
