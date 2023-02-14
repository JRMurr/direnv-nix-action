{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells = {
          default = pkgs.mkShell { buildInputs = with pkgs; [ nixfmt act ]; };
          CI = pkgs.mkShell {
            buildInputs = with pkgs; [ hello ];
            shellHook = ''
              export TEST_VAR=TEST
            '';
          };
        };
      });
}
