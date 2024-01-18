{inputs} @ localFlake: {
  lib,
  config,
  getSystem,
  ...
} @ flake: let
  inherit (localFlake.inputs.home-manager.lib) homeManagerConfiguration;
  inherit (localFlake.inputs.nixpkgs.lib) nixosSystem filterAttrs mkOption;
  inherit (localFlake.inputs.nixpkgs.lib.types) lazyAttrsOf raw;
  inherit (localFlake.inputs.self) me;

  default-module = {
    pkgs,
    inputs,
    ...
  }: {
    home.username = me.username;
    home.homeDirectory = "/home/${me.username}";
    programs.git.userName = me.fullName;
    programs.git.userEmail = me.email;
    home.stateVersion = "23.05";
  };

  pkgsFor = system: (getSystem system).allModuleArgs.pkgs;

  mkHome = {
    system ? "x86_64-linux",
    extraSpecialArgs ? {},
    modules ? [],
    ...
  } @ args: (homeManagerConfiguration
    ((filterAttrs
        (k: v: k != "system")
        args) # "system" is used to set pkgs, but it is  not a valid home-manager option
      // {
        pkgs = pkgsFor system;
        modules = modules ++ [default-module];

        extraSpecialArgs =
          {
            inherit (localFlake) inputs;
            inherit me;
          }
          // extraSpecialArgs;
      }));

  importHome = configPath: args:
    mkHome (args // {modules = [(import configPath)];});

  mkSystem = {
    system ? "x86_64-linux",
    specialArgs ? {},
    ...
  } @ args: (nixosSystem (args
    // {
      pkgs = pkgsFor system;

      specialArgs =
        {
          inherit (localFlake) inputs;
          inherit me;
        }
        // specialArgs;
    }));
  importSystem = configPath: args:
    mkSystem (args // {modules = [(import configPath)];});
in {
  options.flake.lib = mkOption {
    type = lazyAttrsOf raw;
  };
  config.flake.lib = {
    inherit mkHome importHome mkSystem importSystem pkgsFor;
  };
}
