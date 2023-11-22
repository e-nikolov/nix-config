{ stdenv, lib, fetchurl, openvpn, libxml2, autoPatchelfHook, wrapGAppsHook, dpkg
, libidn2 }:

stdenv.mkDerivation rec {
  pname = "nordvpn";
  version = "3.16.8";

  src = fetchurl {
    url =
      "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_${version}_amd64.deb";
    sha256 = "sha256-IpyaWUqxGp/RBC48hjsheqErxHSiQ7HMHMuJlpHl8ZU=";
  };

  nativeBuildInputs = [ libidn2 libxml2 wrapGAppsHook autoPatchelfHook dpkg ];

  unpackPhase = ''
    dpkg -x $src unpacked
  '';

  installPhase = ''
    mkdir -p $out/
    sed -i 's;ExecStart=.*;;g' unpacked/usr/lib/systemd/system/nordvpnd.service
    cp -r unpacked/* $out/
    mv $out/usr/* $out/
    mv $out/sbin/nordvpnd $out/bin/
    rm -r $out/sbin
    # rm $out/var/lib/nordvpn/openvpn
    # ln -s ${openvpn}/bin/openvpn $out/var/lib/nordvpn/openvpn
  '';

  meta = with lib; {
    description =
      "NordVPN: Best VPN service. Online security starts with a click";
    downloadPage = "https://nordvpn.com/download/";
    homepage = "https://nordvpn.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ juliosueiras ];
    platforms = platforms.linux;
  };
}
