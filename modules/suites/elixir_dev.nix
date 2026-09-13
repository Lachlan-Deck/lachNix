# modules/suites/elixir_dev.nix
{...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    config = {
      programs.helix = {
        lang = {
          nix = true;
          zig = false;
          html = false;
          css = false;
          json = false;
          typescript = false;
          python = false;
          elixir = true;
        };
        lsp = {
          nixd = true;
          zls = false;
          superhtml = false;
          vscode-css = false;
          vscode-json = false;
          vscode-eslint = false;
          pylsp = false;
          pyright = false;
          expert = true;
        };
        formatter = {
          alejandra = true;
          zig = false;
          superhtml = false;
          prettier = false;
          ruff = false;
          elixir = true;
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
