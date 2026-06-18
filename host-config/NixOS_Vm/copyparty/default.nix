({
  pkgs,
  copyparty,
  ...
}: {
  # add the copyparty overlay to expose the package to the module
  nixpkgs.overlays = [copyparty.overlays.default];

  # (optional) install the package globally
  environment.systemPackages = [pkgs.copyparty];

  # configure the copyparty module
  services.copyparty = {
    enable = true;
    # the user to run the service as
    user = "copyparty";
    # the group to run the service as
    group = "copyparty";
    # directly maps to values in the [global] section of the copyparty config.
    # see `copyparty --help` for available options
    settings = {
      i = "0.0.0.0";
      # use lists to set multiple values
      p = [3210 3211];
      # use booleans to set binary flags
      no-reload = true;
      # using 'false' will do nothing and omit the value when generating a config
      ignored-flag = false;
    };

    # create users
    accounts = {
      # specify the account name as the key
      ed = {
        # provide the path to a file containing the password, keeping it out of /nix/store
        # must be readable by the copyparty service user
        passwordFile = "/run/keys/copyparty/ed_password";
      };
      # or do both in one go
      k.passwordFile = "/run/keys/copyparty/k_password";
    };

    # create a group
    groups = {
      # users "ed" and "k" are part of the group g1
      g1 = ["ed" "k"];
    };

    # create a volume
    volumes = {
      # create a volume at "/" (the webroot), which will
      "/" = {
        # share the contents of "/srv/copyparty"
        path = "/srv/copyparty";
        # see `copyparty --help-accounts` for available options
        access = {
          # everyone gets read-access, but
          r = "*";
          # users "ed" and "k" get read-write
          rw = ["ed" "k"];
        };
        # see `copyparty --help-flags` for available options
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 60;
          # volflag "e2d" enables the uploads database
          e2d = true;
          # "d2t" disables multimedia parsers (in case the uploads are malicious)
          d2t = true;
          # skips hashing file contents if path matches *.iso
          nohash = "\.iso$";
        };
      };
    };
    # you may increase the open file limit for the process
    openFilesLimit = 8192;
  };
})
