{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./dev.nix
    # ./gui.nix
    # ./hyprland.nix 
  ];

  options.allpkgs = {
    enableAllPkgs = lib.mkEnableOption "get all the old allpgs stuff";
    enableDev = lib.mkEnableOption "get the new stuff";
  };

  config = lib.mkMerge [
    # Packages when enableAllPkgs is true
    (lib.mkIf config.allpkgs.enableAllPkgs {
      home.packages = with pkgs; [
        # browsers
        chromium
        firefox
        _1password-gui
        thunderbird
        go-autoconfig
        teams-for-linux
        slack
        discord
        zoom-us
        vial    

        # text editors
        obsidian
        vim

        # tools
        docker
        boxbuddy
        distrobox
      ];
    })
  ];
}

