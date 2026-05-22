{
  description = "Standalone Python dev shell (Flask + MQTT)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "aarch64-darwin"; # adjust if needed
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.python313

        # Python tooling
        pkgs.python313Packages.pip
        pkgs.python313Packages.virtualenv

        # MQTT (native libs + CLI tools)
        pkgs.mosquitto
        pkgs.mosquitto-clients

        # Common build deps (needed for some pip packages)
        pkgs.pkg-config
        pkgs.gcc
      ];

      shellHook = ''
        echo "🐍 Flask + MQTT dev shell ready"
        python --version

        # auto-create venv if missing
        if [ ! -d .venv ]; then
          python -m venv .venv
        fi

        source .venv/bin/activate

        echo "Installing Python deps (if needed)..."
        pip install --upgrade pip

        # install common deps if not already present
        pip install flask paho-mqtt python-dotenv

        echo "Ready. Run your Flask app with: flask run"
      '';
    };
  };
}
