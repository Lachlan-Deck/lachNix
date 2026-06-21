# modules/helix.nix
{inputs, ...}: {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    unstable-pkgs = import inputs.unstable-nixpkgs {
      inherit system;
    };
    wlib = (import inputs.wrapper-modules {inherit pkgs;}).lib;

    helixConfigToml = pkgs.writers.writeTOML "config.toml" {
      theme = "gruvbox";
      editor = {
        lsp.display-messages = true;
      };
    };

    helixLanguagesToml = pkgs.writers.writeTOML "languages.toml" {
      language-server = {
        superhtml-lsp = {
          command = "superhtml";
          args = ["lsp"];
        };
        vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = ["--stdio"];
        };
        vscode-json-language-server = {
          command = "vscode-json-language-server";
          args = ["--stdio"];
        };
        vscode-eslint-language-server = {
          command = "vscode-eslint-language-server";
          args = ["--stdio"];
        };
        nixd = {
          command = "nixd";
          args = [];
        };
        python = {
          command = "pylsp";
          args = [];
        };
        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
        };
      };

      language = [
        {
          name = "html";
          scope = "source.html";
          file-types = ["html"];
          language-servers = ["superhtml-lsp"];
          formatter = {
            command = "superhtml";
            args = ["fmt" "--stdin"];
          };
          auto-format = true;
        }
        {
          name = "css";
          scope = "source.css";
          file-types = ["css"];
          language-servers = ["vscode-css-language-server"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "%file%"];
          };
          auto-format = true;
        }
        {
          name = "json";
          scope = "source.json";
          file-types = ["json"];
          language-servers = ["vscode-json-language-server"];
          formatter = {
            command = "prettier";
            args = ["--stdin-filepath" "%file%" "--parser" "json"];
          };
          auto-format = true;
        }
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
            command = "alejandra";
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
            command = "ruff";
            args = ["format" "-"];
          };
          auto-format = true;
        }
      ];
    };
  in {
    packages.helix = inputs.wrapper-modules.wrappers.helix.wrap {
      inherit pkgs;

      imports = [
        ({ ... }: {
          flags."--config" = "${helixConfigToml}";
          
          env.HELIX_RUNTIME = pkgs.writeTextDir "languages.toml" (builtins.readFile helixLanguagesToml);

          prefixVar = [
            {
              name = "PATH-wrapper";
              data = [
                "PATH"
                ":"
                (lib.makeBinPath [
                  pkgs.alejandra
                  pkgs.prettier
                  pkgs.python312Packages.python-lsp-server
                  pkgs.python312Packages.ruff
                  pkgs.pyright
                  pkgs.nixd
                  unstable-pkgs.vscode-langservers-extracted
                  unstable-pkgs.superhtml
                ])
              ];
            }
          ];
        })
      ];
    };
  };
}
