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

  # make option available in flake to makeif true
  options.allpkgs = {
    enableDev = lib.mkEnableOption "get the new stuff";
  };
  config = lib.mkIf config.allpkgs.enableDev {
    home.packages = [
      pkgs.fzf
      pkgs.terraform
      pkgs.openpomodoro-cli
      unstable-pkgs.ansible_2_17
      unstable-pkgs.zellij
      unstable-pkgs.typescript-language-server
      unstable-pkgs.mongodb-compass
      pkgs.vmware-workstation
    ];
  };
}
