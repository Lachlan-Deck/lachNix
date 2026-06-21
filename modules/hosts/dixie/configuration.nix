# parts/hosts/dixie/configuration.nix
{...}: {
  flake.darwinModules.dixie_base = {
    pkgs,
    self,
    ...
  }: let
    sys = pkgs.stdenv.hostPlatform.system;
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

    # -------- LINUX VM ON MAC -------------------------------
    nix.linux-builder.enable = true;
    nix.enable = true;

    # -------- SOFTWARE TO INSTALL ---------------------------
    environment.systemPackages = [
      self.packages.${sys}.dixie-modules
    ];
  };
}
