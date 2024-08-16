{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    xremap-flake.url = "github:xremap/nix-flake"; 
    nixvim.url = "github:nix-community/nixvim";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  
  let inherit (self) outputs; in {
      
    nixosConfigurations = {

      Tess = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./tessConfig.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
      
      Ash = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./ashConfig.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      "lach" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;}; 
        modules = [
          ../../home-manager/home-config/home.nix
        ];
      };
    };

  };
}
