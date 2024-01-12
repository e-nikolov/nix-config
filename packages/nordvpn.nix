{
  autoPatchelfHook,
  buildFHSEnvChroot ? false,
  buildFHSUserEnv ? false,
  dpkg,
  fetchurl,
  lib,
  stdenv,
  sysctl,
  iptables,
  iproute2,
  procps,
  cacert,
  libxml2,
  libidn2,
  zlib,
  wireguard-tools,
}: let
  pname = "nordvpn";
  version = "3.16.8";
  buildEnv =
    if builtins.typeOf buildFHSEnvChroot == "set"
    then buildFHSEnvChroot
    else buildFHSUserEnv;

  nordVPNBase = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_${version}_amd64.deb";
      sha256 = "sha256-IpyaWUqxGp/RBC48hjsheqErxHSiQ7HMHMuJlpHl8ZU=";
    };

    buildInputs = [libxml2 libidn2];
    nativeBuildInputs = [dpkg autoPatchelfHook stdenv.cc.cc.lib];
    # nativeBuildInputs =
    # [ wrapGAppsHook autoPatchelfHook dpkg stdenv.cc.cc.lib ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      dpkg --extract $src .
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      mv usr/* $out/
      mv var/ $out/
      mv etc/ $out/
      runHook postInstall
    '';
  };

  nordVPNfhs = buildEnv {
    name = "nordvpnd";
    runScript = "nordvpnd";

    # hardcoded path to /sbin/ip
    targetPkgs = pkgs:
      with pkgs; [
        nordVPNBase
        sysctl
        iptables
        iproute2
        procps
        cacert
        libxml2
        libidn2
        zlib
        wireguard-tools
      ];
  };
in
  stdenv.mkDerivation {
    inherit pname version;

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin $out/share
      ln -s ${nordVPNBase}/bin/nordvpn $out/bin
      ln -s ${nordVPNfhs}/bin/nordvpnd $out/bin
      ln -s ${nordVPNBase}/share* $out/share
      ln -s ${nordVPNBase}/var $out/
      runHook postInstall
    '';

    meta = with lib; {
      description = "CLI client for NordVPN";
      homepage = "https://www.nordvpn.com";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  }
