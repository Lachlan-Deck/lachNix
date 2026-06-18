{inputs, ...}: {
  flake.homeModules.zellij = {pkgs, ...}: {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
      # enableFishIntegration = true;
      # enableBashIntegration = true;

      settings = {
        theme = "gruvbox-dark";
        # keybinds = {
        # };
      };
    };
  };
}
