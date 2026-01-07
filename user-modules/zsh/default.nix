{ inputs, lib, config, pkgs, ... }:

  let
    raw_zsh_config = builtins.readFile ./zshrc;
  in { 
    programs.zsh = {
      enable = true;

      initExtra = ''${raw_zsh_config}'';
    };
}
