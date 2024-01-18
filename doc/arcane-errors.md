# Incorrect nixPath

```
warning: Git tree '/home/enikolov/nix-config' is dirty
building the system configuration...
warning: Git tree '/home/enikolov/nix-config' is dirty
error:
       … while calling the 'head' builtin

         at /nix/store/wl5m5xfayd69ycyspzyd4rilfgl6wmh0-source/lib/attrsets.nix:820:11:

          819|         || pred here (elemAt values 1) (head values) then
          820|           head values
             |           ^
          821|         else

       … while evaluating the attribute 'value'

         at /nix/store/wl5m5xfayd69ycyspzyd4rilfgl6wmh0-source/lib/modules.nix:800:9:

          799|     in warnDeprecation opt //
          800|       { value = builtins.addErrorContext "while evaluating the option `${showOption loc}':" value;
             |         ^
          801|         inherit (res.defsFinal') highestPrio;

       (stack trace truncated; use '--show-trace' to show the full trace)

       error: cannot coerce a set to a string
```

Caused by setting nix.nixPath = ["nixpkgs=${inputs.nixpkgs.outPath}" "nixpkgs-stable=${inputs.nixpkgs-stable.outPath}" "pkgs=${pkgs}"];

# Broken Haskell Package

    - Allow broken
    - see what depends on the broken package
    - use the stable version of the dependent package

# 1Password graphical glitches

1password --disable-gpu-driver-bug-workarounds

Disable hardware acceleration

# error infinite recursion

Sometimes it shows that error if an input is not available to a home-manager/nixos module
should supply it via specialArgs/extraSpecialArgs
