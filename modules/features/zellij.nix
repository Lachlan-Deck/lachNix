# modules/features/zellij.nix
{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    cfg = config.programs.zellij;
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

    config.packages.zellij = let
      basePackage = pkgs.zellij;

      zellijConfigText = ''
        ${lib.optionalString (cfg.defaultShellPackage != null) ''
          // Targets the explicit absolute store path of selected shell package
          default_shell "${cfg.defaultShellPackage}/bin/nu"
        ''}

        theme "gruvbox-dark"

        themes {
          gruvbox-dark {
            fg "#ebdbb2"
            bg "#282828"
            black "#282828"
            red "#cc241d"
            green "#98971a"
            yellow "#d79921"
            blue "#458588"
            magenta "#b16286"
            cyan "#689d6a"
            white "#a89984"
            orange "#fe8019"
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

            bind "super t" { NewTab; }
          }
        }
      '';

      configFile = pkgs.writeText "config.kdl" zellijConfigText;
    in
      pkgs.symlinkJoin {
        name = "zellij-wrapped";
        paths = [basePackage];
        nativeBuildInputs = [pkgs.makeWrapper];

        # ADDED THIS: Makes configFile accessible externally via config.packages.zellij.configFile
        passthru = {
          inherit configFile;
        };

        postBuild = ''
          wrapProgram $out/bin/zellij \
            --prefix PATH : ${lib.makeBinPath (lib.optional (cfg.defaultShellPackage != null) cfg.defaultShellPackage)} \
            --set ZELLIJ_CONFIG_FILE "${configFile}"
        '';
      };
  };
}
