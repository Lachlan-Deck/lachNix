{ inputs,  lib, config, pkgs, ... }:

{    
programs.git = {
  enable = true;
  userName = "lach";
  userEmail = "lachlan@decks-awash.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
}; 
}