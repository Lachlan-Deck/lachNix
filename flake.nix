{
  inputs = {
    #nix packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # flake parts
    flake-parts.url = "github:hercules-ci/flake-parts";
    wrappers.url = "github:lassulus/wrappers";

    #linux system stuff
    xremap-flake.url = "github:xremap/nix-flake";
    hyprland.url = "github:hyprwm/Hyprland";
    stylix.url = "github:danth/stylix";

    #user space stuff
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #mac stuff
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
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({config, ...}: {
      imports = [];
      # flake parts option
      systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
      flake = let
        my_systems = config.systems;
        # Custom pkgs importer with defaults
        mkPkgs = system:
          import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = _: true;
              permittedInsecurePackages = [];
            };
          };

        mkUnstablePkgs = system:
          import unstable-nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

        # Make pkgs sets for each system
        pkgsFor = builtins.listToAttrs (map (system: {
            name = system;
            value = mkPkgs system;
          })
          my_systems);

        unstablePkgsFor = builtins.listToAttrs (map (system: {
            name = system;
            value = mkUnstablePkgs system;
          })
          my_systems);
      in {
        nixosConfigurations = {
          Tess = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [
              ./hosts/tess/configuration.nix
              inputs.stylix.nixosModules.stylix
            ];
          };

          Ashford = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [
              ./hosts/ash/configuration.nix
              inputs.stylix.nixosModules.stylix
            ];
          };
        };

        homeConfigurations = {
          "lach@Ashford" = home-manager.lib.homeManagerConfiguration {
            pkgs = unstablePkgsFor.x86_64-linux;
            extraSpecialArgs = {
              inherit inputs;
              unstable-pkgs = unstablePkgsFor.x86_64-linux;
            };
            modules = [./hosts/ash/ash-home.nix];
          };
          #home-manager switch --flake ~/lachNix#lachlandeck@Dixie --impure
          "lachlandeck@Dixie" = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              system = "aarch64-darwin";
              config.allowUnfree = true;
              overlays = [
              ];
            };

            extraSpecialArgs = {
              inherit inputs;
              unstable-pkgs = unstablePkgsFor.aarch64-darwin;
            };
            modules = [./hosts/dixie/dixie-home.nix];
          };

          # nix run github:nix-community/home-manager -- switch --flake .#lach@lachsPI
          "lach@lachsPI" = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsFor.aarch64-linux;

            extraSpecialArgs = {
              inherit inputs;
              unstable-pkgs = mkUnstablePkgs "aarch64-linux";
            };

            modules = [
              ./hosts/lachsPI/lachsPI-home.nix
            ];
          };
        };

        # sudo darwin-rebuild switch --flake ./#Dixie
        # home-manager switch --flake ~/lachNix#lachlandeck@Dixie --impure
        # bootstrap: nix run github:nix-community/home-manager -- switch --flake ~/lachNix/#lachlandeck@Dixie
        darwinConfigurations = {
          Dixie = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
              inherit inputs;
              unstable-pkgs = unstablePkgsFor.aarch64-darwin;
            };
            modules = [
              ./hosts/dixie/configuration.nix
            ];
          };
        };
      };
    });
}
