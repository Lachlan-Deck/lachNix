{
  description = "Standalone Python dev shell for algo/analysis assignment";

  # nix develop ~/lachNix/shells/python3

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
        pkgs.python313Packages.matplotlib
      ];

      shellHook = ''
        echo "🐍 Algos Python dev shell ready"
        python --version
      '';
    };
  };
}
