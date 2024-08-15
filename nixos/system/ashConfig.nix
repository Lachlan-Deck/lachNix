#ash config
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./miscEnable.nix
    ../themes/styles.nix
    ./NvidiaDrivers.nix
  ];
  
  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;# Workaround for https://github.com/NixOS/nix/issues/9574
    };
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs; # Opinionated: make flake registry and nix path match flake inputs
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  users.users = {
    lach = {
      initialPassword = "lach";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["wheel" "networkmanager" "docker"];
    };
  };
  programs.git.enable = true;
  virtualisation.docker.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "Ashford";
  networking.networkmanager = {
    enable = true;

  };
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  system.stateVersion = "23.05";
}


