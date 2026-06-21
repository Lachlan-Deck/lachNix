# parts/schema.nix
{lib, ...}: {
  options.flake = lib.mkOption {
    type = lib.types.submoduleWith {
      modules = [
        ({...}: {
          options.darwinModules = lib.mkOption {
            type = lib.types.lazyAttrsOf lib.types.unspecified;
            default = {};
            description = "Custom nix-darwin modules exposed by this flake.";
          };
        })
      ];
    };
  };
}
