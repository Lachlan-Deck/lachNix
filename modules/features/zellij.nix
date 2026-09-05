# modules/features/zellij.nix
{lib, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
    cfg = config.programs.zellij;
    basePackage = pkgs.zellij;

    zellijConfigText = ''
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

    configOnly = pkgs.runCommand "zellij-config" {} ''
      mkdir -p $out/etc/zellij
      cp ${configFile} $out/etc/zellij/config.kdl
    '';

    wrappedZellij = pkgs.symlinkJoin {
      name = "zellij-wrapped";
      paths = [basePackage configOnly];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/zellij \
          --prefix PATH : ${lib.makeBinPath (lib.optional (cfg.defaultShellPackage != null) cfg.defaultShellPackage)} \
          ${lib.optionalString (cfg.defaultShellPackage != null) ''
          --set ZELLIJ_DEFAULT_SHELL "${cfg.defaultShellPackage}/bin/nu"
        ''}
      '';
    };
  in {
    options.programs.zellij = {
      enable = lib.mkEnableOption "Custom wrapped Zellij workspace manager";

      defaultShellPackage = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        example = pkgs.nushell;
        description = ''
          The exact wrapped shell package binary that Zellij should execute as its
          default_shell.
        '';
      };
      package = lib.mkOption {
        type = lib.types.package;
        readOnly = true;
        description = "The wrapped Zellij package produced by this module.";
      };
    };
    config = {
      programs.zellij.package =
        if cfg.enable
        then wrappedZellij
        else pkgs.zellij;
      packages.zellij = config.programs.zellij.package;
    };
  };
}
