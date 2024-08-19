# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  imports = [
    ../../user-modules/git.nix
    ../../user-modules/lf/lf.nix
    ../../user-modules/allpkgs.nix
  ];

  programs.home-manager = {
    enable = true;
  };
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.05";

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
      ];
    };
  };

  #Set your username
  home = {
    username = "lach";
    homeDirectory = "/home/lach/";
  };
 
}
