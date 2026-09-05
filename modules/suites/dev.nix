# modules/suites/dev.nix
{
  self,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: {
    config = {
      programs.helix = {
        lang = {
          nix = true;
          zig = true;
          html = false;
          css = false;
          json = false;
          typescript = false;
          python = false;
        };
        lsp = {
          nixd = true;
          zls = true;
        };
        formatter = {
          alejandra = true;
          zig = true;
        };
      };
      programs.nushell = {
        enable = true;
        editorCommand = "hx";
        # extraPackages = [config.packages.helix];
      };

      programs.yazi = {
        enable = true;
        # extraPackages = [config.packages.helix];
      };

      programs.zellij = {
        enable = true;
        # defaultShellPackage = config.packages.nushell;
      };
      packages.dev = pkgs.symlinkJoin {
        name = "dev-suite";
        paths =
          [
            config.packages.yazi
            config.packages.helix
            config.packages.nushell
          ]
          # zellij -------------------------
          ++ (
            if config.programs.zellij.enable
            then [config.packages.zellij]
            else []
          );
        # --------------------------------

        # yazi ---------------------------

        # --------------------------------

        # nushell ------------------------

        # --------------------------------

        # helix --------------------------

        # --------------------------------
      };
    };
  };
}
