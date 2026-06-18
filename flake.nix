{
  inputs = {
    # nix packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrappers.url = "github:lassulus/wrappers";
    import-tree.url = "github:vic/import-tree";

    # linux system stuff
    xremap-flake.url = "github:xremap/nix-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";

    # user space stuff
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # mac stuff
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "darwin-nixpkgs";
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    unstable-nixpkgs,
    home-manager,
    wrappers,
    flake-parts,
    import-tree,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      imports = [
        ./parts/schema.nix
        (inputs.import-tree ./parts)
      ];

      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];

      # We leave the `flake` attribute block completely empty of host configurations.
      # Everything is dynamically added by the `parts/` directory files now.
      flake = {};
    });
}
