# user-modules/dev.nix
{
  inputs,
  lib,
  config,
  pkgs,
  unstable-pkgs,
  ...
}: {
  options.allpkgs.enableDev =
    lib.mkEnableOption "enable development environment";

  # Always import submodules
  imports = [
    ./zsh
    ./yazi
  ];

  # Gate only the dev packages
  config = lib.mkIf config.allpkgs.enableDev {
    home.packages = [
      pkgs.fzf
      pkgs.docker
      pkgs.colima
      pkgs.lazygit
      unstable-pkgs.zellij
    ];
  };
}
