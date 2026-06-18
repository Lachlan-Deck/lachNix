# parts/schema.nix
{lib, ...}: {
  # Declare the options so flake-parts knows how to merge them!
  options.flake = {
    darwinModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = {};
    };
    homeModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.deferredModule;
      default = {};
    };
  };
}
