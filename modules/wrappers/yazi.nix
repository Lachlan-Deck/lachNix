# modules/yazi.nix
{ inputs, lib, ... }: {

  perSystem = { pkgs, config, ... }: let
    cfg = config.programs.yazi;
  in {

    options.programs.yazi = {
      enable = lib.mkEnableOption "Custom wrapped Yazi terminal file manager";

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = [ pkgs.ffmpegthumbnailer pkgs.poppler ];
        description = "Extra runtime packages (previewers, CLI tools, etc.) to expose within Yazi's PATH.";
      };
    };

    config.packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
      inherit pkgs;
      imports = [
        ({ config, lib, ... }: {
          settings.yazi = {
            mgr = {
              show_hidden = true;
            };
          };

          settings.theme = {
            manager = {
              folder = { fg = "#d79921"; };
            };
            status = {
              separator_open = {
                fg = "#504945";
                bg = "#504945";
              };
              separator_close = {
                fg = "#504945";
                bg = "#504945";
              };
            };
          };

          constructFiles = builtins.mapAttrs (n: v: {
            relPath = lib.mkForce "${n}.toml";
          }) config.settings;

          prefixVar = [
            {
              name = "PATH";
              data = [
                "PATH"
                ":"
                (pkgs.lib.makeBinPath ([
                  pkgs.fzf
                  pkgs.ripgrep
                ] ++ cfg.extraPackages))
              ];
            }
          ];
        })
      ];
    };
  };
}
