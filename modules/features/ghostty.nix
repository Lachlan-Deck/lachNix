#modules/features/ghostty.nix
{ inputs, lib, ... }: {

  perSystem = { pkgs, config, ... }: let
    cfg = config.programs.ghostty;
  in {
    
    options.programs.ghostty = {
      enable = lib.mkEnableOption "Custom wrapped Ghostty terminal";

      commandPackage = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null; 
        example = pkgs.zellij;
        description = "The package binary (like zellij or nushell) Ghostty should execute on launch.";
      };
    };

    config.packages.ghostty = let
      basePackage = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

      toGhosttySyntax = attrs: let
        mkLine = k: v:
          if builtins.isList v
          then lib.concatMapStringsSep "\n" (item: "${k} = ${toString item}") v
          else "${k} = ${toString v}";
      in
        lib.concatStringsSep "\n" (lib.mapAttrsToList mkLine attrs);

      ghosttyTheme = {
        background = "282828";
        foreground = "ebdbb2";
        "cursor-color" = "928374";
        "selection-background" = "504945";
        "selection-foreground" = "ebdbb2";
        palette = [
          "0=#282828" "1=#cc241d" "2=#98971a" "3=#d79921"
          "4=#458588" "5=#b16286" "6=#689d6a" "7=#a89984"
          "8=#928374" "9=#fb4934" "10=#b8bb26" "11=#fabd2f"
          "12=#83a598" "13=#d3869b" "14=#8ec07c" "15=#ebdbb2"
        ];
      };

      themeFile = pkgs.writeText "my-gruvbox-dark" (toGhosttySyntax ghosttyTheme);

      ghosttyConfig = {
        "font-family" = "JetBrainsMono Nerd Font";
        "font-size" = 12;
        "macos-option-as-alt" = "left";
        "keybind" = "super+t=unbind";
        theme = "${themeFile}"; 
      } // lib.optionalAttrs (cfg.commandPackage != null) {
        command = let
          pname = cfg.commandPackage.pname or "";
          rawName = (builtins.parseDrvName cfg.commandPackage.name).name;
          baseName = if lib.hasSuffix "-wrapped" pname 
                     then lib.removeSuffix "-wrapped" pname
                     else if lib.hasSuffix "-wrapped" rawName 
                     then lib.removeSuffix "-wrapped" rawName
                     else if pname != "" then pname else rawName;
        in
          if baseName == "nushell" || (lib.hasInfix "nushell" cfg.commandPackage.name)
          then "${cfg.commandPackage}/bin/nu"
          else "${cfg.commandPackage}/bin/${baseName}";
      };

      configFile = pkgs.writeText "ghostty-config" (toGhosttySyntax ghosttyConfig);
    in pkgs.symlinkJoin {
      name = "ghostty-wrapped";
      paths = [ basePackage ];
      nativeBuildInputs = [ pkgs.makeWrapper pkgs.stdenv.cc ];

      postBuild = ''
        # 1. Wrap the CLI binary as usual for terminal usage
        wrapProgram $out/bin/ghostty \
          --add-flags "--config-file=${configFile}" \
          --prefix PATH : ${lib.makeBinPath ([ pkgs.zsh ] ++ (lib.optional (cfg.commandPackage != null) cfg.commandPackage))}

        # 2. Create a compiled, native binary launcher for macOS GUI/Raycast
        if [ -d "${basePackage}/Applications/Ghostty.app" ]; then
          echo "Compiling native macOS Application trampoline..."
          
          APP_DIR="$out/Applications/Ghostty.app"
          rm -rf "$APP_DIR"
          mkdir -p "$APP_DIR/Contents/MacOS"
          
          # Copy resources so Raycast displays icons/metadata correctly
          cp "${basePackage}/Applications/Ghostty.app/Contents/Info.plist" "$APP_DIR/Contents/"
          if [ -d "${basePackage}/Applications/Ghostty.app/Contents/Resources" ]; then
            cp -R "${basePackage}/Applications/Ghostty.app/Contents/Resources" "$APP_DIR/Contents/"
          fi

          # Compile a clean C binary using execl to safely isolate the arguments passed to Ghostty
          cc -O2 -x c - -o "$APP_DIR/Contents/MacOS/ghostty" <<EOF
#include <unistd.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    // Inject custom path layout
    setenv("PATH", "${lib.makeBinPath ([ pkgs.zsh ] ++ (lib.optional (cfg.commandPackage != null) cfg.commandPackage))}:/usr/bin:/bin:/usr/sbin:/sbin", 1);
    
    // Explicitly pass the flag and path as a single combined argument
    execl(
        "${basePackage}/Applications/Ghostty.app/Contents/MacOS/ghostty",
        "ghostty",
        "--config-file=${configFile}",
        NULL
    );
    return 1;
}
EOF
        fi
      '';
    };
  };
}
