# parts/hosts/dixie/default.nix
{
  self,
  inputs,
  ...
}: {
  flake.darwinModules.dixie = import ../../../host-config/dixie/configuration.nix;
  flake.homeModules.dixie = import ../../../host-config/dixie/dixie-home.nix;

  # sudo darwin-rebuild switch --flake ./#Dixie
  # home-manager switch --flake ~/lachNix#lachlandeck@Dixie --impure
  # bootstrap: nix run github:nix-community/home-manager -- switch --flake ~/lachNix/#lachlandeck@Dixie

  flake.darwinConfigurations.Dixie = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit inputs;
      unstable-pkgs = import inputs.unstable-nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    };
    modules = [
      self.darwinModules.dixie
      self.darwinModules.homebrew-wrapper
    ];
  };

  flake.homeConfigurations."lachlandeck@Dixie" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "aarch64-darwin";
      config.allowUnfree = true;
    };
    extraSpecialArgs = {
      inherit inputs;
      unstable-pkgs = import inputs.unstable-nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    };
    modules = [
      self.homeModules.dixie
      self.homeModules.helix
      self.homeModules.zellij
      self.homeModules.ghostty
    ];
  };
}
