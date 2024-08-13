{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "path:../nixvim/";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
  
  let inherit (self) outputs; in {     

    homeConfigurations = {
      "lach@Tess" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home.nix
        ];
      };
    };
  };
}
