{
  config,
  pkgs,
  lib,
  ...
}: {
  # Required: identify the platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # this enables the linux native builder built into darwin
  # so dixie can compile linux packages, hopefully
  #
  # -- nvm turns out its built into determinate nix
  # and you cant enable it unless darwin is managing your nix install
  nix.linux-builder.enable = true;

  # Required: allow nix-darwin to manage the system
  system.stateVersion = 6;

  # to prevent colflict with determinate nix installation
  nix.enable = true;

  networking.hostName = "Dixie";

  #primary user (important for permissions)
  users.users.lachlandeck = {
    home = "/Users/lachlandeck";
    shell = pkgs.zsh;
  };

  # enable flakes
  # not needed, using determinate nix instead
  # nix.settings = {
  #   experimental-features = ["nix-command" "flakes"];
  # };
}
