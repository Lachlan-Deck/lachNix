{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    # REQUIRED on Darwin to force zsh module activation
    #   enableCompletion = true;

    initContent = lib.mkOrder 1000 ''
      # SSH agent
      if ! pgrep -u "$USER" ssh-agent > /dev/null; then
        eval "$(ssh-agent)"
        ssh-add ~/.ssh/rmitGitHub
      fi

      # PATH
      export PATH="$HOME/bin:$PATH"

      # yazi wrapper to cd on exit
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }

      # Helix runtime
      export HELIX_RUNTIME="$(dirname "$(which hx)")/../share/helix/runtime"
    '';
  };
}
