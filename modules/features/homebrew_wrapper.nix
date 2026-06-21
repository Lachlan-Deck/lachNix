# parts/my_homebrew_wrapper.nix
{inputs, ...}: {
  flake.darwinModules.homebrew-wrapper = {pkgs, ...}: {
    homebrew = {
      enable = true;

      onActivation = {
        autoUpdate = true;
        upgrade = true;
        # Removes everything not declared in this module
        cleanup = "zap";
        extraFlags = ["--force"];
      };

      taps = [];

      brews = [
        "awscli"
        "dstask"
        "freetds"
        "fzf"
        "gh"
        "jq"
        "lazygit"
        "openssh"
        "tea"
        "tuxedo"
      ];

      casks = [
        "1password"
        "discord"
        "firefox"
        "github"
        "google-chrome"
        "karabiner-elements"
        "microsoft-teams"
        "obsidian"
        "raycast"
        "slack"
        "steam"
      ];
    };
  };
}
