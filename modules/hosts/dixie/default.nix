# parts/hosts/dixie/default.nix
{
  self,
  inputs,
  ...
}: {
  flake.darwinConfigurations.Dixie = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {inherit inputs self;};
    modules = [
      self.darwinModules.dixie_base
      self.darwinModules.homebrew-wrapper
    ];
  };
}
