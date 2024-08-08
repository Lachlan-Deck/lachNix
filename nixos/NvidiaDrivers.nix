{ config, lib, pkgs, modulesPath, ... }:

{
  # Enable OpenGL
  hardware.opengl = {
      enable = true;
  };
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
