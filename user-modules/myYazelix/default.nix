{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.myYazelix;
  # Create a derivation that copies the Yazelix source to a *writable* location.
  # This makes 'yazelixWritableSource' a path in the Nix store that contains
  # a mutable copy of the Yazelix flake's contents.
  yazelixWritableSource =
    pkgs.runCommand "yazelix-writable-config" {
      yazelixContent = inputs.yazelix;
      buildInputs = [pkgs.rsync]; # Ensure rsync is available
    } ''
      mkdir -p $out
      # Use rsync with --copy-links (-L) to ensure symlinks are dereferenced and their targets are copied as regular files
      rsync -a -L --exclude=".git" "$yazelixContent/" "$out/"
    '';
in {
  options.myYazelix = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to manage the Yazelix flake in ~/.config/yazelix, ensuring it is writable.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.file."yazelix" = {
      source = yazelixWritableSource;
      recursive = true;
    };
  };
}
