{
  stdenv,
  fetchFromGitHub,
  bubblewrap,
  lib,
}:
stdenv.mkDerivation {
  pname = "scode";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "bindsch";
    repo = "scode";
    rev = "v0.2.0";
    sha256 = "sha256-8AC0cH2KeGB+GfgNqvlzPmjuwOCaw3p0enfBJFLqyzo=";
  };
  propagatedBuildInputs = lib.optionals stdenv.isLinux [bubblewrap];
  buildInputs = [];
  buildPhase = ''echo "no build needed"'';
  installPhase = ''
    echo "Attempt to build to $out"
    mkdir -p $out/bin

    PREFIX=$out make install
  '';

  meta = with lib; {
    description = "Safe sandbox wrapper for AI coding harnesses";
    homepage = "https://github.com/bindsch/scode";
    license = licenses.mit;
    platforms = platforms.unix; # enthält Linux + Darwin
  };
}
