# modules/features/ghostty.nix
{lib, ...}: {
  options.perSystem = lib.mkOption {
    type = lib.types.submodule {
      options.programs.ghostty = {
        enable = lib.mkEnableOption "Custom Ghostty";
        commandPackage = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          default = null;
        };
      };
    };
  };

  flake.homeManagerModules.ghostty = {
    config,
    pkgs,
    ...
  }: {
    options.programs.ghostty = {
      enable = lib.mkEnableOption "Home Manager Ghostty";
      commandPackage = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
      };
    };

    config = lib.mkIf config.programs.ghostty.enable {
      programs.ghostty = {
        enable = true;
        package =
          if pkgs.stdenv.isDarwin
          then pkgs.ghostty-bin
          else pkgs.ghostty;
        settings = {
          "font-family" = "JetBrainsMono Nerd Font";
          "font-size" = 12;
          "macos-option-as-alt" = "left";
          "keybind" = ["super+t=unbind"];

          "background" = "282828";
          "foreground" = "ebdbb2";
          "cursor-color" = "928374";
          "selection-background" = "504945";
          "selection-foreground" = "ebdbb2";
          "palette" = [
            "0=#282828"
            "1=#cc241d"
            "2=#98971a"
            "3=#d79921"
            "4=#458588"
            "5=#b16286"
            "6=#689d6a"
            "7=#a89984"
            "8=#928374"
            "9=#fb4934"
            "10=#b8bb26"
            "11=#fabd2f"
            "12=#83a598"
            "13=#d3869b"
            "14=#8ec07c"
            "15=#ebdbb2"
          ];
        };
      };
    };
  };
}
