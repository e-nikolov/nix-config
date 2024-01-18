{
  pkgs,
  lib,
  inputs,
  ...
}: {
  fonts = {
    packages = [
      pkgs.material-symbols
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-monochrome-emoji
      pkgs.meslo-lgs-nf
      pkgs.roboto
      (pkgs.google-fonts.override {fonts = ["Inter"];})
      pkgs.fira-code
      pkgs.jetbrains-mono
      (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Inter" "Noto Color Emoji"];
      monospace = ["JetBrains Mono" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };
}
