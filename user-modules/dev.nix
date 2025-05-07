{ inputs, lib, config, pkgs, unstable-pkgs, ... }:

{
    config = lib.mkIf config.allpkgs.enableDev {
        home.packages = with unstable-pkgs; [
            fzf
            zellij
        ];

        programs.yazi = {
        	enable = true;
    	
        };
        programs.zsh = {
          enable = true;

          initExtra = builtins.readFile ./zshrc;
        };
        
    };
    
}
