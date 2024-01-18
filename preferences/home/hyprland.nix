{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: {
  home.packages = [pkgs.wl-clipboard];
  services = {
    polybar = {
      enable = true;
      script = ''
        # polybar bar &
      '';
      extraConfig = ''
        # [bar/mybar]
        # modules-right = date

        # [module/date]
        # type = internal/date
        # date = %Y-%m-%d%

      '';
    };
  };
}
