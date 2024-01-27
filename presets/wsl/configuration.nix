{
  inputs,
  lib,
  pkgs,
  config,
  modulesPath,
  me,
  ...
}: let
  inherit (lib) stringAfter concatMapStrings;
  inherit (builtins) concatMap;
  cfg = config.wsl;
in {
  imports = [inputs.nixos-wsl.nixosModules.wsl];
  programs.xwayland.enable = true;

  # Fixes Home-Manager applications not appearing in Start Menu
  system.activationScripts = {
    copy-launchers = stringAfter [] ''
      copy-launchers() {
        local USER=${cfg.defaultUser}
        local HOME=/home/$USER

        for x in applications icons; do
          echo "setting up /usr/share/''${x}..."
          targets=()
          if [[ -d "$systemConfig/sw/share/$x" ]]; then
            targets+=("$systemConfig/sw/share/$x/.")
          fi

          ${concatMapStrings (
          p: ''
            if [[ -d "${p}/share/$x" ]]; then
              targets+=("${p}/share/$x/.")
            fi
          ''
        )
        config.environment.profiles}

          if (( ''${#targets[@]} != 0 )); then
            mkdir -p "/usr/share/$x"
            ${pkgs.rsync}/bin/rsync --archive --copy-dirlinks --delete-after --recursive "''${targets[@]}" "/usr/share/$x"
          else
            rm -rf "/usr/share/$x"
          fi
        done
      }

      copy-launchers
    '';
    # copy-user-launchers = stringAfter [] ''
    #   for x in applications icons; do
    #     echo "setting up /usr/share/''${x}..."
    #     targets=()
    #     if [[ -d "/home/${config.wsl.defaultUser}/.local/state/nix/profile/share/$x" ]]; then
    #       targets+=("/home/${config.wsl.defaultUser}/.local/state/nix/profile/share/$x/.")
    #     fi

    #     if (( ''${#targets[@]} != 0 )); then
    #       mkdir -p "/usr/share/$x"
    #       ${pkgs.rsync}/bin/rsync -ar --delete-after "''${targets[@]}" "/usr/share/$x"
    #     else
    #       rm -rf "/usr/share/$x"
    #     fi
    #   done
    # '';
  };
  environment.variables.NIXOS_OZONE_WL = "1";

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };
  wsl = {
    enable = true;
    startMenuLaunchers = false;
    nativeSystemd = true;
    interop.register = true;
    useWindowsDriver = true;
    # interop.preserveArgvZero = false;
    # interop.enabled = true;
    # interop.appendWindowsPath = true;
    wslConf = {
      boot.systemd = true;
      network = {
        generateResolvConf = true;
        generateHosts = false;
      };
      # automount.root = "/mnt";
    };
    defaultUser = me.username;
  };
  security.sudo.wheelNeedsPassword = true;

  services.gnome.gnome-keyring.enable = true;
}
