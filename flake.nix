{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";
    xremap-flake.url = "github:xremap/nix-flake";

    hyprland.url = "github:hyprwm/Hyprland";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    unstable-nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    supportedSystems = ["x86_64-linux" "aarch64-darwin"];

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
      supportedSystems);

    unstablePkgsFor = builtins.listToAttrs (map (system: {
        name = system;
        value = mkUnstablePkgs system;
      })
      supportedSystems);
  in {
    zshrc = import ./user-modules/zsh/zshrc;

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
        pkgs = pkgsFor.x86_64-linux;
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
    };
  };
}
