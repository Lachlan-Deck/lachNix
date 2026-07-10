{
  description = "Standalone Python dev shell";

  # nix develop ~/lachNix/user-modules/shells/python3

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "aarch64-darwin"; # or aarch64-darwin, x86_64-darwin, etc
    pkgs = import nixpkgs {inherit system;};
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.python313
      ];

      shellHook = ''
        echo "🐍 Python dev shell ready"
        python --version
      '';
    };
  };
}
