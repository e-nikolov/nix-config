{inputs, ...}: {
  imports = [inputs.pre-commit-hooks.flakeModule];

  perSystem = {
    pre-commit = {
      settings = {
        excludes = ["flake.lock" ".direnv"];

        hooks = {
          alejandra.enable = true;
          nil.enable = true;
          statix.enable = true;
          prettier = {
            enable = true;
            excludes = [".js" ".md" ".ts" ".nix" ".zsh" ".keep" ".profile" ".keytab" ".sh" ".colorscheme" ".envrc" ".gitignore" ".gitattributes" "Makefile" ".conf" ".toml"];
          };
          # shellcheck.enable = true;
          # shfmt.enable = true;
          # gptcommit.enable = true;
          # lychee.enable = true;
          # lychee.flags = "--timeout 5 -v";
          # typos = {
          #   enable = true;
          #   excludes = [".nix"];
          # };
          #   treefmt.package = pkgs.writeShellApplication {
          #     name = "treefmt";
          #     runtimeInputs = [
          #       pkgs.treefmt
          #       pkgs.alejandra
          #       pkgs.nodePackages.prettier
          #       pkgs.shfmt
          #     ];
          #     text = ''
          #       exec treefmt "$@"
          #     '';
          #   };
        };
      };
    };
  };
}
