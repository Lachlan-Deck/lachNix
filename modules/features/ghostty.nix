# parts/ghostty.nix
{ inputs, lib, ... }: {

  perSystem = { pkgs, config, ... }: let
    cfg = config.programs.ghostty;
    wlib = (import inputs.wrapper-modules { inherit pkgs; }).lib;
  in {
    
    options.programs.ghostty = {
      enable = lib.mkEnableOption "Custom wrapped Ghostty terminal";

      commandPackage = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null; 
        example = pkgs.zellij;
        description = "The package binary (like zellij or nushell) Ghostty should execute on launch.";
      };
    };

    config.packages.ghostty = wlib.evalPackage [
      {
        inherit pkgs;
        _module.args.wlib = wlib;
      }
      ({ config, ... }: {
        imports = [
          wlib.modules.constructFiles
          wlib.modules.default
        ];

        options.ghostty.config = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = {};
        };
        options.ghostty.theme = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = {};
        };
        options.ghostty.themeName = lib.mkOption {
          type = lib.types.str;
          default = "my-gruvbox-dark";
        };

        config = let
          toGhosttySyntax = attrs: let
            mkLine = k: v:
              if builtins.isList v
              then lib.concatMapStringsSep "\n" (item: "${k} = ${toString item}") v
              else "${k} = ${toString v}";
          in
            lib.concatStringsSep "\n" (lib.mapAttrsToList mkLine attrs);
        in {
          package = lib.mkDefault (
            if pkgs.stdenv.isDarwin
            then pkgs.ghostty-bin
            else pkgs.ghostty
          );

          constructFiles."ghostty/config" = {
            relPath = "config";
            content = toGhosttySyntax (config.ghostty.config // { theme = config.ghostty.themeName; });
          };

          constructFiles."ghostty/themes" = {
            relPath = "themes/${config.ghostty.themeName}";
            content = toGhosttySyntax config.ghostty.theme;
          };
          runShell = [
            {
              data = ''
                TARGET_DIR="$HOME/.config/ghostty"
                mkdir -p "$TARGET_DIR/themes"
                ln -sfn "${config.constructFiles."ghostty/config".path}" "$TARGET_DIR/config"
                ln -sfn "${config.constructFiles."ghostty/themes".path}" "$TARGET_DIR/themes/${config.ghostty.themeName}"
              '';
            }
          ];

          ghostty.config = {
            "font-family" = "JetBrainsMono Nerd Font";
            "font-size" = 12;
            "macos-option-as-alt" = "left";
          } // lib.optionalAttrs (cfg.commandPackage != null) {
            command = if (cfg.commandPackage.pname or "") == "nushell" || (lib.hasInfix "nushell" cfg.commandPackage.name)
                      then "${cfg.commandPackage}/bin/nu"
                      else "${cfg.commandPackage}/bin/${cfg.commandPackage.pname or (builtins.parseDrvName cfg.commandPackage.name).name}";
          };
          ghostty.theme = {
            background = "282828";
            foreground = "ebdbb2";
            "cursor-color" = "928374";
            "selection-background" = "504945";
            "selection-foreground" = "ebdbb2";
            palette = [
              "0=#282828" "1=#cc241d" "2=#98971a" "3=#d79921"
              "4=#458588" "5=#b16286" "6=#689d6a" "7=#a89984"
              "8=#928374" "9=#fb4934" "10=#b8bb26" "11=#fabd2f"
              "12=#83a598" "13=#d3869b" "14=#8ec07c" "15=#ebdbb2"
            ];
          };

          prefixVar = [
            {
              name = "PATH-ghostty";
              data = [
                "PATH"
                ":"
                (pkgs.lib.makeBinPath (
                  [ pkgs.zsh ] ++ (lib.optional (cfg.commandPackage != null) cfg.commandPackage)
                ))
              ];
            }
          ];
        };
      })
    ];
  };
}
