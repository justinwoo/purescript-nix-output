{ pkgs ? import <nixpkgs> {} }:

let
  easy-ps = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "d383972c82620a712ead4033db14110497bc2c9c";
    sha256 = "0hj85y3k0awd21j5s82hkskzp4nlzhi0qs4npnv172kaac03x8ms";
  });

  packages = import ./packages.nix { inherit pkgs; };

  getGlob = pkg: ''"${pkg}/src/**/*.purs"'';
  globs = with builtins; toString (map getGlob (attrValues packages.inputs));

in pkgs.stdenv.mkDerivation {
  name = "purescript-nix-output-demo";
  src = ./.;

  installPhase = ''
    rm -rf output # ensure we dont use stale output
    ${easy-ps.purs}/bin/purs compile ${globs} "src/**/*.purs"
    mkdir -p $out
    mv output $out
  '';
}
