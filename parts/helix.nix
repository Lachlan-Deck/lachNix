#parts/helix.nix
{inputs, ...}: {
  flake.homeModules.helix = {pkgs, ...}: let
    unstable-pkgs = import inputs.unstable-nixpkgs {
      inherit (pkgs) system;
    };
  in {
    home.packages = [
      pkgs.alejandra
      pkgs.prettier
      unstable-pkgs.vscode-langservers-extracted
      pkgs.nixd
      unstable-pkgs.superhtml
      # python stuff
      pkgs.python312Packages.python-lsp-server
      pkgs.python312Packages.ruff
      pkgs.pyright
    ];

    programs.helix = {
      enable = true;

      settings = {
        theme = "gruvbox";

        editor = {
          lsp.display-messages = true;
        };
      };

      languages = {
        language-server = {
          # HTMLpython312Packages.python-lsp-server
          superhtml-lsp = {
            command = "${unstable-pkgs.superhtml}/bin/superhtml";
            args = ["lsp"];
          };

          # CSS
          vscode-css-language-server = {
            command = "${unstable-pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
            args = ["--stdio"];
          };

          # JSON
          vscode-json-language-server = {
            command = "${unstable-pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
            args = ["--stdio"];
          };

          # ESLint (usually for JS/TS)
          vscode-eslint-language-server = {
            command = "${unstable-pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
            args = ["--stdio"];
          };
          nixd = {
            command = "${pkgs.nixd}/bin/nixd";
            args = [];
          };
          python = {
            command = "${pkgs.python312Packages.python-lsp-server}/bin/pylsp";
            args = [];
          };
          pyright = {
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = ["--stdio"];
          };
        };

        language = [
          # HTML
          {
            name = "html";
            scope = "source.html";
            file-types = ["html"];
            language-servers = ["superhtml-lsp"];
            formatter = {
              command = "${unstable-pkgs.superhtml}/bin/superhtml";
              args = ["fmt" "--stdin"];
            };
            auto-format = true;
          }

          # CSS
          {
            name = "css";
            scope = "source.css";
            file-types = ["css"];
            language-servers = ["vscode-css-language-server"];
            formatter = {
              command = "${pkgs.prettier}/bin/prettier";
              args = ["--stdin-filepath" "%file%"];
            };
            auto-format = true;
          }

          # JSON
          {
            name = "json";
            scope = "source.json";
            file-types = ["json"];
            language-servers = ["vscode-json-language-server"];
            formatter = {
              command = "${pkgs.prettier}/bin/prettier";
              args = ["--stdin-filepath" "%file%" "--parser" "json"];
            };
            auto-format = true;
          }

          # ESLint (for JS/TS linting only — not formatting)
          {
            name = "typescript";
            scope = "source.ts";
            file-types = ["ts"];
            language-servers = ["vscode-eslint-language-server"];
          }

          {
            name = "tsx";
            scope = "source.tsx";
            file-types = ["tsx"];
            language-servers = ["vscode-eslint-language-server"];
          }

          {
            name = "nix";
            scope = "source.nix";
            file-types = ["nix"];
            language-servers = ["nixd"];
            formatter = {
              command = "${pkgs.alejandra}/bin/alejandra";
              args = ["-"];
            };
            auto-format = true;
          }
          {
            name = "python";
            scope = "source.python";
            file-types = ["py"];
            language-servers = ["python" "pyright"];
            formatter = {
              command = "${pkgs.python312Packages.ruff}/bin/ruff";
              args = ["format" "-"];
            };
            auto-format = true;
          }
        ];
      };
    };
  };
}
