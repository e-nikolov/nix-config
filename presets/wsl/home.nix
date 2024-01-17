{ config, pkgs, lib, ... }: {
  programs.git.extraConfig.gpg.ssh.program = "op-ssh-sign-wsl";
  programs.git.extraConfig.core.sshCommand = "ssh.exe";
  home.shellAliases = {
    ssh = "ssh.exe ";
    op = "op.exe";
  };

  programs.zsh = {
    initExtra = ''
      ### Windows WSL2 ###
      if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
        keep_current_path() {
          printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
        }
        precmd_functions+=(keep_current_path)

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
}
