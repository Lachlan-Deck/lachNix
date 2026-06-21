# parts/hosts/module-sets/dixie-modules.nix
# nix build ~/lachNix#dixie-modules
{ self, ... }: {
  perSystem = {
    pkgs,
    system,
    config, 
    ...
  }: let
    configuredSuite = {
      programs.nushell = {
        enable = true;
        editorCommand = "hx";
        extraPackages = [ config.packages.helix ];
      };

      programs.yazi = {
        enable = true;
        extraPackages = [ config.packages.helix ];
      };

      programs.zellij = {
        enable = true;
        defaultShellPackage = config.packages.nushell;
      };

      programs.ghostty = {
        enable = true;
        commandPackage = config.packages.zellij;
      };
    };

    appsSuite = [
      config.packages.ghostty
      config.packages.zellij
      config.packages.yazi
      config.packages.helix
    ];
  in {
    inherit (configuredSuite) programs;

    packages = {
      dixie-modules = pkgs.symlinkJoin {
        name = "dixie-software-suite";
        paths = appsSuite;
      };
    };
  };
}
