# bazznix

Nix modules for a SteamOS-like experience on handhelds and gaming PCs. The goal is to incorporate many of the features of Bazzite, but on a NixOS base.

## Installation

You can install bazznix using the installer ISO that is automatically built and attached to each [GitHub release](https://github.com/thesomewhatyou/bazznix/releases). The ISO includes all necessary tools and configurations for installing bazznix on your system.

## Building

To build the installer ISO locally:
```bash
nix build .#nixosConfigurations.installer.config.system.build.isoImage
```
