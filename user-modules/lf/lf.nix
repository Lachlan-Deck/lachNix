{
  pkgs,
  config,
  ...
}: {
  xdg.configFile."lf/icons".source = ./icons;

  programs.lf = {
    enable = true;
    commands = {
      editor-open = ''$nix run ~/lachNix/nixvim/ "$f"'';
      edit-dir = ''$$EDITOR .'';
      mkdirfile = ''
        ''${{
            printf "File: "
            read DIR
            mk $DIR
        }}
      '';
      home-switch = ''$home-manager switch --flake ~/lachNix#$(whoami)@$(hostname)'';
      sys-switch = ''$sudo -A nixos-rebuild --flake ~/lachNix .#"$hostname"'';
    };

    keybindings = {
      j = "sys-switch";
      l = "home-switch";
      c = "mkdirfile";
      "<delete>" = "delete";
      p = "paste";
      dd = "cut";
      y = "copy";
      "<enter>" = "editor-open";
      a = "left";
      r = "up";
      s = "down";
      t = "right";
      gh = "cd";
      "g/" = "/";
      gd = "cd ~/Downloads";
      gy = "cd ~/.config/hypr/";
      go = "cd ~/Documents";
      gc = "cd ~/.config";
      gn = "cd ~/lachNix";
      gs = "cd ~/.local/share";

    };

    settings = {
      reverse = true;
      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    extraConfig = "";
 };

}
