# Bootstrap

Minimal flake:

```sh
sh <(curl https://e-nikolov.github.io/nix-bootstrap)
```

My full setup that you'll have to edit manually:

```sh
sh <(curl https://e-nikolov.github.io/nix-bootstrap) --full
```


# Nix Resources

- https://search.nixos.org/                             - search for nix packages to install
- https://rycee.gitlab.io/home-manager/                 - home-manager manual
- https://rycee.gitlab.io/home-manager/options.html     - home-manager option docs
- https://nixos.org/manual/nixpkgs/unstable/            - nixpkgs manual
- https://nixos.org/manual/nixos/unstable/              - NixOS manual
- https://nixos.org/manual/nixos/unstable/options.html  - NixOS option docs
- https://nixos.wiki/                                   - NixOS community Wiki
- https://nixos.org/manual/nix/unstable/                - nix manual
- https://nix.dev/                                      - nix guides


# Gotchas

- you can only install user-level services via home-manager. For system-level services that require root (e.g. docker, tailscale), you either need to switch to NixOS/nix-darwin or install them via your OS's package manager
- some packages require extra setup and are installed via something like `programs.git.enable = true`. Check https://rycee.gitlab.io/home-manager/options.html
