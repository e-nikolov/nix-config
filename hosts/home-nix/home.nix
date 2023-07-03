{ config, pkgs, id, inputs, ... }:
{
  home.packages = [
    pkgs.libsForQt5.kate
    pkgs.xdg-utils
    pkgs.emanote
  ];


  programs.zsh = {
    initExtra = ''
      export PATH=/bin:$PATH
      ### Windows WSL2 ###
      if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
          # bindkey '^[[3;5~' kill-word

          # if [ ! $VSCODE_GIT_ASKPASS_MAIN ]; then 
          #     bindkey '^H' backward-kill-word
          # fi

          e() {
              explorer.exe $(wslpath -w $*)
          }

          subl() {
              subl.exe $(wp $*)
          }

          wp() {
              wslpath -w $* | sed s/wsl.localhost/wsl$/g
          }

          goland() {
              powershell.exe -Command "cd C:/; goland.cmd $(wp $*)"
          }

          test() {
              cmd.exe /C echo $(wslpath -w . | sed s/wsl.localhost/wsl$/g)
          }

          xc() {
              clip.exe
          }

          xco() {
              powershell.exe -command "Get-Clipboard"
          }
      fi
    '';
  };
}
