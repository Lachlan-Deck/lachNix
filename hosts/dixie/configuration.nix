{
  config,
  pkgs,
  lib,
  ...
}: {
  # Required: identify the platform
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Required: allow nix-darwin to manage the system
  system.stateVersion = 6;

  # to prevent colflict with determinate nix installation
  nix.enable = false;

  networking.hostName = "Dixie";

  #primary user (important for permissions later)
  users.users.lachlandeck = {
    home = "/Users/lachlandeck";
    shell = pkgs.zsh;
  };

  # enable flakes
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };
}
