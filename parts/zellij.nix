{inputs, ...}: {
  flake.homeModules.zellij = {pkgs, ...}: {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      # enableFishIntegration = true;
      # enableBashIntegration = true;

      settings = {
        theme = "gruvbox-dark";
        keybinds = {
          "shared_except \"locked\"" = {
            "bind \"Alt w\"" = {CloseFocus = {};};
            "bind \"Alt f\"" = {MoveFocus = "Up";};
            "bind \"Alt s\"" = {MoveFocus = "Down";};
            "bind \"Alt r\"" = {MoveFocus = "Left";};
            "bind \"Alt t\"" = {MoveFocus = "Right";};
          };
        };
      };
    };
  };
}
