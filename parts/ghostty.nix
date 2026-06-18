# parts/ghostty.nix
{inputs, ...}: {
  flake.homeModules.ghostty = {pkgs, ...}: let
    #-----------------------------------
    #   it uses a different pkg on macos
    stdenvUnwrapGhostty =
      if pkgs.stdenv.isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;
    #----------------------------------
  in {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      package = stdenvUnwrapGhostty;

      settings = {
        theme = "my-gruvbox-dark";
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;
        command = "${pkgs.zsh}/bin/zsh";
        # dont ask
        # confirm-close-surface = "false";

        # Window styling options
        # window-decoration = false;
        # background-opacity = 0.95;

        # fix for zellij on mac this is a ghostty config option it wont break
        # if not on mac
        macos-option-as-alt = "left";
      };
      themes = {
        my-gruvbox-dark = {
          background = "282828";
          foreground = "ebdbb2";
          cursor-color = "928374";
          selection-background = "504945";
          selection-foreground = "ebdbb2";
          palette = [
            "0=#282828" # black
            "1=#cc241d" # red
            "2=#98971a" # green
            "3=#d79921" # yellow
            "4=#458588" # blue
            "5=#b16286" # magenta
            "6=#689d6a" # cyan
            "7=#a89984" # white
            "8=#928374" # bright black
            "9=#fb4934" # bright red
            "10=#b8bb26" # bright green
            "11=#fabd2f" # bright yellow
            "12=#83a598" # bright blue
            "13=#d3869b" # bright magenta
            "14=#8ec07c" # bright cyan
            "15=#ebdbb2" # bright white
          ];
        };
      };
    };
  };
}
