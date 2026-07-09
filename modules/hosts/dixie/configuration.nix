# parts/hosts/dixie/configuration.nix
{...}: {
  flake.darwinModules.dixie-config = {
    pkgs,
    inputs,
    self,
    ...
  }: let
    sys = pkgs.stdenv.hostPlatform.system;
    ghosttyPkg = self.packages.${sys}.ghostty;
  in {
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

    # -------- NIX-DARWIN APPS LINKING -----------------------
    environment.systemPackages = [ghosttyPkg];

    # -------- HOME MANAGER INTEGRATION ----------------------
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.extraSpecialArgs = {inherit inputs self;};

    home-manager.users.lachlandeck = {pkgs, ...}: {
      home.stateVersion = "26.05";

      imports = [
        self.homeManagerModules.ghostty
      ];

      programs.ghostty = {
        enable = true;
        commandPackage = pkgs.zellij; # Auto-launches Zellij declaratively!
      };
    };
    # -------- LINUX VM ON MAC -------------------------------
    nix.linux-builder.enable = true;
    nix.enable = true;
  };
}
