{
  withSystem,
  self,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  options.personal-info = mkOption {
    type =
      types.attrsOf (types.nullOr (types.oneOf [types.str (types.attrsOf types.str)]));
    default = {};
    description = "An attribute set for personal data.";
    example = literalExpression ''
      {
        name = "John Doe";
        email = "john.doe@gmail.com"
      }
    '';
  };

  config.flake.lib.mkHome = {
    system ? "x86_64-linux",
    extraSpecialArgs ? {},
    ...
  } @ args:
    withSystem system
    ({pkgs, ...}: (inputs.home-manager.lib.homeManagerConfiguration
      ((filterAttrs (k: v: k != "system") args) # "system" is used to set pkgs, but it is not a valid home-manager option
        // {
          inherit pkgs;

          extraSpecialArgs =
            {
              inherit inputs;
              inherit (self) outputs;
              inherit (config) personal-info;
            }
            // extraSpecialArgs;
        })));

  config.flake.lib.mkSystem = {
    system ? "x86_64-linux",
    specialArgs ? {},
    ...
  } @ args:
    withSystem system
    ({pkgs, ...}: (inputs.nixpkgs.lib.nixosSystem (args
      // {
        inherit pkgs;

        specialArgs =
          {
            inherit inputs;

            inherit (config) personal-info;
            inherit (self) outputs;
          }
          // specialArgs;
      })));
}
