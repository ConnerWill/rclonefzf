# rclonefzf Docker

<!--toc:start-->
- [rclonefzf Docker](#rclonefzf-docker)
  - [Build](#build)
  - [Run](#run)
    - [Interactive Shell](#interactive-shell)
    - [Run Directly](#run-directly)
  - [Testing AUR Package](#testing-aur-package)
<!--toc:end-->

## Build

Build docker image from root of the repo

```bash
cd $(git rev-parse --show-toplevel)
docker build --tag rclonefzf --file docker/Dockerfile .
```

## Run

### Interactive Shell

Run docker image from root of the repo

```bash
cd $(git rev-parse --show-toplevel)
docker run --rm --interactive --tty \
  --volume "${PWD}:/workspace" \
  --volume "${XDG_CONFIG_HOME:-${HOME}/.config}/rclone:/home/dev/.config/rclone:ro" \
  rclonefzf
```

Inside of container

```bash
rclonefzf
```

### Run Directly

```bash
cd $(git rev-parse --show-toplevel)
docker run --rm --interactive --tty \
  --volume "${PWD}:/workspace" \
  --volume "${XDG_CONFIG_HOME:-${HOME}/.config}/rclone:/home/dev/.config/rclone:ro" \
  rclonefzf rclonefzf
```

## Testing AUR Package

Test building package with `PKGBUILD` inside the container:

```bash
cd $(git rev-parse --show-toplevel)
docker run --rm --interactive --tty \
  --volume "${PWD}:/workspace" \
  --volume "${XDG_CONFIG_HOME:-${HOME}/.config}/rclone:/home/dev/.config/rclone:ro" \
  rclonefzf 'cd AUR/rclonefzf ; makepkg -si'
```
