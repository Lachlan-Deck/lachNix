{ inputs, lib, config, pkgs, ... }:

{  
home.packages = with pkgs; [
    firefox
    steam 
    _1password-gui
    thunderbird
    gparted
    teams-for-linux
    slack
    discord
    distrobox
    go-autoconfig
    # text editors
    #inputs.MikNixVim.packages.${system}.default
    obsidian
    vscode-fhs   
    vim
    eclipses.eclipse-java
    # tools
    fzf
    jdk
    parted
    docker
    networkmanager
    alacritty
    #contains |nmtui-hostname |NetworkManager |nmtui-edit |nmtui-connect |nmtui |nmcli |nm-online
  ];

}
