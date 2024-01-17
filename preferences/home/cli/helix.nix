{ config, pkgs, lib, personal-info, inputs, outputs, ... }: {
  programs.helix = {
    enable = true;
    extraPackages = [ pkgs.marksman ];
    languages = {
      # the language-server option currently requires helix from the master branch at https://github.com/helix-editor/helix/
      language-server.typescript-language-server = {
        command =
          "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
        args = [
          "--stdio"
          "--tsserver-path=${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
        ];
      };

      language = [{
        name = "rust";
        auto-format = false;
      }];
    };
    settings = {
      theme = "onedark";
      editor = { lsp.display-messages = true; };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
        esc = [ "collapse_selection" "keep_primary_selection" ];
      };
    };
  };
}
