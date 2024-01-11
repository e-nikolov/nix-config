{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  vscode-insiders =
    (pkgs.vscode.override {isInsiders = true;}).overrideAttrs
    (oldAttrs: {
      meta.priority = 4;
      # src = inputs.vscode-insiders;

      src = builtins.fetchTarball {
        # url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
        url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
        # sha256 = inputs.code-insiders.meta.sha256;
        # sha256 = "sha256:023ryfx9zj7d7ghh41xixsz3yyngc2y6znkvfsrswcij67jqm8cd";
        # sha256 = "0shx8b5hbafb7kgp0wg8c5zihngv0bjlva6baqi90frzzjidh7vh";
        # sha256 = "0g6qx66mjnjgs26p526yv3gx02nan6lj3di96qjviwxbvjrfkfcc";
        sha256 = "";

        # sha256 = lib.fakeSha256;
      };
      version = "latest";

      buildInputs = oldAttrs.buildInputs ++ [pkgs.krb5];
    });
in {
  home.packages = [
    # vscode-insiders
    # pkgs.vscode
  ];

  programs.vscode = {
    enable = true;
    # enableUpdateCheck = false;
    # package = vscode-insiders;
    # package = inputs.code-insiders.vscode-insiders;
    package = pkgs.vscode-insiders;

    # extensions = with pkgs.vscode-extensions; [
    #   hashicorp.terraform
    #   _2gua.rainbow-brackets
    #   oderwat.indent-rainbow
    #   alefragnani.bookmarks
    #   bbenoist.nix
    #   golang.go
    #   jnoortheen.nix-ide
    #   arrterian.nix-env-selector
    #   (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    #     mktplcRef = {
    #       publisher = "k--kato";
    #       name = "intellij-idea-keybindings";
    #       version = "1.5.4";
    #       sha256 = "sha256-3RNwOQtq/4R13LB6MPYVI4liAT5yXcmCKlb8TBRP5fg=";
    #     };
    #     meta = with lib; {
    #       changelog = "https://github.com/kasecato/vscode-intellij-idea-keybindings/blob/master/CHANGELOG.md";
    #       description = "Port of IntelliJ IDEA key bindings for VS Code.";
    #       downloadPage = "https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings";
    #       homepage = "https://github.com/kasecato/vscode-intellij-idea-keybindings#readme";
    #       license = licenses.mit;
    #       maintainers = with maintainers; [];
    #     };
    #   })
    # ];
  };
}
