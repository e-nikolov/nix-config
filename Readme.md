# Bootstrap

Minimal flake:

```sh
sh <(curl https://e-nikolov.github.io/nix-bootstrap)
```

Complete setup for all of my personal machines that uses flakes, home-manager and NixOS:

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
- https://nix.dev/tutorials/nix-language                - nix language overview


# Gotchas

- you can only install user-level services via home-manager. For system-level services that require root (e.g. docker, tailscale), you either need to switch to NixOS/nix-darwin or install them via your OS's package manager
- some packages require extra setup and are installed via something like `programs.git.enable = true`. Check https://rycee.gitlab.io/home-manager/options.html
- The Nix language can be counterintuitive and deceptive - https://nix.dev/tutorials/nix-language is a good starting point.
In short, it's a functional language inspired by Haskell that is essentially json/yaml with functions.
    - Attribute sets - similar to object/map/json structure
```nix
{
    a = {
        b = {
            c = "d";
        };
    };
}

```
is equivalent to
```nix
{ a.b.c = "d"; }
```
- Function definitions - the following is a function `f` with 3 arguments `a`, `b`, `c` that returns their sum:

```nix
{f = a: b: c: a + b + c; }
```
- Function calls - `x` will have the resulting value of calling the function f with arguments 1 2 and 3
```nix
{x = f 1 2 3; }
```
- sometimes calling a function with arguments has lower priority than other operations around it, so the arguments would have to be surrounded with parentheses:
```nix
{x = [(f 1 2 3) (f 3 4 5)]; }
```
- calling a function with an attribute set as an argument:

```nix
{
    x = doSomething {
        a = 1;
        b = 2;
        c = 3;
    };
}
```
To the untrained eye, this might look like a function definition, but it's actually a call of the function doSomething with an attribute set argument.
