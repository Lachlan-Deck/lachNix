# parts/hosts/dixie/default.nix
# FRESH:
# the "-- switch" is not a typo
# sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin#darwin-rebuild -- switch --flake ~/lachNix#Dixie
# AFTERWARD:
# sudo darwin-rebuild switch --flake ~/lachNix#Dixie
# nix profile history -p /nix/var/nix/profiles/system
{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations.Dixie = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {inherit inputs self;};
    modules = [
      self.darwinModules.dixie-config
      self.darwinModules.homebrew-wrapper
    ];
  };
}
