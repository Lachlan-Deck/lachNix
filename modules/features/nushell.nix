# modules/nushell.nix
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
    cfg = config.programs.nushell;
    selfConfig = config;
  in {
    options.programs.nushell = {
      enable = lib.mkEnableOption "Custom wrapped Nushell profile";

      editorCommand = lib.mkOption {
        type = lib.types.str;
        default = "nano";
        example = "hx";
        description = "The command string to bind to $env.EDITOR.";
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = [pkgs.helix];
        description = "Extra packages to explicitly inject into the Nushell runtime PATH context.";
      };
    };

    config.packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;
      imports = [
        ({...}: {
          "config.nu".content = ''
            $env.config = {
              show_banner: false
              edit_mode: emacs
            }
            $env.EDITOR = "${cfg.editorCommand}"

            # Custom yazi wrapper function
            def --env y [...args] {
              let tmp = (mktemp -t "yazi-cwd.XXXXXX")
              ${selfConfig.packages.yazi}/bin/yazi ...$args --cwd-file $tmp
              if ($tmp | path exists) {
                let cwd = (open $tmp | str trim)
                if ($cwd != "" and $cwd != $env.PWD) {
                  cd $cwd
                }
                rm -f $tmp
              }
            }

            # Your aliases work everywhere
            alias lg = lazygit
          '';

          "env.nu".content = ''
            $env.ENV_CONVERSIONS = {
              "PATH": {
                from_string: { |s| $s | split row (char env_sep) | where $it != "" }
                to_string: { |v| $v | path expand --no-symlink | str join (char env_sep) }
              }
            }

            # Strictly defined path (ignoring inherited host environment)
            $env.PATH = [
              ("~/.nix-profile/bin" | path expand)
              "/nix/var/nix/profiles/default/bin"
              "/run/current-system/sw/bin"
              "/opt/homebrew/bin"
              "/opt/homebrew/sbin"
              "/usr/local/bin"
              "/usr/bin"
              "/bin"
              "/usr/sbin"
              "/sbin"
            ]
          '';

          prefixVar = [
            {
              name = "PATH";
              data = [
                "PATH"
                ":"
                (pkgs.lib.makeBinPath ([
                    pkgs.fzf
                    pkgs.ripgrep
                    pkgs.nix
                  ]
                  ++ cfg.extraPackages))
              ];
            }
          ];
        })
      ];
    };
  };
}
