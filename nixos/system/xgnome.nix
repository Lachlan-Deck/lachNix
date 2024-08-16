{ config, lib, pkgs, modulesPath, ... }:
{
  services = {
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      xkb.layout = "us";
      xkb.variant = "";
      }; 
  };
}
