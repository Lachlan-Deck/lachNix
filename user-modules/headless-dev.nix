{
  inputs,
  lib,
  config,
  pkgs,
  unstable-pkgs,
  ...
}: {
  options.allpkgs.enableHeadlessDev =
    lib.mkEnableOption "enable development environment";

  # Always import submodules
  imports = [
    ./zsh
    ./helix
    ./yazi
  ];

  # Gate only the dev packages
  config = lib.mkIf config.allpkgs.headlessDev {
    home.packages = [
      pkgs.fzf
      # pkgs.terraform
      # pkgs.docker
      # pkgs.colima
      # pkgs.openpomodoro-cli
      pkgs.lazygit
      # pkgs.uv
      # unstable-pkgs.ansible_2_17
      unstable-pkgs.zellij
      # unstable-pkgs.typescript-language-server
      # unstable-pkgs.mongodb-compass
    ];
  };
}
