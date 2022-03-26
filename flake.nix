{
  description = "pepijno's patched dmenu";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          buildInputs = with pkgs; [
            xorg.libX11
            xorg.libX11.dev
            xorg.libX11.out
            xorg.xorgproto
            xorg.libXinerama
            xorg.libXinerama.dev
            xorg.libXft
            xorg.libXft.dev
          ];
        in
        rec {
          packages = {
            dmenu = pkgs.stdenv.mkDerivation {
              inherit buildInputs;
              name = "dmenu";
              src = self;

              postPatch = ''
                sed -ri -e 's!\<(dmenu|dmenu_path|stest)\>!'"$out/bin"'/&!g' dmenu_run
                sed -ri -e 's!\<stest\>!'"$out/bin"'/&!g' dmenu_path
              '';

              preConfigure = ''
                sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk
              '';

              makeFlags = [ "CC:=$(CC)" ];
            };
          };
          defaultPackage = self.packages.${system}.dmenu;
          devShell = pkgs.mkShell {
            nativeBuildInputs = buildInputs;
          };
        }
      );
}
