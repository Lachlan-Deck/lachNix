# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../user-modules/allpkgs.nix
    ../../user-modules/myYazelix
  ];

  allpkgs = {
    enableAllPkgs = false; # Default: don't install general packages
    enableDev = true; # Default: do install dev packages
  };
  myYazelix.enable = true;

  #Set your username
  home = {
    username = "lachlandeck";
    homeDirectory = "/Users/lachlandeck/";
  };

  home.stateVersion = "23.05";
  programs.home-manager = {
    enable = true;
  };

  home.sessionVariables = {
    EDITOR = "hx";
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
