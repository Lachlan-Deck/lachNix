{
  inputs.wrappers.url = "github:lassulus/wrappers";

  outputs = {
    self,
    nixpkgs,
    wrappers,
  }: {
    packages.x86_64-linux.default =
      (wrappers.wrapperModules.mpv.apply {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        scripts = [pkgs.mpvScripts.mpris];
        "mpv.conf".content = ''
          vo=gpu
          hwdec=auto
        '';
        "mpv.input".content = ''
          WHEEL_UP seek 10
          WHEEL_DOWN seek -10
        '';
      }).wrapper;
  };
}
