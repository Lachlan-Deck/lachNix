{ inputs, lib, config, pkgs, ... }:

{  
home.packages = with pkgs; [
    
    # browsers
    chromium
    firefox
    

    _1password-gui
    thunderbird
    go-autoconfig # auto configs imap for outlook in thunderbird, cant add email without it
    teams-for-linux
    slack
    discord
    zoom-us
    vial    

    # text editors
    obsidian
    vim


    # tools
    fzf
    gparted
    networkmanager
    alacritty
    zellij
      
    #container stuff
    docker
    boxbuddy
    distrobox
  ];

}
