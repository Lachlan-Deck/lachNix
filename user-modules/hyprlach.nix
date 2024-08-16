#unfinished, when i move onto a nix configured hyprland, this is the file ill use

{ pkgs, lib, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings {
      
    };
  };
}
