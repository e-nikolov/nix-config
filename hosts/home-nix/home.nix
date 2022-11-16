{ config, pkgs, id, inputs, ... }:
let
  nixpkgsPackages = with pkgs; [
  ];
in
{
  home.packages = nixpkgsPackages ++ [ ];
}
