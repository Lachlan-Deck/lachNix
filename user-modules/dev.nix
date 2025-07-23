{
  inputs,
  lib,
  config,
  pkgs,
  unstable-pkgs,
  ...
}: {
  imports = [
    ./zsh
    ./helix
    ./yazi
  ];
  config = lib.mkIf config.allpkgs.enableDev {
    home.packages = with unstable-pkgs; [
      fzf
      terraform
      ansible_2_17
      zellij
      typescript-language-server
      mongodb-compass
    ];
  };
}
