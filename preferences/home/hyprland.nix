{ config, pkgs, id, inputs, lib, ... }: {

  home.packages = [ pkgs.wl-clipboard ];
  services.polybar.enable = true;
  services.polybar.script = ''
    # polybar bar &
  '';
  services.polybar.extraConfig = ''
    # [bar/mybar]
    # modules-right = date

    # [module/date]
    # type = internal/date
    # date = %Y-%m-%d%

  '';
}
