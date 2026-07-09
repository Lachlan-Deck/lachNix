# modules/suites/dev.nix
{self, ...}: {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: let
    appsSuite = [
      config.packages.zellij
      config.packages.yazi
      config.packages.helix
      config.packages.nushell
    ];
  in {
    config = {
      programs.helix = {
        lang.nix = true;
        lsp.nixd = true;
        formatter.alejandra = true;

        lang.html = false;
        lang.css = false;
        lang.json = false;
        lang.typescript = false;
        lang.python = false;
      };

      programs.nushell = {
        enable = true;
        editorCommand = "hx";
        extraPackages = [config.packages.helix];
      };

      programs.yazi = {
        enable = true;
        extraPackages = [config.packages.helix];
      };

      programs.zellij = {
        enable = true;
        defaultShellPackage = config.packages.nushell;
      };

      packages = {
        dev = pkgs.symlinkJoin {
          name = "dev-suite";
          paths = appsSuite;
        };
      };
    };
  };
}
