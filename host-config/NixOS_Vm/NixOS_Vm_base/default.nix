{pkgs, ...}: {
  system.stateVersion = "22.05";

  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  services.getty.autologinUser = "test";

  users.users.test = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  security.sudo.wheelNeedsPassword = false;

  virtualisation.vmVariant.virtualisation.graphics = false;
}
