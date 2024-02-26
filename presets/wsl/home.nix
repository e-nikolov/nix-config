{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  home = {
    shellAliases = {
      ssh = "ssh.exe ";
      ssh-add = "ssh-add.exe ";
      op = "op.exe";
      wsl = "wsl.exe";
    };
    packages = [
      pkgs.krita
      pkgs.nixgl.nixGLMesa
      pkgs.nixgl.nixGLIntel
      pkgs.nixgl.nixVulkanIntel
      pkgs.nixgl.nixVulkanMesa
    ];
  };

  programs = {
    git.extraConfig = {
      gpg.ssh.program = "op-ssh-sign-wsl";
      core.sshCommand = "ssh.exe";
    };
    zsh = {
      initExtra = ''
        ### Windows WSL2 ###
        if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
          keep_current_path() {
            printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
          }

          command -v wslpath &>/dev/null && precmd_functions+=(keep_current_path)

          xc() {
            clip.exe
          }

          e() {
            explorer.exe $(wslpath -w $*)
          }

          subl() {
            subl.exe $(wp $*)
          }

          wp() {
            wslpath -w $* | sed s/wsl.localhost/wsl$/g
          }
        fi
      '';
    };
  };
}
