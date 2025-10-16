# ⚠️ This repository has been archived(2025/10/16).
Since it seems that the Windows version of Zed has finally been released, this repository will be archived.

The official installer can be found here:
https://zed.dev/download

If you still need to build it manually on Windows, please fork this repository.

# Unofficial release builds of Zed for Windows

Only release versions are included, and pre-release versions may not be included.

builds:
[https://github.com/MuNeNICK/zed-for-windows/releases](https://github.com/MuNeNICK/zed-for-windows/releases)

# Build Types
- ZedInstaller-{version}.exe

This is the installer. You can install Zed to any location by following the installation wizard.

- zed-{version}.zip

This is the standalone executable of Zed. You can run the extracted executable directly after unzipping.

## Is it safe?

This repository is just a [simple GitHub workflow](./.github/workflows/build.yml) that builds Zed from `main` and publishes a release every night at UTC+0000. (Additionally on push for testing).

See the [Zed homepage](https://zed.dev/) or [official repository](https://github.com/zed-industries/zed) for more details.
