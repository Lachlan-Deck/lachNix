{
  inputs = {
    # nix packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";

    # mac stuff
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    unstable-nixpkgs,
    wrapper-modules,
    flake-parts,
    import-tree,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      imports = [
        ./modules/hosts/dixie/schema.nix
        (inputs.import-tree ./modules)
      ];
      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
    });
}
