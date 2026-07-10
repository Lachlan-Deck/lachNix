{
  description = "a flake containing the stuff i need to do ziglings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    system = "aarch-64-darwin";
    pkgs = import nixpkgs {inherit system;};
  in {
    devshells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.zig_0_16
      ];
    };
  };
}
