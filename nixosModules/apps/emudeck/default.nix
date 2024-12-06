{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf (config.bazznix.apps.emudeck.enable) {
    environment.systemPackages = with pkgs; [emudeck steam-rom-manager];

    bazznix = {
      apps.steam.enable = lib.mkDefault true;
      services.flatpak.enable = lib.mkDefault true;
    };
  };
}
