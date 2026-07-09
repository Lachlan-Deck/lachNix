# parts/hosts/dixie/configuration.nix
{...}: {
  flake.darwinModules.dixie-config = {
    pkgs,
    inputs,
    self,
    ...
  }: {
    # -------- NIXPKGS CONFIGURATION -------------------------
    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
    nixpkgs.hostPlatform = "aarch64-darwin";

    # -------- SYSTEM & USER CONFIG --------------------------
    system.stateVersion = 6;
    networking.hostName = "Dixie";

    system.primaryUser = "lachlandeck";
    users.users.lachlandeck = {
      home = "/Users/lachlandeck";
      shell = pkgs.zsh;
    };

    security.pam.services.sudo_local.touchIdAuth = true;
    environment.variables.EDITOR = "hx";

    # -------- HOME MANAGER INTEGRATION ----------------------
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";
    home-manager.extraSpecialArgs = {
      inherit inputs self;
      wrappedPackages = {
        zellij = self.packages.${pkgs.stdenv.hostPlatform.system}.zellij;
      };
    };

    home-manager.users.lachlandeck = {pkgs, ...}: let
      sys = pkgs.stdenv.hostPlatform.system;
    in {
      imports = [
        self.homeManagerModules.ghostty
      ];
      home.stateVersion = "26.05";

      programs.ghostty = {
        enable = true;
      };

      home.packages = [
        self.packages.${sys}.zellij
      ];
    };
    # -------- LINUX VM ON MAC -------------------------------
    nix.linux-builder.enable = true;
    nix.enable = true;
  };
}
