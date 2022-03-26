{
  description = "pepijno's patched dmenu";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
        {
          devShell = pkgs.mkShell
            {
              nativeBuildInputs = with pkgs; [
                xorg.libX11
                xorg.libX11.dev
                xorg.libX11.out
                xorg.xorgproto
                xorg.libXinerama
                xorg.libXinerama.dev
                xorg.libXft
                xorg.libXft.dev
              ];
            };
        }
      );
}
