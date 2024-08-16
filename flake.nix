{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    xremap-flake.url = "github:xremap/nix-flake"; 
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  
  let inherit (self) outputs; in {
      
    nixosConfigurations = {

      tess = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./hosts/tess/configuration.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
      
      ash = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./hosts/ash/configuration.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      "lach@ash" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;}; 
        modules = [
          ./hosts/ash/ash-home.nix
        ];
      };

      "lach@tess" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;}; 
        modules = [
          ./hosts/tess/tess-home.nix
        ];
      };
    };

  };
}
