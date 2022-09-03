{ stdenv, fetchurl, undmg, lib }:

stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "104.0.1";

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [ "unpackPhase" "installPhase" ];
  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url = "https://download-installer.cdn.mozilla.net/pub/firefox/releases/${version}/mac/en-GB/Firefox%20${version}.dmg";
    sha256 = "/H4Wrnt2y8tihGvk/R/OwAQSNUoaNcMW0mSTGIVb8Cc=";
  };

  meta = with lib; {
    description = "The Firefox web browser";
    homepage = "https://www.mozilla.org/en-GB/firefox";
    maintainers = [ maintainers.cmacrae ];
    platforms = platforms.darwin;
  };
}
