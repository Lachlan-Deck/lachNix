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
    enableDev = true;
  };

  home = {
    username = "lach";
    homeDirectory = "/home/lach";
  };

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
