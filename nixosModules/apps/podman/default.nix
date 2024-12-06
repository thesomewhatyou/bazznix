{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.bazznix.apps.podman.enable {
    environment.systemPackages = [pkgs.distrobox];

    virtualisation = {
      oci-containers = {backend = "podman";};

      podman = {
        enable = true;
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };
  };
}
