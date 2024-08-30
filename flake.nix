{
  inputs = {

############################################################
###                      nixpkgs                         ###
############################################################
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

############################################################
###                      stylix                          ###
############################################################
    stylix.url = "github:danth/stylix";

############################################################
###                      xremap                          ###
############################################################
    xremap-flake.url = "github:xremap/nix-flake"; 

############################################################
###                      home-manager                    ###
############################################################
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

############################################################
###                      Hyprland                        ###
############################################################
    hyprland.url = "github:hyprwm/Hyprland";

############################################################
###                      nix colors                      ###
############################################################
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs:
  
  let inherit (self) outputs; in {
      
    nixosConfigurations = {

      Tess = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./hosts/tess/configuration.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
      
      Ashford = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./hosts/ash/configuration.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
    };

    homeConfigurations = {
      "lach@Ashford" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;}; 
        modules = [
          ./hosts/ash/ash-home.nix
        ];
      };

      "lach@Tess" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;}; 
        modules = [
          ./hosts/tess/tess-home.nix
        ];
      };
    };

  };
}
