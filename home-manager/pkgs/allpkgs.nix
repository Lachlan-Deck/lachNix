{ inputs, lib, config, pkgs, ... }:

{  
home.packages = with pkgs; [
    firefox
    _1password-gui
    thunderbird
    gparted
    teams-for-linux
    slack
    discord
    distrobox
    go-autoconfig
    zoom-us
    # text editors
    obsidian
    vscode-fhs   
    vim
    # tools
    via
    fzf
    jdk
    parted
    docker
    networkmanager
    alacritty
    zellij
    yazi
    boxbuddy
  ];

}
