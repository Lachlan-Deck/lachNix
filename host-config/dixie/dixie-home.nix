#host-config/dixie/dixie-home.nix
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../user-modules/allpkgs.nix
    ../../user-modules/dev.nix
  ];

  allpkgs = {
    enableAllPkgs = false;
    enableDev = true; # Default: do install dev packages
  };

  #Set your username
  home = {
    username = "lachlandeck";
    homeDirectory = "/Users/lachlandeck";
  };
  home.stateVersion = "23.05";
  programs.home-manager = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "hx";
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
      ];
    };
  };
}
