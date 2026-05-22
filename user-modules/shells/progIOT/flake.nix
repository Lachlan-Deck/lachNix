{
  description = "Flask + MQTT dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {inherit system;};

    baseShell = pkgs.mkShell {
      packages = [
        pkgs.python313
        pkgs.python313Packages.pip
        pkgs.python313Packages.virtualenv

        pkgs.mosquitto

        pkgs.pkg-config
        pkgs.gcc
        pkgs.curl
        pkgs.jq
      ];
      shellHook = ''
        echo "🐍 Flask + MQTT dev shell"
        python --version

        # setup venv
        if [ ! -d .venv ]; then
          python -m venv .venv
        fi

        source .venv/bin/activate
        pip install --upgrade pip

        # install deps once
        if [ ! -f .venv/.deps_installed ]; then
          echo "Installing Python deps..."
          pip install flask paho-mqtt python-dotenv
          touch .venv/.deps_installed
        fi

        echo ""
        echo "────────── Usage ──────────"
        echo "Run a Flask app:"
        echo "  DEVICE_ID=room1 PORT=5000 python app.py"
        echo ""
        echo "Run multiple instances:"
        echo "  DEVICE_ID=room1 PORT=5000 python app.py"
        echo "  DEVICE_ID=room2 PORT=5001 python app.py"
        echo ""
        echo "MQTT defaults:"
        echo "  broker: localhost:1883"
        echo ""
        echo "Tip: use different DEVICE_IDs to simulate devices"
        echo "───────────────────────────"
        echo ""
        echo "──────── Dev Shells ────────"
        echo "nix develop           # default shell"
        echo "nix develop .#mqtt    # start MQTT broker"
        echo "nix develop .#full    # run full simulation"
        echo "────────────────────────────"
      '';
    };
  in {
    devShells.${system} = {
      # default: no services
      default = baseShell;

      # mqtt shell: starts broker
      mqtt = pkgs.mkShell {
        inputsFrom = [baseShell];

        shellHook =
          baseShell.shellHook
          + ''
            echo ""
            echo "Starting Mosquitto (mqtt shell)..."

            if ! pgrep mosquitto > /dev/null; then
              mosquitto -d
            else
              echo "Mosquitto already running"
            fi

            echo ""
            echo "Run apps with:"
            echo "  DEVICE_ID=room1 PORT=5000 python app.py"
            echo "  DEVICE_ID=room2 PORT=5001 python app.py"
          '';
      };

      # full simulation shell (optional but powerful)
      full = pkgs.mkShell {
        inputsFrom = [baseShell];

        shellHook =
          baseShell.shellHook
          + ''
            echo ""
            echo "🚀 Starting full local simulation..."

            if ! pgrep mosquitto > /dev/null; then
              mosquitto -d
            fi

            # helper function
            run_app() {
              DEVICE_ID=$1 PORT=$2 python app.py &
            }

            run_app room1 5000
            run_app room2 5001

            echo ""
            echo "Apps running:"
            echo "  http://localhost:5000"
            echo "  http://localhost:5001"
            echo ""
            echo "Press Ctrl+C to stop..."

            wait
          '';
      };
      test = pkgs.mkShell {
        inputsFrom = [baseShell];

        shellHook =
          baseShell.shellHook
          + ''
            echo ""
            echo "🧪 Starting test environment..."

            # start broker
            if ! pgrep mosquitto > /dev/null; then
              mosquitto -d
            fi

            # start services
            echo "Starting master..."
            (cd master && DEVICE_ID=master PORT=5000 python app.py) &

            echo "Starting room..."
            (cd room && ROOM_ID=room1 PORT=5001 python app.py) &

            echo "Starting agent..."
            (cd agent && PORT=5002 python app.py) &

            # run tests
            sleep 3
            ./scripts/test-system.sh

            echo ""
            echo "Press Ctrl+C to stop everything"

            wait
          '';
      };
    };
  };
}
