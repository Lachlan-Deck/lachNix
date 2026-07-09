# modules/features/ghostty.nix
{...}: {
  flake.homeManagerModules.ghostty = {
    pkgs,
    wrappedPackages,
    ...
  }: let
  in {
    programs.ghostty = {
      enable = true;

      package = pkgs.ghostty-bin;
      settings = {
        background = "282828";
        foreground = "ebdbb2";

        cursor-color = "928374";

        selection-background = "504945";
        selection-foreground = "ebdbb2";

        palette = [
          "0=#282828"
          "1=#cc241d"
          "2=#98971a"
          "3=#d79921"
          "4=#458588"
          "5=#b16286"
          "6=#689d6a"
          "7=#a89984"
          "8=#928374"
          "9=#fb4934"
          "10=#b8bb26"
          "11=#fabd2f"
          "12=#83a598"
          "13=#d3869b"
          "14=#8ec07c"
          "15=#ebdbb2"
        ];
        keybind = [
          "super+t=unbind"
        ];
        font-family = "JetBrainsMono Nerd Font";
        font-size = 12;

        shell-integration = "detect";
        confirm-close-surface = false;

        cursor-style = "block";
        macos-option-as-alt = true;
        copy-on-select = true;

        initial-command = "${wrappedPackages.zellij}/bin/zellij attach main";
      };
    };
  };
}
