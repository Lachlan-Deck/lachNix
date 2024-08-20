{ config, lib, pkgs, modulesPath, inputs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    #from flake package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };
  environment = {
    sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    };
    systemPackages = [
      (pkgs.waybar.overrideAttrs (oldAttrs: {
       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      pkgs.mako
      pkgs.libnotify
      pkgs.swww
      pkgs.wofi
    ];
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xkb.layout = "us";
  xkb.variant = "";
}
