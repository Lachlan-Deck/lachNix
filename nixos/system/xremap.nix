{inputs, ... }:
{
imports = [
  inputs.xremap-flake.nixosModules.default
  ];
  services.xremap = {
    enable = true;
    withGnome = true;
    yamlConfig = ''
modmap:
  - name: Global
    remap:
      CapsLock: Shift_L
      Shift_L: Ctrl_L
      Alt_R: BACKSPACE
      KEY_sysrq: DELETE

keymap:
   - remap:
      alt_L-a: Left
      alt_L-d: Down
      alt_L-f: Right
      alt_L-s: Up
      
      
    '';
  };
}
