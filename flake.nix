{
  description = "pepijno's patched dmenu";

  inputs.flake-utils.url = "github:numtide/flake-utils";

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
              installPhase = ''
                mkdir -p $out/bin
                cp dmenu $out/bin
                cp dmenu_path $out/bin
                cp dmenu_run $out/bin
              '';
            };
          };
          defaultPackage = packages.dmenu;
          devShell = pkgs.mkShell {
            nativeBuildInputs = buildInputs;
          };
        }
      );
}
