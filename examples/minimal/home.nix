{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "{{username}}";
  home.homeDirectory = "{{homedir}}";

  home.packages = [
    pkgs.hello
  ];

  home.stateVersion = "23.05";
}
