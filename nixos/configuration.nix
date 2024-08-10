#mist's configuration.nix

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./NvidiaDrivers.nix
    ./miscEnable.nix
    #./styles.nix
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
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  users.users = {
    lach = {
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "lach";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["wheel" "networkmanager"];
    };
  };

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Tess";

  networking.networkmanager = {
  enable = true;
  ensureProfiles.profiles = {

    RMIT = {
      connection = {
        id = "RMIT-University";
        permissions = "";
        type = "wifi";
      };
      ipv4 = {
        dns-search = "";
        method = "auto";
      };
      ipv6 = {
        addr-gen-mode = "stable-privacy";
        dns-search = "";
        method = "auto";
      };
      wifi = {
        mac-address-blacklist = "";
        mode = "infrastructure";
        ssid = "RMIT-University";
      };
      wifi-security = {
        auth-alg = "PEAP";
        key-mgmt = "WPA & WPA2 ENTERPRISE";
      };
    };
  };
  };
  
  hardware.bluetooth.enable = true;
  system.stateVersion = "23.05";
}

