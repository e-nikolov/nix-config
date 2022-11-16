{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.rpi1 = nixpkgs.lib.nixosSystem {
      system = "armv7l-linux";
      modules = [
        ./configuration.nix
      ];
    };
  };
}
