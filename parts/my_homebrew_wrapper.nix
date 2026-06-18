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
        # "cmatrix"
        "dstask"
        "freetds"
        "fzf"
        "gh"
        # "glow"
        "jq"
        "lazygit"
        # "lazysql"
        # "maven"
        # "openjdk@21"
        "openssh"
        # "pandoc"
        # "sqlcmd"
        "tea"
        "tuxedo"
      ];

      casks = [
        "1password"
        # "azure-data-studio"
        # "calibre"
        "discord"
        "firefox"
        # "ghostty"
        "github"
        "google-chrome"
        # "intellij-idea"
        "karabiner-elements"
        # "libreoffice"
        # "mactex"
        "microsoft-teams"
        # "mysql-shell"
        "obsidian"
        # "onedrive"
        # "raspberry-pi-imager"
        "raycast"
        "slack"
        "steam"
      ];
    };
  };
}
