#host-config/dixie/configuration.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  # -------- STUFF FOR LINUX VM ON MAC ----------------------
  # this enables the linux native builder built into darwin
  # so dixie can compile linux packages, hopefully
  #
  # -- nvm turns out its built into determinate nix
  # and you cant enable it unless darwin is managing your nix install
  nix.linux-builder.enable = true;

  # to prevent colflict with determinate nix installation
  nix.enable = true;
  # -------- STUFF FOR LINUX VM ON MAC ----------------------

  nixpkgs.hostPlatform = "aarch64-darwin";
  # Required: allow nix-darwin to manage the system
  system.stateVersion = 6;
  networking.hostName = "Dixie";
  system.primaryUser = "lachlandeck";
  users.users.lachlandeck = {
    home = "/Users/lachlandeck";
    shell = pkgs.zsh;
  };
  security.pam.services.sudo_local.touchIdAuth = true;
}
