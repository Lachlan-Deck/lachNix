{
  description = "Standalone shell for cloud assignment 2";

  # nix develop ~/lachNix/user-modules/shells/python3

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "aarch64-darwin"; # or aarch64-darwin, x86_64-darwin, etc
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.terraform
        pkgs.ansible

        (pkgs.python313.withPackages (ps:
          with ps; [
            boto3
            python-dotenv
          ]))
      ];

      shellHook = ''
        echo "🐍 Python dev shell ready"
        python --version
      '';
    };
  };
}
