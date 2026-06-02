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
          uv
          python311 # Recommended: explicitly use 3.11 or 3.12
        ];

        shellHook = ''
          echo "========================================================="
          echo " 🛠️  Environment: PCAT Scraper (External Flake Mode)"
          echo " 📂 Working Dir: $PWD"
          echo "========================================================="

          # 1. Ensure UV looks at your current project root, not the nix-store path
          export UV_PROJECT_ROOT="$PWD"

          # 2. Tell Playwright where to find browsers if you install them via uv
          export PLAYWRIGHT_BROWSERS_PATH="$PWD/.cache/ms-playwright"

          # 3. Handle local .venv in your PROJECT root
          if [ ! -d ".venv" ]; then
            echo "▶️ Creating local .venv in $PWD..."
            uv venv
          fi

          # 4. Sync using the local pyproject.toml
          if [ -f "pyproject.toml" ]; then
            echo "▶️ Syncing dependencies..."
            uv pip install -e .
          else
            echo "⚠️ Warning: No pyproject.toml found in $PWD"
          fi

          source .venv/bin/activate
          echo "✅ Dev environment ready."
          echo "========================================================="
        '';
      };
    });
}
