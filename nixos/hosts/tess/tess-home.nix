# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs,  lib, config, pkgs, ... }: 

{
  imports = [
  ../../user-modules/allpkgs.nix
  ../../user-modules/lf.nix
  ../../user-modules/git.nix
  ];

  programs.home-manager = {
    enable = true;
  };
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";

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

  #Set your username
  home = {
    username = "lach";
    homeDirectory = "/home/lach/";
  };
 
}
