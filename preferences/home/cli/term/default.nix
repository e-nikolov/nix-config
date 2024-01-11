{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: let
  yakuake_autostart = pkgs.makeAutostartItem {
    name = "yakuake";
    package = pkgs.yakuake;
    srcPrefix = "org.kde.";
  };
in {
  home.packages = [
    yakuake_autostart
    pkgs.yakuake
    pkgs.konsole

    # * FONTS
    pkgs.meslo-lgs-nf
    pkgs.fira-code
    pkgs.jetbrains-mono
    pkgs.noto-fonts-monochrome-emoji
    pkgs.neofetch
  ];

  home.file.".local/share/konsole/default.keytab".source =
    ../../dotfiles/default.keytab;
  home.file.".local/share/konsole/termix.profile".source =
    ../../dotfiles/termix.profile;
  home.file.".local/bin/zotero.sh".source = ../../dotfiles/zotero.sh;
  home.file.".local/share/konsole/termix.colorscheme".text = ''
    [Background]
    Color=27,41,50
    RandomHueRange=360
    RandomSaturationRange=100

    [BackgroundFaint]
    Color=73,109,131
    RandomHueRange=360
    RandomSaturationRange=100

    [BackgroundIntense]
    Color=73,109,131
    RandomHueRange=360
    RandomSaturationRange=100

    [Color0]
    Color=252,135,79

    [Color0Faint]
    Color=232,115,59

    [Color0Intense]
    Color=66,88,102

    [Color1]
    Color=221,41,29

    [Color1Faint]
    Color=59,95,203

    [Color1Intense]
    Color=202,132,104

    [Color2]
    Color=68,204,50

    [Color2Faint]
    Color=55,89,191

    [Color2Intense]
    Color=132,200,171

    [Color3]
    Color=200,169,132

    [Color3Faint]
    Color=0,171,171

    [Color3Intense]
    Color=209,170,123

    [Color4]
    Color=85,170,81

    [Color4Faint]
    Color=3,94,139

    [Color4Intense]
    Color=104,164,202

    [Color5]
    Color=187,38,39

    [Color5Faint]
    Color=221,61,125

    [Color5Intense]
    Color=252,135,79

    [Color6]
    Color=255,170,68

    [Color6Faint]
    Color=0,163,200

    [Color6Intense]
    Color=252,135,79

    [Color7]
    Color=197,205,211

    [Color7Faint]
    Color=255,179,128

    [Color7Intense]
    Color=197,209,211

    [Foreground]
    Color=152,104,17

    [ForegroundFaint]
    Color=132,84,0

    [ForegroundIntense]
    Color=172,124,37


    [General]
    Anchor=0.5,0.5
    Blur=true
    ColorRandomization=true
    Description=Noctis Minimus
    FillStyle=Tile
    Opacity=0.9
    WallpaperFlipType=NoFlip

    Wallpaper=${config.home.homeDirectory}/.local/share/konsole/termix-bg.png
    WallpaperOpacity=0.9
  '';
  home.file.".local/share/konsole/termix-bg.png".source =
    ../../images/termix-bg.png;
  home.file.".npmrc".text = ''
    prefix = ${config.home.homeDirectory}/.npm-packages
  '';

  programs.kitty.enable = true;
  programs.alacritty.enable = true;
}
