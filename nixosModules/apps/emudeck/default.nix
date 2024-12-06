{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.bazznix.apps.emudeck.enable) {
    environment.systemPackages = with pkgs; [emudeck];

    bazznix = {
      apps.steam.enable = lib.mkDefault true;
      services.flatpak.enable = lib.mkDefault true;
    };
  };
}
