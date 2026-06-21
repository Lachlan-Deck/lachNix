# parts/zellij.nix
{ inputs, lib, ... }: {

  perSystem = { pkgs, config, ... }: let
    cfg = config.programs.zellij;
    wlib = (import inputs.wrapper-modules { inherit pkgs; }).lib;

    zellijThemeSettings = wlib.toKdl {
      fg = "#ebdbb2";
      bg = "#282828";
      black = "#282828";
      red = "#cc241d";
      green = "#98971a";
      yellow = "#d79921";
      blue = "#458588";
      magenta = "#b16286";
      cyan = "#689d6a";
      white = "#a89984";
      orange = "#fe8019";
    };

    zellijConfigText = ''
      ${lib.optionalString (cfg.defaultShellPackage != null) ''
        // Targets the explicit absolute store path of selected shell package
        default_shell "${cfg.defaultShellPackage}/bin/nu"
      ''}

      theme "gruvbox-dark"

      themes {
        gruvbox-dark {
          ${zellijThemeSettings}
        }
      }

      keybinds {
        shared_except "locked" {
          bind "Alt w" { CloseFocus; }
          bind "Alt f" { MoveFocus "Up"; }
          bind "Alt s" { MoveFocus "Down"; }
          bind "Alt r" { MoveFocus "Left"; }
          bind "Alt t" { MoveFocus "Right"; }
          bind "Alt a" { GoToPreviousTab; }
          bind "Alt g" { GoToNextTab; }

          bind "Alt T" { NewTab; }
        }
      }
    '';
  in {

    options.programs.zellij = {
      enable = lib.mkEnableOption "Custom wrapped Zellij workspace manager";

      defaultShellPackage = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null; 
        example = pkgs.nushell;
        description = "The exact wrapped shell package binary that Zellij should execute as its default_shell.";
      };
    };

    config.packages.zellij = wlib.evalPackage [
      {
        inherit pkgs;
        _module.args.wlib = wlib;
      }
      ({ config, ... }: {
        imports = [
          wlib.modules.constructFiles
          wlib.modules.default
        ];

        config = {
          # Use the active module configuration text string
          package = lib.mkDefault pkgs.zellij;

          constructFiles."zellij/config.kdl" = {
            relPath = "zellij/config.kdl";
            content = zellijConfigText; 
          };
          
          # Force activation scripts to fire inside user-profile installations
          runShell = [
            {
              data = ''
                TARGET_DIR="$HOME/.config/zellij"
                mkdir -p "$TARGET_DIR"
                ln -sfn "${config.constructFiles."zellij/config.kdl".path}" "$TARGET_DIR/config.kdl"
              '';
            }
          ];
          prefixVar = [
            {
              name = "PATH-zellij";
              data = [
                "PATH"
                ":" 
                (pkgs.lib.makeBinPath (lib.optional (cfg.defaultShellPackage != null) cfg.defaultShellPackage))
              ];
            }
          ];
        };
      })
    ];
  };
}
