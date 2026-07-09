# modules/suites/dev.nix
{self, ...}: {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: let
    appsSuite = [
      config.packages.ghostty
      config.packages.zellij
      config.packages.yazi
      config.packages.helix
    ];
  in {
    # Move everything into the root config block explicitly
    config = {
      programs.helix = {
        lang.nix = true;
        lsp.nixd = true;
        formatter.alejandra = true;

        # Explicitly keep everything else disabled
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

      programs.ghostty = {
        enable = true;
        commandPackage = config.packages.zellij;
      };

      # packages is now correctly aligned within the config hierarchy
      packages = {
        dev = pkgs.symlinkJoin {
          name = "dev-suite";
          paths = appsSuite;
        };
      };
    };
  };
}
