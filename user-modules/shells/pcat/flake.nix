{
  description = "Development environment for pcat-ng-sem1-26 with uv and Playwright";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          docker
          colima
          uv
          python312
        ];

        shellHook = ''
          echo "========================================================="
          echo " 🛠️  Environment: PCAT Scraper (External Flake Mode)"
          echo " 📂 Working Dir: $PWD"
          echo "========================================================="

          # 1. Force UV to use Nix's Python interpreter for creating envs
          export UV_PYTHON="${pkgs.python312}/bin/python3"
          export UV_PROJECT_ROOT="$PWD"
          export PLAYWRIGHT_BROWSERS_PATH="$PWD/.cache/ms-playwright"

          # 2. Sync using the local pyproject.toml
          # (uv sync will handle creating/updating the .venv in $PWD automatically)
          if [ -f "pyproject.toml" ]; then
            echo "▶️ Syncing dependencies..."
            uv sync
          else
            echo "⚠️ Warning: No pyproject.toml found in $PWD"
          fi

          # 3. Activate the freshly synced local venv
          source .venv/bin/activate
          echo "✅ Dev environment ready."
          echo "========================================================="
        '';
      };
    });
}
