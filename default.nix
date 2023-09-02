# # Shell for bootstrapping flake-enabled nix and home-manager
{
  pkgs ? let
    # If pkgs is not defined, instantiate nixpkgs from locked commit
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs_2.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
    system = builtins.currentSystem;
    overlays = []; # Explicit blank overlay to avoid interference
  in
    import nixpkgs {inherit system overlays;},
  ...
}:
pkgs.mkShell
{
  # Enable experimental features without having to specify the argument
  NIX_CONFIG = "experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    git

    sops
    gnupg
    age

    zsh
  ];

  packages = with pkgs; [
    (pkgs.buildEnv {
      name = "b00tstrap";
      paths = [./.];
      pathsToLink = ["/scripts"];
      postBuild = ''
        echo $out
        ln -s $out/scripts $out/bin
      '';
    })
  ];

  shellHook = ''

  '';
}
# (import (fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz") {
#   src = ./.;
#   system = builtins.currentSystem;
# }).shellNix

