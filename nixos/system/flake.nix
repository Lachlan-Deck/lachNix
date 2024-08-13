{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    xremap-flake.url = "github:xremap/nix-flake"; 
  };

  outputs = { self, nixpkgs, ... } @ inputs:
  
  let inherit (self) outputs; in {
      
    nixosConfigurations = {
      Tess = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            ./configuration.nix
            inputs.stylix.nixosModules.stylix
        ];
      };
    };
  };
}
