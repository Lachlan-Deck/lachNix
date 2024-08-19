{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "commitMonno-lach";
  
  src = ./CommitMono-lachV143.zip;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    ${pkgs.unzip}/bin/unzip $src -d $out/
  '';
}
