{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    copyparty.url = "github:9001/copyparty";
  };

  outputs = {
    self,
    nixpkgs,
    copyparty,
    ...
  }: {
    packages.aarch64-darwin = {
      NixOS_Copyparty_Vm =
        self.nixosConfigurations.NixOS_Copyparty_Vm.config.system.build.vm;

      NixOS_Vm =
        self.nixosConfigurations.NixOS_Vm.config.system.build.vm;
    };

    nixosConfigurations = {
      # use below with a linux builder for mac configured
      # nix run .#NixOS_Copyparty_Vm
      NixOS_Copyparty_Vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit copyparty;
        };
        modules = [
          copyparty.nixosModules.default
          ./NixOS_Vm_base
          ./copyparty
          {
            virtualisation.vmVariant.virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          }
        ];
      };

      # use below with a linux builder for mac configured
      # nix run .#NixOS_Vm
      NixOS_Vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./NixOS_Vm_base
          {
            virtualisation.vmVariant.virtualisation.host.pkgs = nixpkgs.legacyPackages.aarch64-darwin;
          }
        ];
      };
    };
  };
}
