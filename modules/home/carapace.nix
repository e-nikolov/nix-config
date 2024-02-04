{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkPackageOption
    mkBefore
    mkAfter
    mkIf
    pipe
    fileContents
    splitString
    ;
  cfg = config.programs.carapace;
  bin = cfg.package + "/bin/carapace";
in {
  disabledModules = ["programs/carapace.nix"];

  meta.maintainers = with lib.maintainers; [weathercold bobvanderlinden];

  options.programs.carapace = {
    enable =
      mkEnableOption "carapace, a multi-shell multi-command argument completer";

    package = mkPackageOption pkgs "carapace" {};

    enableBashIntegration =
      mkEnableOption "Bash integration"
      // {
        default = true;
      };

    enableZshIntegration =
      mkEnableOption "Zsh integration"
      // {
        default = true;
      };

    enableFishIntegration =
      mkEnableOption "Fish integration"
      // {
        default = true;
      };

    enableNushellIntegration =
      mkEnableOption "Nushell integration"
      // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];

    programs = {
      bash.initExtra = mkIf cfg.enableBashIntegration ''
        source <(${bin} _carapace bash)
      '';

      # source <(${bin} _carapace zsh)
      zsh.completionInit = mkIf cfg.enableZshIntegration (mkAfter ''
        get-env () { echo "''${(P)1}"; }
        set-env () { export "$1=$2"; }
        unset-env () { unset "$1"; }

        function _carapace_lazy {
            source <(carapace $words[1] zsh)
        }

        # Skip the nix completer, since we're using the one from https://github.com/nix-community/nix-zsh-completions
        # compdef _carapace_lazy $(carapace --list | awk '{print $1}' | command grep -vP '(^|\s)\K(nix|podman|docker|systemctl)(?=\s|$)')
      '');

      fish.interactiveShellInit = mkIf cfg.enableFishIntegration ''
        ${bin} _carapace fish | source
      '';

      nushell = mkIf cfg.enableNushellIntegration {
        # Note, the ${"$"} below is a work-around because xgettext otherwise
        # interpret it as a Bash i18n string.
        extraEnv = ''
          let carapace_cache = "${config.xdg.cacheHome}/carapace"
          if not ($carapace_cache | path exists) {
            mkdir $carapace_cache
          }
          ${bin} _carapace nushell | save -f ${"$"}"($carapace_cache)/init.nu"
        '';
        extraConfig = ''
          source ${config.xdg.cacheHome}/carapace/init.nu
        '';
      };
    };

    xdg.configFile = mkIf (config.programs.fish.enable && cfg.enableFishIntegration) (
      # Convert the entries from `carapace --list` to empty
      # xdg.configFile."fish/completions/NAME.fish" entries.
      #
      # This is to disable fish builtin completion for each of the
      # carapace-supported completions It is in line with the instructions from
      # carapace-bin:
      #
      #   carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish
      #
      # See https://github.com/rsteube/carapace-bin#getting-started
      let
        carapaceListFile =
          pkgs.runCommandLocal "carapace-list" {
            buildInputs = [cfg.package];
          } ''
            ${bin} --list > $out
          '';
      in
        pipe carapaceListFile [
          fileContents
          (splitString "\n")
          (map (builtins.match "^([a-z0-9-]+) .*"))
          (builtins.filter
            (match: match != null && (builtins.length match) > 0))
          (map (match: builtins.head match))
          (map (name: {
            name = "fish/completions/${name}.fish";
            value = {text = "";};
          }))
          builtins.listToAttrs
        ]
    );
  };
}
