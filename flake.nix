{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-24.11";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    with inputs;
      flake-utils.lib.eachDefaultSystem (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [];
          };

          yaml2nix = pkgs.rustPlatform.buildRustPackage {
            pname = "yaml2nix";
            version = "0.1.0";

            src = ./.;

            useFetchCargoVendor = true;

            cargoLock = {
              lockFile = ./Cargo.lock;
              outputHashes = {
                "serde-nix-0.1.0" = "sha256-flyOG50FasL5PdnBRNAJSHkb6GGkC8DvXYk1s/jUmps=";
              };
            };
          };
        in rec {
          packages = {
            inherit yaml2nix;
            default = packages.yaml2nix;
          };
        }
      );
}
