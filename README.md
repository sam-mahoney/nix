# Nix

nix configurations for my machines, using Nix Flakes.

## Structure

`flake.nix` : The entrypoint for the configuration, defines inputs and outputs for NixOS, nix-darwin & Home Manager.

`machines/` : Individual NixOS and nix-darwin system configuration

`homemgr/` : Home Manager configuration

`etc/` : Miscellaneous conifguration files and scripts for various applications and services

`modules/` : Reusable platform-specific modules

`overlays/`

## Key Inputs

TODO

## Usage

TODO: initial install...

<https://github.com/DeterminateSystems/nix-installer>

Select `no` when asked if you want to use the special determine version

Install `brew`

disable `brew` analytics

```(bash)
brew analytics off
```

```bash
nix run nix-darwin --switch --flake .#system
```

```bash
nix-shell -p home-manager
home-manager switch --flake .#user@system
```


```(bash)
nix flake update
```

```(bash)
darwin-rebuild switch --flake .#halcyon
```

```(bash)
nix-shell -p home-manager
home-manager switch --flake .#mahoney@halcyon
```

## Nix things to remember

When using `imports = [ ./some/dir ];` the directory **must** contain a `default.nix` file. `default.nix` acts as an *entry point* and, therefore, is run when the dir is imported.

## Things to do

- Configure Home Manager for nix-darwin
- NixOS configuration
- Configuration
  - system
  - terminal & shell
  - dev tools
  - system utils
  - DE/UI
  - Application conf
  - Cloud
  - WM conf
- NixOS for offensive security
