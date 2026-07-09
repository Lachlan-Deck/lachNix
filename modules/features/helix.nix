# modules/helix.nix
{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    config,
    ...
  }: let
    unstable-pkgs = import inputs.unstable-nixpkgs {inherit system;};
    cfg = config.programs.helix;

    helixConfigToml = pkgs.writers.writeTOML "config.toml" {
      theme = "gruvbox";
      editor = {
        lsp.display-messages = true;
      };
    };

    languageServers =
      {}
      // lib.optionalAttrs cfg.lsp.superhtml {
        superhtml-lsp = {
          command = "superhtml";
          args = ["lsp"];
        };
      }
      // lib.optionalAttrs cfg.lsp.vscode-css {
        vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = ["--stdio"];
        };
      }
      // lib.optionalAttrs cfg.lsp.vscode-json {
        vscode-json-language-server = {
          command = "vscode-json-language-server";
          args = ["--stdio"];
        };
      }
      // lib.optionalAttrs cfg.lsp.vscode-eslint {
        vscode-eslint-language-server = {
          command = "vscode-eslint-language-server";
          args = ["--stdio"];
        };
      }
      // lib.optionalAttrs cfg.lsp.nixd {
        nixd = {
          command = "nixd";
          args = [];
        };
      }
      // lib.optionalAttrs cfg.lsp.pylsp {
        python = {
          command = "pylsp";
          args = [];
        };
      }
      // lib.optionalAttrs cfg.lsp.pyright {
        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
        };
      };

    languagesList =
      []
      ++ lib.optionals cfg.lang.html [
        ({
            name = "html";
            scope = "source.html";
            file-types = ["html"];
            language-servers = lib.optional cfg.lsp.superhtml "superhtml-lsp";
          }
          // lib.optionalAttrs cfg.formatter.superhtml {
            formatter = {
              command = "superhtml";
              args = ["fmt" "--stdin"];
            };
            auto-format = true;
          })
      ]
      ++ lib.optionals cfg.lang.css [
        ({
            name = "css";
            scope = "source.css";
            file-types = ["css"];
            language-servers = lib.optional cfg.lsp.vscode-css "vscode-css-language-server";
          }
          // lib.optionalAttrs cfg.formatter.prettier {
            formatter = {
              command = "prettier";
              args = ["--stdin-filepath" "%file%"];
            };
            auto-format = true;
          })
      ]
      ++ lib.optionals cfg.lang.json [
        ({
            name = "json";
            scope = "source.json";
            file-types = ["json"];
            language-servers = lib.optional cfg.lsp.vscode-json "vscode-json-language-server";
          }
          // lib.optionalAttrs cfg.formatter.prettier {
            formatter = {
              command = "prettier";
              args = ["--stdin-filepath" "%file%" "--parser" "json"];
            };
            auto-format = true;
          })
      ]
      ++ lib.optionals cfg.lang.typescript [
        {
          name = "typescript";
          scope = "source.ts";
          file-types = ["ts"];
          language-servers = lib.optional cfg.lsp.vscode-eslint "vscode-eslint-language-server";
        }
        {
          name = "tsx";
          scope = "source.tsx";
          file-types = ["tsx"];
          language-servers = lib.optional cfg.lsp.vscode-eslint "vscode-eslint-language-server";
        }
      ]
      ++ lib.optionals cfg.lang.nix [
        ({
            name = "nix";
            scope = "source.nix";
            file-types = ["nix"];
            language-servers = lib.optional cfg.lsp.nixd "nixd";
          }
          // lib.optionalAttrs cfg.formatter.alejandra {
            formatter = {
              command = "alejandra";
              args = ["-"];
            };
            auto-format = true; # Explicit true value applied cleanly at root level
          })
      ]
      ++ lib.optionals cfg.lang.python [
        ({
            name = "python";
            scope = "source.python";
            file-types = ["py"];
            language-servers = (lib.optional cfg.lsp.pylsp "python") ++ (lib.optional cfg.lsp.pyright "pyright");
          }
          // lib.optionalAttrs cfg.formatter.ruff {
            formatter = {
              command = "ruff";
              args = ["format" "-"];
            };
            auto-format = true;
          })
      ];

    runtimePackages =
      []
      ++ lib.optionals cfg.lsp.superhtml [unstable-pkgs.superhtml]
      ++ lib.optionals cfg.formatter.superhtml [unstable-pkgs.superhtml]
      ++ lib.optionals cfg.lsp.vscode-css [unstable-pkgs.vscode-langservers-extracted]
      ++ lib.optionals cfg.lsp.vscode-json [unstable-pkgs.vscode-langservers-extracted]
      ++ lib.optionals cfg.lsp.vscode-eslint [unstable-pkgs.vscode-langservers-extracted]
      ++ lib.optionals cfg.formatter.prettier [pkgs.prettier]
      ++ lib.optionals cfg.lsp.nixd [pkgs.nixd]
      ++ lib.optionals cfg.formatter.alejandra [pkgs.alejandra]
      ++ lib.optionals cfg.lsp.pylsp [pkgs.python312Packages.python-lsp-server]
      ++ lib.optionals cfg.lsp.pyright [pkgs.pyright]
      ++ lib.optionals cfg.formatter.ruff [pkgs.python312Packages.ruff];

    helixLanguagesToml = pkgs.writers.writeTOML "languages.toml" {
      language-server = languageServers;
      language = languagesList;
    };
  in {
    options.programs.helix = {
      lang = {
        html = lib.mkEnableOption "HTML language definitions" // {default = false;};
        css = lib.mkEnableOption "CSS language definitions" // {default = false;};
        json = lib.mkEnableOption "JSON language definitions" // {default = false;};
        typescript = lib.mkEnableOption "TS/TSX language definitions" // {default = false;};
        nix = lib.mkEnableOption "Nix language definitions" // {default = false;};
        python = lib.mkEnableOption "Python language definitions" // {default = false;};
      };
      lsp = {
        superhtml = lib.mkEnableOption "superhtml LSP" // {default = false;};
        vscode-css = lib.mkEnableOption "VSCode CSS LSP" // {default = false;};
        vscode-json = lib.mkEnableOption "VSCode JSON LSP" // {default = false;};
        vscode-eslint = lib.mkEnableOption "VSCode ESLint LSP" // {default = false;};
        nixd = lib.mkEnableOption "nixd LSP" // {default = false;};
        pylsp = lib.mkEnableOption "pylsp" // {default = false;};
        pyright = lib.mkEnableOption "pyright LSP" // {default = false;};
      };
      formatter = {
        superhtml = lib.mkEnableOption "superhtml formatting" // {default = false;};
        prettier = lib.mkEnableOption "prettier formatting" // {default = false;};
        alejandra = lib.mkEnableOption "alejandra formatting" // {default = false;};
        ruff = lib.mkEnableOption "ruff formatting" // {default = false;};
      };
    };

    config.packages.helix = inputs.wrapper-modules.wrappers.helix.wrap {
      inherit pkgs;
      imports = [
        ({...}: {
          # 1. Point directly to our config.toml
          flags."--config" = "${helixConfigToml}";

          # 2. Build a mock config directory and force Helix to look there using XDG_CONFIG_HOME
          env.XDG_CONFIG_HOME = pkgs.linkFarm "helix-config-dir" [
            {
              name = "helix/languages.toml";
              path = helixLanguagesToml;
            }
          ];

          # 3. Expose our runtime packages into the isolated PATH wrapper
          prefixVar = [
            {
              name = "PATH-wrapper";
              data = ["PATH" ":" (lib.makeBinPath (lib.unique runtimePackages))];
            }
          ];
        })
      ];
    };
  };
}
